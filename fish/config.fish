if status is-interactive
    # Commands to run in interactive sessions can go here
end

eval "$(/opt/homebrew/bin/brew shellenv)"

set -U fish_greeting 
set -U fist_key_bindings fish_vi_key_bindings

set -Ux EDITOR 'nvim'
set -Ux FZF_DEFAULT_OPTS '--color=bg+:#353b49,bg:#2e3440,border:#88c0d0,spinner:#b988b0,hl:#6c7a96,fg:#c8d0e0,header:#6c7a96,info:#b988b0,pointer:#b988b0,marker:#b988b0,fg+:#c8d0e0,prompt:#b988b0,hl+:#b988b0 --cycle --layout=reverse --border --height=80% --preview-window=wrap --marker="*"'
set -Ux LS_COLORS (vivid generate nord)
set -Ux HOMEBREW_NO_AUTO_UPDATE true
set -Ux MANPAGER 'nvim +Man!'
set -gx PATH "./node_modules/.bin" $PATH
set -Ux KALEIDOSCOPE_DIR '${HOME}/Code/playground/Kaleidoscope'

alias sz='source ~/.config/fish/config.fish'
alias rd='cd (git rev-parse --show-toplevel)'
alias gs='git status'
alias gst='git status'
alias gch='git checkout'
alias gcb='git for-each-ref --format="%(refname:short)" refs/heads | sort | uniq | fzf | xargs git checkout'
alias gcr='git for-each-ref --format="%(refname:short)" refs/remotes | sort | uniq | fzf | xargs git checkout -t'
alias gcm='git checkout (git town main-branch)'
alias gdi='git diff'
alias glo='git log --oneline'
alias glog="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
alias gha='git-town hack'
alias gsy='git-town sync'
alias gitp='git clone (pbpaste)'
