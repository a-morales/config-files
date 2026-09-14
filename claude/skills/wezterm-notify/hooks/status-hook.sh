#!/bin/bash
set -u

# Always drain stdin first: Claude Code writes the hook payload there, and
# exiting without reading it can hand the caller a broken pipe.
INPUT=""
if [ ! -t 0 ]; then
  INPUT=$(cat)
fi

# A hook's own stdout/stderr is a pipe Claude Code captures, and its
# `terminalSequence` output field only permits OSC 0/1/2/9/99/777 -- OSC 1337 is
# dropped by the allowlist. So the escape has to go straight to a tty.
#
# Note that /dev/tty is NOT that tty: Claude Code spawns hooks detached from any
# controlling terminal, so opening it fails with ENXIO. Worse, `[ -w /dev/tty ]`
# still reports true -- access() succeeds where open() does not -- so a guard
# written that way would pass and then silently write nothing. Both paths below
# therefore open a tty *by name*, which needs no controlling terminal.

# Opt-in tracing: records why a run did or did not publish. Every exit path is
# traced, so "the hook never ran" can be told apart from "it ran and found no
# tty" -- which look identical from outside, both producing no output and exit 0.
#
# Enabled either by WEZTERM_NOTIFY_DEBUG, or by the mere existence of a marker
# file. The marker is what works under sbx, which does not forward its --env
# values into the hook's environment; dropping a marker in the workspace also
# means the trace lands on a bind-mounted path, readable on the host with no
# copy step. The file is never created here, so an unused install stays silent
# and leaves nothing behind.
DEBUG_LOG="${WEZTERM_NOTIFY_DEBUG:-}"
if [ -z "$DEBUG_LOG" ]; then
  for candidate in \
    "${CLAUDE_PROJECT_DIR:-}/.wezterm-notify-debug.log" \
    "$PWD/.wezterm-notify-debug.log" \
    "${HOME:-}/.wezterm-notify-debug.log"
  do
    if [ -f "$candidate" ] && [ -w "$candidate" ]; then
      DEBUG_LOG="$candidate"
      break
    fi
  done
fi

debug_log() {
  [ -n "$DEBUG_LOG" ] || return 0
  printf '%s %s\n' "$(date -u +%Y-%m-%dT%H:%M:%SZ)" "$*" \
    >> "$DEBUG_LOG" 2>/dev/null || true
}

# Host: ask WezTerm which tty backs this pane instead of guessing from the
# process tree, so the state still lands on the right pane under nesting.
resolve_pane_tty() {
  [ -n "${WEZTERM_PANE:-}" ] || return 1
  command -v wezterm >/dev/null 2>&1 || return 1
  wezterm cli list --format json 2>/dev/null |
    jq -r ".[] | select(.pane_id == $WEZTERM_PANE) | .tty_name"
}

