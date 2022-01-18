# Disable git-hooks for vacuum project
export CLICOLOR=1
export LSCOLORS=Gxfxcxdxbxegedabagacad

export GREP_OPTIONS='--color=auto'
export GREP_COLOR='3;33'

export LESS='--ignore-case --raw-control-chars'
export EDITOR='nvim'
export VISUAL='nvim'

export NVIM_TUI_ENABLE_TRUE_COLOR=1
export FZF_DEFAULT_COMMAND='rg --files'

export GOPATH="$HOME/Code/go"

# export JAVA_HOME=$(cs java-home)
export PATH="$HOME/.config/bin:$PATH:$HOME/Library/Application Support/Coursier/bin:$HOME/.bin/bin:$JAVA_HOME/bin:./node_modules/.bin"

# export AWS_REGION=us-east-1

export STARSHIP_CONFIG="$HOME/.config/starship/config.toml"
