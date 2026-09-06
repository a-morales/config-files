-- Shared aerospace command builders.
--
-- Hammerspoon, Neovim (smart-splits) and WezTerm (smart-splits) all shell out
-- to the aerospace CLI for the same window/workspace navigation, and all three
-- are Lua, so the pipelines live here instead of being copy-pasted three ways.
-- Deliberately host-agnostic: no hs.*, vim.*, or wezterm.* in this file.
--
-- Load it from any of them with:
--
--     package.path = os.getenv("HOME") .. "/.config/lua/?.lua;" .. package.path
--     local aerospace = require("aerospace")
--
-- The `*_cmd` builders return shell command strings; each host runs them with
-- its own process API (hs.task, vim.fn.system, wezterm.run_child_process).
-- `M.sh()` wraps one in the argv form the argv-taking APIs expect.

local M = {}

M.bin = "/opt/homebrew/bin/aerospace"

-- Direction handling. WezTerm's smart-splits reports "Left"/"Right", Neovim's
-- reports "left"/"right", and Hammerspoon passes whatever we hand it.
local WRAP = { left = "prev", right = "next" }

local function normalize(dir)
  return string.lower(dir)
end

-- argv for running a command string through a shell.
function M.sh(cmd)
  return { "/bin/sh", "-c", cmd }
end

-- Focus the leftmost/rightmost window of the focused workspace.
--
-- Aerospace has no "focus the edge window" command, so focus is walked there
-- one step at a time: `--boundaries-action fail` exits non-zero once there is
-- nowhere left to go, which ends the loop. `--dfs-index 0` first because the
-- workspace may come up with focus on a floating or hidden-app window, and
-- directional focus can't move out of one.
function M.focus_edge_cmd(dir)
  dir = normalize(dir)
  return "{ " .. M.bin .. " focus --dfs-index 0 >/dev/null 2>&1; "
      .. "while " .. M.bin .. " focus --boundaries workspace"
      .. " --boundaries-action fail " .. dir .. " >/dev/null 2>&1; do :; done; }"
end

-- Cycle to the next/prev non-empty workspace on the focused monitor, then
-- focus the window nearest the edge we came from: moving right lands on the
-- new workspace's leftmost window, moving left on its rightmost, so focus
-- keeps travelling in the direction of the keypress. If the workspace switch
-- itself fails, `&&` leaves focus alone.
function M.cycle_workspace_cmd(wrap)
  local edge = (wrap == "next") and "left" or "right"
  return M.bin .. " list-workspaces --monitor focused --empty no | "
      .. M.bin .. " workspace --wrap-around " .. wrap .. " --stdin"
      .. " && " .. M.focus_edge_cmd(edge)
end

-- Focus in `dir`, falling back to cycling workspaces at the layout boundary.
--
-- `--boundaries-action fail` makes aerospace exit non-zero instead of silently
-- stopping at the edge, so the `||` branch fires only when focus had nowhere
-- left to go. Built as one shell command so hosts that only report exit codes
-- asynchronously don't have to turn this into a continuation.
--
-- Boundary is aerospace's default (all-monitors-outer-frame): on a multi-
-- monitor setup focus crosses to the neighbouring monitor first, and only
-- cycles workspaces at the true outer edge. Add `--boundaries workspace` to
-- cycle at the edge of each workspace instead.
function M.focus_or_cycle_cmd(dir)
  dir = normalize(dir)
  return M.bin .. " focus --boundaries-action fail " .. dir
      .. " || { " .. M.cycle_workspace_cmd(WRAP[dir]) .. "; }"
end

return M
