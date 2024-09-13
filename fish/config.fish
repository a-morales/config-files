if status is-interactive
    # Commands to run in interactive sessions can go here
end

eval "$(/opt/homebrew/bin/brew shellenv)"

set -U fish_greeting 
set -U fist_key_bindings fish_vi_key_bindings

set -Ux FZF_DEFAULT_OPTS '--color=bg+:#353b49,bg:#2e3440,border:#88c0d0,spinner:#b988b0,hl:#6c7a96,fg:#c8d0e0,header:#6c7a96,info:#b988b0,pointer:#b988b0,marker:#b988b0,fg+:#c8d0e0,prompt:#b988b0,hl+:#b988b0 --cycle --layout=reverse --border --height=80% --preview-window=wrap --marker="*"'
set -Ux LS_COLORS (vivid generate nord)
