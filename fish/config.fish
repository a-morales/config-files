if status is-interactive
    # Commands to run in interactive sessions can go here
end

set -gx HOMEBREW_PREFIX "/opt/homebrew";
set -gx HOMEBREW_CELLAR "/opt/homebrew/Cellar";
set -gx HOMEBREW_REPOSITORY "/opt/homebrew";
fish_add_path -gmP "/opt/homebrew/bin" "/opt/homebrew/sbin";
if test -n "$MANPATH[1]"; set -gx MANPATH '' $MANPATH; end;
if not contains "/opt/homebrew/share/info" $INFOPATH; set -gx INFOPATH "/opt/homebrew/share/info" $INFOPATH; end;

starship init fish | source

