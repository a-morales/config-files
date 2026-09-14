# Brewfile — packages for a fresh machine.
# Install with:       brew bundle --file ~/.config/Brewfile
# See what's missing: brew bundle check --file ~/.config/Brewfile --verbose
#
# Curated by hand rather than taken straight from `brew bundle dump`: this is
# everything the tracked configs in this repo actually reference, plus the apps
# I use daily. Keep it that way — `dump --force` will bulldoze the comments and
# the one-off split at the bottom.
#
# Mac App Store apps need `mas` and an App Store you're already signed into;
# `mas install` only works for apps already in your purchase history.

# --- taps ---
# Third-party taps need `trusted: true` or `brew bundle` stalls on a trust
# prompt (and `brew bundle check` can't see whether they're outdated).
tap "homebrew/services"
tap "felixkratz/formulae", trusted: true
tap "nikitabobko/tap", trusted: true
tap "coursier/formulas", trusted: true
tap "docker/tap", trusted: true

# --- shell / prompt ---
brew "fish"
brew "starship"
brew "tmux"

# --- editors ---
brew "neovim"

# --- cli core utils ---
brew "bat"
brew "fd"
brew "fzf"
brew "ripgrep"
brew "jq"
brew "fx"
brew "tree"
brew "wget"
brew "git"
brew "git-delta"
brew "git-town"
brew "gh"
brew "lazygit"
brew "gnupg"
brew "leaf-markdown-viewer"
brew "vivid"
brew "coreutils"
brew "gnu-sed"
brew "trash"

# --- http / dev tooling ---
brew "curlie"
brew "httpie"
brew "hurl"
brew "jwt-cli"
brew "act"
brew "just"
brew "cloc"
brew "loc"
brew "tokei"
brew "graphviz"
brew "imagemagick"
brew "watchman"

# --- runtime / version managers ---
# JDKs come from SDKMAN (see fish/fish_plugins), not Homebrew.
# fnm owns Node (fish/conf.d/fnm.fish, zsh/zshrc); mise covers everything else.
brew "mise"

# --- languages / build ---
brew "lua"
brew "luarocks"
brew "go"
brew "rustup"
brew "tree-sitter"
brew "tree-sitter-cli"
brew "cmake"
brew "ninja"
brew "gdb"
brew "gcc"
brew "automake"
brew "pkgconf"
brew "emscripten"
brew "xcodegen"
# `cs setup` then installs metals/scalafmt into ~/Library/Application Support/Coursier/bin,
# which fish/config.fish puts on PATH.
brew "coursier/formulas/coursier"

# --- lsp servers ---
# nvim installs no servers itself and expects these on PATH.
# See nvim/plugin/40_plugins/lsp.lua.
brew "lua-language-server"
brew "typescript-language-server"
brew "bash-language-server"
brew "jdtls"

# --- formatters ---
# See nvim/plugin/40_plugins/conform.lua (rustfmt comes from rustup).
brew "prettier"
brew "stylua"
brew "shfmt"
brew "clang-format"

# --- macos window mgmt / status bar ---
brew "felixkratz/formulae/borders"
brew "blueutil"
brew "mole"

# --- casks: terminals & editors ---
cask "wezterm@nightly"

# --- casks: window mgmt / keyboard / menu bar ---
# All of these need Accessibility (and AeroSpace also Screen Recording);
# setup.sh reminds you at the end.
cask "nikitabobko/tap/aerospace"
cask "hammerspoon"
cask "karabiner-elements"
cask "bettertouchtool"

# --- casks: macos utilities ---
cask "pearcleaner"
cask "onyx"

# --- casks: dev tooling ---
# `docker` was renamed to `docker-desktop` upstream; use the new token.
cask "docker/tap/sbx", trusted: true
cask "tableplus"
cask "claude-code"
cask "claude"

# --- casks: reading / writing / media ---
cask "the-archive"
cask "calibre"
cask "kobo"
cask "libation"
cask "iina"

# --- casks: personal ---
cask "fantastical"
cask "monarch"

# --- mac app store ---
# `mas` reinstalls from your purchase history; sign into the App Store first.
brew "mas"

mas "NotePlan", id: 1505432629
mas "ReadKit", id: 1615798039
mas "Focusito", id: 1473808464
mas "Wipr", id: 1320666476

# Safari extensions — they install as apps but only show up in Safari settings.
mas "Vimlike", id: 1584519802
