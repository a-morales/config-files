#!/usr/bin/env bash
#
# setup.sh — bootstrap these dotfiles on a fresh macOS machine.
#
# This repo IS ~/.config, so most tools find their configs once it's cloned
# into place. This script handles everything that *doesn't* fall out of that
# for free: Homebrew packages (see Brewfile), the bits that live outside
# ~/.config, secret file stubs, direnv, the fish shell, the toolchains brew
# doesn't own (SDKMAN/JDK, rust, coursier), the Claude skills links, and a few
# tool caches.
#
# Bootstrap a new machine with:
#     git clone <repo-url> ~/.config && ~/.config/setup.sh
#
# Idempotent: safe to run repeatedly. Never clobbers an existing real file
# without backing it up first.

set -euo pipefail

DOTFILES="${HOME}/.config"
TS="$(date +%Y%m%d%H%M%S)"

# ---------------------------------------------------------------------------
# logging helpers
# ---------------------------------------------------------------------------
bold=$(tput bold 2>/dev/null || true)
dim=$(tput dim 2>/dev/null || true)
green=$(tput setaf 2 2>/dev/null || true)
yellow=$(tput setaf 3 2>/dev/null || true)
red=$(tput setaf 1 2>/dev/null || true)
reset=$(tput sgr0 2>/dev/null || true)

step() { printf "\n${bold}==> %s${reset}\n" "$*"; }
ok()   { printf "  ${green}ok${reset}    %s\n" "$*"; }
info() { printf "  ${dim}..${reset}    %s\n" "$*"; }
warn() { printf "  ${yellow}warn${reset}  %s\n" "$*" >&2; }
die()  { printf "  ${red}error${reset} %s\n" "$*" >&2; exit 1; }

# Collected and printed at the end so they aren't lost in scrollback.
FOLLOWUPS=()
followup() { FOLLOWUPS+=("$*"); }

# ---------------------------------------------------------------------------
# 0. preflight
# ---------------------------------------------------------------------------
step "Preflight"

[[ "$(uname -s)" == "Darwin" ]] || die "this setup targets macOS only"

if [[ "${PWD}" != "${DOTFILES}" && "${BASH_SOURCE[0]}" != "${DOTFILES}/setup.sh" ]]; then
  warn "expected this repo at ${DOTFILES}; some steps assume that path"
fi
[[ -d "${DOTFILES}/.git" ]] || die "no git repo at ${DOTFILES} — clone the dotfiles there first"
ok "macOS, repo at ${DOTFILES}"

# ---------------------------------------------------------------------------
# 1. Homebrew + packages
# ---------------------------------------------------------------------------
step "Homebrew"

