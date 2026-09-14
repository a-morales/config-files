# Brewfile — packages for a fresh machine.
# Install with:       brew bundle --file ~/.config/Brewfile
# See what's missing: brew bundle check --file ~/.config/Brewfile --verbose
#
# Curated by hand rather than taken straight from `brew bundle dump`: this is
# everything the tracked configs in this repo actually reference, plus the apps
# I use daily. Keep it that way — `dump --force` will bulldoze the comments and
# the work/optional split at the bottom.

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

# --- http / dev tooling ---
brew "curlie"
brew "httpie"
brew "jwt-cli"
brew "act"
brew "cloc"
brew "loc"
brew "tokei"
brew "graphviz"
brew "imagemagick"

# --- runtime / version managers ---
# JDKs come from SDKMAN (see fish/fish_plugins), not Homebrew.
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

# --- casks: macos tooling ---
cask "wezterm@nightly"
cask "docker/tap/sbx", trusted: true
cask "nikitabobko/tap/aerospace"
cask "hammerspoon"
cask "karabiner-elements"
cask "monarch"
