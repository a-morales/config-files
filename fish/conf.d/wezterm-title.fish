# Reflect the currently-running mill command in the wezterm tab title.
#
# Mill has no equivalent of ~/.sbt/1.0/*.sbt -- nothing user-global is loaded
# into every build, and there is no public per-task evaluation hook -- so this
# lives in the shell instead. That works because mill invocations are one-shot:
# fish's fish_preexec / fish_postexec line up with sbt's `beforeCommand` and its
# "back at the shell prompt" signal respectively.
#
# No-op unless $WEZTERM_PANE is set, so CI, other terminals, and `mill --bsp`
# (which Metals launches directly, never through an interactive fish) are
# unaffected.

status is-interactive; or return 0
set -q WEZTERM_PANE; or return 0
type -q wezterm; or return 0

# (neo)vim exports these to every process it spawns, so a fish started from a
# `:terminal` split -- or by an LSP client -- inherits them along with the outer
# $WEZTERM_PANE. The tab belongs to the editor there, not to us.
if set -q VIM; or set -q VIMRUNTIME; or set -q NVIM; or set -q NVIM_LISTEN_ADDRESS
    return 0
end

set -g __wezterm_mill_active 0

# OSC 9;4: state 3 = indeterminate busy, 0 = clear. wezterm paints it on the tab.
function __wezterm_osc94 --argument-names state
    printf '\e]9;4;%s;0\a' $state
end

function __wezterm_mill_preexec --on-event fish_preexec
    set -l cmd (string trim -- "$argv[1]")
    set -l parts (string split -m1 ' ' -- $cmd)
    # Matches `mill` and `./mill`; the repo's bootstrap wrapper is used either way.
    test (string replace -r '^.*/' '' -- "$parts[1]") = mill; or return 0

    set -l rest ""
    if set -q parts[2]
        set rest (string trim -- "$parts[2]")
    end

    # Check for `-w`/`--watch` on the full (untruncated) argument string, so a
    # flag past the title's truncation cutoff is never missed.
    set -l is_watch 0
    string match -qr -- '(^|\s)(-w|--watch)(\s|$)' "$rest"; and set is_watch 1

    set -l title_rest "$rest"
    if test (string length -- "$title_rest") -gt 48
        set title_rest (string sub -l 47 -- "$title_rest")…
    end

    # `wezterm cli` is ~10ms and never on a build's critical path, but it must
    # not fail the command line either.
    command wezterm cli set-tab-title (string trim -- "mill $title_rest") 2>/dev/null

    # `-w` idles between rebuilds, so it never gets a busy progress state.
    test $is_watch = 0; and __wezterm_osc94 3
    set -g __wezterm_mill_active 1
end

# Fires on every return to the prompt, including after a Ctrl-C.
# Empty title -> wezterm falls back to the tab's normal title (tabs.lua reads
# tab.tab_title first and treats "" as unset).
function __wezterm_mill_postexec --on-event fish_postexec
    test "$__wezterm_mill_active" = 1; or return 0
    set -g __wezterm_mill_active 0
    __wezterm_osc94 0
    command wezterm cli set-tab-title "" 2>/dev/null
end