if ! command -v brew >/dev/null 2>&1; then
  info "installing Homebrew"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  # make brew available for the rest of this run
  if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [[ -x /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi
else
  ok "brew present ($(brew --version | head -1))"
fi

step "Brew bundle"
# The Brewfile's `mas` entries reinstall App Store purchases, which only works
# if the App Store is already signed in. brew bundle doesn't fail hard on that,
# it just skips them, so warn up front rather than after a 20-minute run.
if grep -q '^mas ' "${DOTFILES}/Brewfile" 2>/dev/null; then
  followup "Sign into the App Store, then re-run setup.sh so the 'mas' entries install"
fi
if [[ -f "${DOTFILES}/Brewfile" ]]; then
  info "installing packages from Brewfile (this can take a while)"
  brew bundle --file "${DOTFILES}/Brewfile" || warn "brew bundle reported failures — review output above"
  ok "brew bundle complete"
else
  warn "no Brewfile found — skipping package install"
fi

# ---------------------------------------------------------------------------
# 2. external symlinks (configs that don't live under ~/.config)
# ---------------------------------------------------------------------------
step "External symlinks"

# link <target> <link-path>
link() {
  local target="$1" link="$2"
  if [[ -L "${link}" && "$(readlink "${link}")" == "${target}" ]]; then
    ok "${link} -> ${target}"
    return
  fi
  if [[ -e "${link}" || -L "${link}" ]]; then
    mv "${link}" "${link}.backup.${TS}"
    warn "backed up existing ${link} -> ${link}.backup.${TS}"
  fi
  ln -s "${target}" "${link}"
  ok "linked ${link} -> ${target}"
}

link "${DOTFILES}/zsh/zshrc" "${HOME}/.zshrc"

# ---------------------------------------------------------------------------
# 3. Hammerspoon config path
# ---------------------------------------------------------------------------
# Hammerspoon defaults to ~/.hammerspoon/init.lua; point it at the repo copy.
step "Hammerspoon"
defaults write org.hammerspoon.Hammerspoon MJConfigFile "${DOTFILES}/hammerspoon/init.lua"
ok "Hammerspoon config -> ${DOTFILES}/hammerspoon/init.lua"
followup "Grant Hammerspoon Accessibility permission (System Settings > Privacy & Security > Accessibility)"

# ---------------------------------------------------------------------------
# 4. secret / local file stubs
# ---------------------------------------------------------------------------
# These are gitignored and sourced by the shells; create empty stubs so a
# fresh machine doesn't error on missing files. Fill them in by hand.
step "Secret stubs"

stub() {
  local f="$1"
  if [[ -e "${f}" ]]; then
    ok "exists ${f}"
  else
    mkdir -p "$(dirname "${f}")"
    printf '# Local secrets — not tracked in git. Fill in as needed.\n' > "${f}"
    info "created stub ${f}"
    followup "Populate secrets in ${f}"
  fi
}

stub "${DOTFILES}/zsh/secrets.zsh"
stub "${DOTFILES}/fish/conf.d/secrets.fish"

# ---------------------------------------------------------------------------
# 5. fish shell
# ---------------------------------------------------------------------------
step "Fish shell"

FISH_BIN="$(command -v fish || true)"
if [[ -z "${FISH_BIN}" ]]; then
  warn "fish not installed (brew bundle may have failed) — skipping shell setup"
else
  if ! grep -qxF "${FISH_BIN}" /etc/shells; then
    info "adding ${FISH_BIN} to /etc/shells (needs sudo)"
    echo "${FISH_BIN}" | sudo tee -a /etc/shells >/dev/null
  fi
  ok "fish in /etc/shells"

  if [[ "${SHELL}" != "${FISH_BIN}" ]]; then
    info "setting fish as login shell (needs password)"
    chsh -s "${FISH_BIN}" || warn "chsh failed — change your login shell manually"
  else
    ok "fish is already the login shell"
  fi

  # fisher + plugins (declared in fish/fish_plugins)
  if [[ -f "${DOTFILES}/fish/functions/fisher.fish" ]]; then
    info "installing fisher plugins"
    "${FISH_BIN}" -c "fisher update" || warn "fisher update failed — run it manually inside fish"
    ok "fisher plugins installed"
  fi
fi

# ---------------------------------------------------------------------------
# 6. toolchains installed outside Homebrew
# ---------------------------------------------------------------------------
# Three things the configs depend on that brew can't provide on its own:
#   - SDKMAN, which owns the JDKs (fish/fish_plugins pulls in sdkman-for-fish,
#     and jdtls/metals both need a JDK on PATH)
#   - a default Rust toolchain, so conform's rustfmt formatter resolves
#   - `cs setup`, which drops metals/scalafmt into the Coursier bin dir that
#     fish/config.fish adds to PATH
step "Toolchains"

if [[ -d "${HOME}/.sdkman" ]]; then
  ok "SDKMAN present"
else
  info "installing SDKMAN"
  curl -s "https://get.sdkman.io?rcupdate=false" | bash || warn "SDKMAN install failed"
fi
if [[ -s "${HOME}/.sdkman/bin/sdkman-init.sh" ]]; then
  # shellcheck disable=SC1091
  set +u; source "${HOME}/.sdkman/bin/sdkman-init.sh"; set -u
  # `sdk current java` exits 0 either way, so match on the output instead.
  if sdk current java 2>/dev/null | grep -q "Using java version"; then
    ok "JDK installed ($(sdk current java 2>/dev/null | grep "Using java version"))"
  else
    followup "Install a JDK: sdk install java <version>  (needed by jdtls and metals)"
  fi
fi

if command -v rustup >/dev/null 2>&1; then
  if rustup show active-toolchain >/dev/null 2>&1; then
    ok "rust toolchain installed"
  else
    info "installing default rust toolchain"
    rustup default stable || warn "rustup default stable failed"
  fi
else
  warn "rustup not installed — skipping rust toolchain"
fi

# Homebrew's coursier formula only gives us the `cs` launcher; `cs setup` is
# what installs metals/scalafmt into the Coursier bin dir. Gate on metals
# rather than on `cs`, which brew bundle has just put on PATH either way.
if ! command -v cs >/dev/null 2>&1; then
  warn "coursier not installed — skipping (scala/metals will not work)"
elif command -v metals >/dev/null 2>&1; then
  ok "coursier apps installed (metals on PATH)"
else
  info "running 'cs setup' (installs metals, scalafmt, ...)"
  cs setup --yes || warn "cs setup failed — run it manually"
fi

# ---------------------------------------------------------------------------
# 8. Claude skills
# ---------------------------------------------------------------------------
step "Claude skills"
if [[ -x "${DOTFILES}/claude/setup-skills.sh" ]]; then
  "${DOTFILES}/claude/setup-skills.sh"
elif [[ -f "${DOTFILES}/claude/setup-skills.sh" ]]; then
  bash "${DOTFILES}/claude/setup-skills.sh"
else
  warn "claude/setup-skills.sh not found — skipping"
fi

# ---------------------------------------------------------------------------
# 9. tool caches / post-install
# ---------------------------------------------------------------------------
step "Tool caches"
if command -v bat >/dev/null 2>&1; then
  bat cache --build >/dev/null && ok "bat theme cache built"
fi
if command -v nvim >/dev/null 2>&1; then
  # vim.pack downloads plugins on first launch; do it here so the first real
  # nvim start isn't a cold clone of every plugin in nvim/plugin/40_plugins.
  info "syncing nvim plugins (first run clones everything — be patient)"
  nvim --headless "+qa" >/dev/null 2>&1 && ok "nvim plugins synced" \
    || warn "nvim plugin sync reported errors — open nvim and check :messages"
fi

# ---------------------------------------------------------------------------
# done
# ---------------------------------------------------------------------------
step "Done"
followup "Install the Cartograph CF font by hand — wezterm/configuration.lua expects it (paid, not in Homebrew)"
followup "Grant Accessibility/Input Monitoring permissions to Karabiner-Elements and AeroSpace"
followup "Open Karabiner-Elements once to load the profile in ~/.config/karabiner"
followup "Grant WezTerm and AeroSpace Screen Recording permission (needed for window switching)"
followup "Restart your terminal (or 'exec fish') to pick up the new shell"

printf "\n${bold}Manual follow-ups:${reset}\n"
for f in "${FOLLOWUPS[@]}"; do
  printf "  • %s\n" "${f}"
done
printf "\n${green}${bold}Setup complete.${reset}\n"
