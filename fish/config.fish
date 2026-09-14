if not status is-interactive
    return 0
end


# Figure out which operating system we're in.
set -l os (uname)

set -U fish_greeting
set -U fish_key_bindings fish_vi_key_bindings

set -q EDITOR; or set -Ux EDITOR nvim
set -q FZF_DEFAULT_OPTS; or set -Ux FZF_DEFAULT_OPTS '--color=bg+:#232A2E,bg:#2D353B,border:#7A8478,spinner:#DBBC7F,hl:#A7C080,fg:#D3C6AA,header:#7A8478,info:#83C092,pointer:#7FBBB3,marker:#DBBC7F,fg+:#D3C6AA,prompt:#E69875,hl+:#83C092 --cycle --layout=reverse --border --height=80% --preview-window=wrap --marker="*"'
set -q HOMEBREW_NO_AUTO_UPDATE; or set -Ux HOMEBREW_NO_AUTO_UPDATE true
set -q MANPAGER; or set -Ux MANPAGER 'nvim +Man!'
set -q DOCKER_SANDBOXES_DOCKER_SIZE; or set -Ux DOCKER_SANDBOXES_DOCKER_SIZE 4g
# --move forces these ahead of /opt/homebrew/bin, which `brew shellenv` (above)
# prepends to PATH on every launch. Without --move, fish_add_path is a no-op for
# entries already in the persisted universal $fish_user_paths, so homebrew wins.
fish_add_path --move "$HOME/.local/bin"
fish_add_path --move "$HOME/Library/Application Support/Coursier/bin"
fish_add_path --move "$HOME/go/bin"
fish_add_path --move "$(brew --prefix rustup)/bin"
fish_add_path --move "$HOME/.cargo/bin"
set -q COURSIER_REPOSITORIES; or set -Ux COURSIER_REPOSITORIES "ivy2local|central|sonatype:releases|jitpack|https://artifactory.us-east-1.bamgrid.net/artifactory/svcscommons-maven|https://artifactory.us-east-1.bamgrid.net/artifactory/apiregistry-maven|https://artifactory.us-east-1.bamgrid.net/schemareg-maven"

# Secrets live in the gitignored fish/conf.d/secrets.fish — never commit them here.

alias sz='source ~/.config/fish/config.fish'
alias rd='cd (git rev-parse --show-toplevel)'
alias gs='git status'
alias gst='git status'
alias gch='git checkout'
alias gdi='git diff'
alias glo='git log --oneline'
alias glog="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
alias gha='git-town hack'
alias gsy='git-town sync'
alias gitp='git clone (pbpaste)'

set -l brew_prefix (brew --prefix)
if test -d "$brew_prefix/share/fish/completions"
    set -p fish_complete_path "$brew_prefix/share/fish/completions"
end
if test -d "$brew_prefix/share/fish/vendor_completions.d"
    set -p fish_complete_path "$brew_prefix/share/fish/vendor_completions.d"
end
