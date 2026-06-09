#!/usr/bin/env bash
#
# setup.sh — bootstrap these dotfiles on a fresh macOS machine.
#
# This repo IS ~/.config, so most tools find their configs once it's cloned
# into place. This script handles everything that *doesn't* fall out of that
# for free: Homebrew packages, the bits that live outside ~/.config, secret
# file stubs, the fish shell, and a few tool caches.
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
# 7. Claude skills
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
# 8. tool caches / post-install
# ---------------------------------------------------------------------------
step "Tool caches"
if command -v bat >/dev/null 2>&1; then
  bat cache --build >/dev/null && ok "bat theme cache built"
fi

# ---------------------------------------------------------------------------
# done
# ---------------------------------------------------------------------------
step "Done"
followup "Grant Accessibility/Input Monitoring permissions to Karabiner-Elements and AeroSpace"
followup "Open Karabiner-Elements once to load the profile in ~/.config/karabiner"
followup "Restart your terminal (or 'exec fish') to pick up the new shell"

printf "\n${bold}Manual follow-ups:${reset}\n"
for f in "${FOLLOWUPS[@]}"; do
  printf "  • %s\n" "${f}"
done
printf "\n${green}${bold}Setup complete.${reset}\n"
