if not status is-interactive
    return 0
end

# Figure out which operating system we're in.
set -l os (uname)

eval "$(/opt/homebrew/bin/brew shellenv)"

set -U fish_greeting
set -U fish_key_bindings fish_vi_key_bindings

set -Ux EDITOR nvim
set -Ux FZF_DEFAULT_OPTS '--color=bg+:#232A2E,bg:#2D353B,border:#7A8478,spinner:#DBBC7F,hl:#A7C080,fg:#D3C6AA,header:#7A8478,info:#83C092,pointer:#7FBBB3,marker:#DBBC7F,fg+:#D3C6AA,prompt:#E69875,hl+:#83C092 --cycle --layout=reverse --border --height=80% --preview-window=wrap --marker="*"'
# nord theme
# set -Ux FZF_DEFAULT_OPTS '--color=bg+:#353b49,bg:#2e3440,border:#88c0d0,spinner:#b988b0,hl:#6c7a96,fg:#c8d0e0,header:#6c7a96,info:#b988b0,pointer:#b988b0,marker:#b988b0,fg+:#c8d0e0,prompt:#b988b0,hl+:#b988b0 --cycle --layout=reverse --border --height=80% --preview-window=wrap --marker="*"'
set -Ux LS_COLORS (vivid generate nord)
set -Ux HOMEBREW_NO_AUTO_UPDATE true
set -Ux MANPAGER 'nvim +Man!'
# --move forces these ahead of /opt/homebrew/bin, which `brew shellenv` (above)
# prepends to PATH on every launch. Without --move, fish_add_path is a no-op for
# entries already in the persisted universal $fish_user_paths, so homebrew wins.
fish_add_path --move "$HOME/.local/bin"
fish_add_path --move "$HOME/Library/Application Support/Coursier/bin"
fish_add_path --move "$HOME/go/bin"
fish_add_path --move "$(brew --prefix rustup)/bin"
set -Ux COURSIER_REPOSITORIES "ivy2local|central|sonatype:releases|jitpack|https://artifactory.us-east-1.bamgrid.net/artifactory/svcscommons-maven|https://artifactory.us-east-1.bamgrid.net/artifactory/apiregistry-maven|https://artifactory.us-east-1.bamgrid.net/schemareg-maven"
set -Ux FZF_MARKS_COMMAND "fzf --height 40% --reverse --header='ctrl-y:jump, ctrl-t:toggle, ctrl-d:delete' -n 1 -d ' : '"

# Secrets live in the gitignored fish/conf.d/secrets.fish — never commit them here.

alias sz='source ~/.config/fish/config.fish'
alias rd='cd (git rev-parse --show-toplevel)'
alias gs='git status'
alias gst='git status'
alias gch='git checkout'
alias gcb='git for-each-ref --format="%(refname:short)" refs/heads | sort | uniq | fzf | xargs git checkout'
alias gbrd='git for-each-ref --format="%(refname:short)" refs/heads | sort | uniq | fzf -m | xargs git branch -d'
alias gcr='git for-each-ref --format="%(refname:short)" refs/remotes | sort | uniq | fzf | xargs git checkout -t'
alias gcm='git checkout (git town config | grep "main branch" | cut -d ":" -f 2 | tr -d " ")'
alias gdi='git diff'
alias glo='git log --oneline'
alias glog="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
alias gha='git-town hack'
alias gsy='git-town sync'
alias gitp='git clone (pbpaste)'
alias pclaude='CLAUDE_CONFIG_DIR="$HOME/.claude-personal" claude'

# Add completions from stuff installed with Homebrew.
if test "$os" = Darwin
    if test -d (brew --prefix)"/share/fish/completions"
        set -p fish_complete_path (brew --prefix)/share/fish/completions
    end
    if test -d (brew --prefix)"/share/fish/vendor_completions.d"
        set -p fish_complete_path (brew --prefix)/share/fish/vendor_completions.d
    end
end


fish_ssh_agent
