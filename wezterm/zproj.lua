-- zproj integration module — managed by `zproj integrate`. Safe to delete; it
-- is recreated on the next `zproj integrate`. Provides worktree keybindings and
-- bell-driven desktop notifications, mirroring the tmux integration.
local wezterm = require 'wezterm'
local act = wezterm.action
local M = {}

-- Filesystem path of a pane's current working directory.
local function pane_cwd(pane)
  local uri = pane:get_current_working_dir()
  if uri == nil then return nil end
  if type(uri) == 'userdata' and uri.file_path then return uri.file_path end
  local s = tostring(uri)
  s = s:gsub('^file://[^/]*', '')
  return s
end

-- The worktree name is the active tab's title (zproj sets it to the worktree).
local function worktree_name(window)
  local tab = window:active_tab()
  if tab == nil then return '' end
  return tab:get_title() or ''
end

-- Spawn `zproj <args...>` in a new window, in the active pane's cwd.
local function spawn_zproj(window, pane, args)
  local full = { 'zproj' }
  for _, a in ipairs(args) do table.insert(full, a) end
  window:perform_action(
    act.SpawnCommandInNewWindow { args = full, cwd = pane_cwd(pane) },
    pane
  )
end

-- Prompt for a line, then call cb(window, pane, line) when non-empty.
local function prompt(desc, cb)
  return act.PromptInputLine {
    description = desc,
    action = wezterm.action_callback(function(window, pane, line)
      if line ~= nil and line ~= '' then cb(window, pane, line) end
    end),
  }
end

-- Add the worktree keybindings (N/X/F/J/U under LEADER) to a config table.
function M.apply(config)
  if config.leader == nil then
    config.leader = { key = 'a', mods = 'CTRL', timeout_milliseconds = 1000 }
  end
  config.keys = config.keys or {}
  local binds = {
    { key = 'N', mods = 'LEADER', action = prompt('new worktree name:', function(w, p, n)
        spawn_zproj(w, p, { n }) end) },
    { key = 'X', mods = 'LEADER', action = wezterm.action_callback(function(w, p)
        spawn_zproj(w, p, { 'delete', worktree_name(w), '--force' }) end) },
    { key = 'F', mods = 'LEADER', action = prompt('fork to new worktree:', function(w, p, n)
        spawn_zproj(w, p, { 'fork', worktree_name(w), n }) end) },
    { key = 'J', mods = 'LEADER', action = prompt('join into worktree:', function(w, p, n)
        spawn_zproj(w, p, { 'join', worktree_name(w), n }) end) },
    { key = 'U', mods = 'LEADER', action = wezterm.action_callback(function(w, p)
        spawn_zproj(w, p, { 'update' }) end) },
  }
  for _, b in ipairs(binds) do table.insert(config.keys, b) end
  return config
end

-- Desktop notification on bell — parity with the tmux alert-bell → zproj notify
-- pipeline. Agents configured by `zproj integrate` emit BEL on idle, raising a
-- toast here. Registered globally on require, independent of the config table.
wezterm.on('bell', function(window, pane)
  window:toast_notification('zproj', pane:get_title() or 'agent idle', nil, 5000)
end)

return M