# Container (sbx): no wezterm CLI, no WEZTERM_PANE, and the host pane device
# belongs to another VM. What *is* reachable is the PTY the sandbox session is
# attached to -- its far end is the WezTerm pane, so an OSC written there
# arrives on the same byte stream WezTerm already parses.
#
# Found by walking up the process tree rather than reading /proc/1/fd/1: when a
# session attaches to an already-running sandbox, PID 1 holds a pipe and the PTY
# belongs to the attached process instead.
resolve_container_tty() {
  # Gated on having a Linux-style /proc to walk, NOT on /.dockerenv: that marker
  # is a Docker-engine convention and is absent under other runtimes, which would
  # turn this into a silent no-op in exactly the environment it exists for.
  #
  # Reaching here already means the pane lookup declined (no WEZTERM_PANE, or no
  # wezterm CLI), so there is no host session whose pane this could steal.
  [ -r /proc/self/status ] || return 1

  # Starts at $$, not $PPID: the hook's own stdio is normally a pipe, but this
  # also covers a session where the hook itself is the process holding the PTY.
  local pid=$$ tty="" hops=0

  # Bounded: an unreadable /proc entry or a cycle must not spin the hook.
  while [ "${pid:-0}" -ge 1 ] 2>/dev/null && [ "$hops" -lt 32 ]; do
    for fd in 1 0 2; do
      tty=$(readlink "/proc/$pid/fd/$fd" 2>/dev/null)
      case "$tty" in
        /dev/pts/*) printf '%s' "$tty"; return 0 ;;
      esac
    done
    # PPid from status, not field 4 of stat -- comm can contain spaces and parens.
    pid=$(awk '/^PPid:/{print $2}' "/proc/$pid/status" 2>/dev/null)
    hops=$((hops + 1))
  done

  return 1
}

TTY=$(resolve_pane_tty || true)
[ -n "$TTY" ] || TTY=$(resolve_container_tty || true)

if [ -n "$DEBUG_LOG" ]; then
  debug_log "event=$(printf '%s' "$INPUT" | jq -r '.hook_event_name // "?"' 2>/dev/null)" \
    "pid=$$ pane=${WEZTERM_PANE:-unset}" \
    "wezterm=$(command -v wezterm >/dev/null 2>&1 && echo yes || echo no)" \
    "proc=$([ -r /proc/self/status ] && echo yes || echo no)" \
    "dockerenv=$([ -e /.dockerenv ] && echo yes || echo no)" \
    "tty=${TTY:-NONE} writable=$([ -n "$TTY" ] && [ -w "$TTY" ] && echo yes || echo no)"
fi

[ -n "$TTY" ] && [ -w "$TTY" ] || exit 0

# The raw payload is unbounded -- PostToolUse carries tool_input/tool_response,
# which can run to megabytes and would be dropped or truncated by the terminal.
# Keep only the fields a status display can use, and cap the free-text ones.
#
# `state` is derived here rather than in the consumer because subagents need one
# too. Every event fired from inside a subagent carries `agent_id` (the schema is
# explicit: present only within a subagent, absent on the main thread even under
# --agent), and the consumer routes those to a per-subagent entry -- but until
# now nothing gave that entry a state, so a subagent could never show as working
# or blocked. Deriving it here covers both scopes from one table.
#
# Events that say nothing about processing state -- file watches, config
# reloads, cwd changes -- map to null and are dropped by the with_entries filter
# below. An absent `state` means "leave the previous one alone" rather than
# clobbering a live `working` with `unknown` on every incidental event.
payload() {
  [ -n "$INPUT" ] || return 1
  printf '%s' "$INPUT" | jq -c '
    # Kept short deliberately: the OSC write below is not serialized against
    # concurrent subagents sharing this tty, so the whole sequence wants to stay
    # inside a single small write.
    def clip: if type == "string" then .[0:80] else "" end;

    def hook_state: {
      UserPromptSubmit:    "working",
      UserPromptExpansion: "working",
      PreToolUse:          "working",
      PostToolUse:         "working",
      PostToolBatch:       "working",
      PostToolUseFailure:  "working",
      PermissionDenied:    "working",
      SubagentStart:       "working",
      PreCompact:          "working",
      PostCompact:         "working",
      PermissionRequest:   "waiting",
      Notification:        "waiting",
      Elicitation:         "waiting",
      Stop:                "idle",
      StopFailure:         "idle",
      SessionStart:        "idle",
      SubagentStop:        "idle",
      SessionEnd:          "idle"
    }[.];

    {
      event:    .hook_event_name,
      state:    (.hook_event_name // "" | hook_state),
      session:  .session_id,
      agent_id: .agent_id,
      cwd:      .cwd,
      tool:     .tool_name,
      # agent_type covers a subagent naming itself; on the main thread the Agent
      # tool call that spawns one carries the type under tool_input instead.
      agent:    (.agent_type // (.tool_input | if type == "object" then .subagent_type else null end)),
      title:    .session_title,
      message:  ((.message // .prompt // .reason // .description // .last_assistant_message) | clip)
    }
    | with_entries(select(.value != null and .value != ""))
  ' 2>/dev/null
}

# jq -c ends with a newline; strip it so the var holds clean JSON.
ENCODED_INPUT=$(payload | tr -d '\n' | base64 | tr -d '\n')

printf '\033]1337;SetUserVar=AGENT_INPUT=%s\007' "$ENCODED_INPUT" > "$TTY"

debug_log "raw event $INPUT"
debug_log "wrote tty=$TTY bytes=${#ENCODED_INPUT}"

exit 0
