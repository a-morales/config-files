alias ls='ls -GFh'
alias ll='ls -GFhul'
alias sl='ls'

alias vim='nvim'
alias vi='nvim'

alias sz='source ~/.zshrc'

alias less=$PAGER
alias zless=$PAGER

alias rd='cd $(git rev-parse --show-toplevel)'

alias gst='git status'
alias gch='git checkout'
alias gcb='git for-each-ref --format="%(refname:short)" refs/heads | sort | uniq | fzf | xargs git checkout'
alias gcr='git for-each-ref --format="%(refname:short)" refs/remotes | sort | uniq | fzf | xargs git checkout -t'
alias gcm='git checkout $(git town main-branch)'
alias gct='git checkout -t'
alias gdi='git diff'
alias gds='git diff --stat'
alias gbr='git branch'
alias gbdm='git checkout master && git branch --merged | grep -v "* master" | grep -v "qa" | xargs git branch -d'
alias glo='git log --oneline'
alias glog="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
alias gfe='git fetch'
alias gmom='git merge origin/master'
alias gbim='git rebase -i origin/master'
alias gha='git-town hack'
alias gsy='git-town sync'
alias gco='git commit'
alias gitp='git clone $(pbpaste)'

alias ag='ag --path-to-ignore ~/.ignore'
alias rg='rg -S'
