--@type Wezterm
local wezterm = require("wezterm")
--- @type SmartSplitsWezterm
local smart_splits = wezterm.plugin.require "file:///Users/amorales/Code/personal/smart-splits.nvim"

-- Shared with the Hammerspoon and Neovim configs; see ~/.config/lua/aerospace.lua.
package.path = os.getenv("HOME") .. "/.config/lua/?.lua;" .. package.path
local aerospace = require("aerospace")

local function switch_window(direction)
  wezterm.run_child_process(aerospace.sh(aerospace.focus_or_cycle_cmd(direction)))
end

local M = {}

M.apply_to_config = function(config)
  config.leader = { key = "o", mods = "CTRL", timeout_milliseconds = 1000 }

  config.mouse_bindings = {
    {
      event = { Down = { streak = 3, button = 'Left' } },
      action = wezterm.action.SelectTextAtMouseCursor 'SemanticZone',
      mods = 'NONE',
    },
  }

  config.keys = {
    {
      key = "|",
      mods = "LEADER|SHIFT",
      action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
    },
    {
      key = "?",
      mods = "LEADER",
      action = wezterm.action.ShowDebugOverlay,
    },
    {
      key = "-",
      mods = "LEADER",
      action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
    },
    {
      key = "o",
      mods = "LEADER|CTRL",
      action = wezterm.action.SendKey({ key = "o", mods = "CTRL" }),
    },
    {
      key = "d",
      mods = "LEADER",
      action = wezterm.action.CloseCurrentPane({ confirm = true }),
    },
    {
      key = "j",
      mods = "LEADER|CTRL",
      action = wezterm.action.SendKey({ key = "j", mods = "CTRL" }),
    },
    {
      key = "k",
      mods = "LEADER",
      action = wezterm.action.Multiple({
        wezterm.action.ClearScrollback("ScrollbackAndViewport"),
        wezterm.action.SendKey({ key = "L", mods = "CTRL" }),
      }),
    },
    {
      key = "c",
      mods = "LEADER",
      action = wezterm.action.ResetTerminal,
    },
    {
      key = "z",
      mods = "LEADER",
      action = wezterm.action.TogglePaneZoomState,
    },
    {
      key = "[",
      mods = "LEADER",
      action = wezterm.action.ActivateCopyMode,
    },
    {
      key = "x",
      mods = "LEADER",
      action = wezterm.action.QuickSelect,
    },
    {
      key = "x",
      mods = "LEADER|CTRL",
      action = wezterm.action.QuickSelectArgs({
        label = "open url",
        patterns = {
          "https?://\\S+",
        },
        skip_action_on_paste = true,
        action = wezterm.action_callback(function(window, pane)
          local url = window:get_selection_text_for_pane(pane)
          wezterm.log_info("opening: " .. url)
          wezterm.open_with(url)
        end),
      }),
    },
    {
      key = "r",
      mods = "LEADER",
      action = wezterm.action.RotatePanes("Clockwise"),
    },
    {
      key = "h",
      mods = "LEADER",
      action = wezterm.action.MoveTabRelative(-1),
    },
    {
      key = "l",
      mods = "LEADER",
      action = wezterm.action.MoveTabRelative(1),
    },
    {
      key = "f",
      mods = "LEADER",
      action = wezterm.action.ShowLauncherArgs({ flags = "FUZZY|WORKSPACES" }),
    },
    {
      key = "n",
      mods = "LEADER",
      action = wezterm.action.PromptInputLine {
        description = wezterm.format {
          { Attribute = { Intensity = 'Bold' } },
          { Foreground = { AnsiColor = 'Fuchsia' } },
          { Text = 'Enter name for new workspace' },
        },
        action = wezterm.action_callback(function(window, pane, line)
          -- line will be `nil` if they hit escape without entering anything
          -- An empty string if they just hit enter
          -- Or the actual line of text they wrote
          if line then
            window:perform_action(
              wezterm.action.SwitchToWorkspace {
                name = line,
              },
              pane
            )
          end
        end),
      },
    },
    {
      key = ",",
      mods = "LEADER",
      action = wezterm.action.PromptInputLine({
        description = "Enter new name for current workspace",
        action = wezterm.action_callback(function(_, _, line)
          if line then
            wezterm.mux.rename_workspace(
              wezterm.mux.get_active_workspace(),
              line
            )
          end
        end),
      }),
    },
    {
      key = "t",
      mods = "LEADER",
      action = wezterm.action.PromptInputLine({
        description = "Enter new name for current tab",
        action = wezterm.action_callback(function(window, _, line)
          if line then
            window:active_tab():set_title(line)
          end
        end),
      }),
    },
    {
      -- A new window on its own mux connection, so its workspace is its own.
      key = "n",
      mods = "CMD",
      action = wezterm.action.SpawnWindow,
    },
    {
      key = "1",
      mods = "LEADER",
      action = wezterm.action.ShowLauncherArgs({ flags = "FUZZY|TABS" }),
    },
    { key = 'UpArrow',   mods = 'SHIFT', action = wezterm.action.ScrollToPrompt(-1) },
    { key = 'DownArrow', mods = 'SHIFT', action = wezterm.action.ScrollToPrompt(1) },
  }

  smart_splits.apply_to_config(config, {
    direction_keys = { "h", "j", "k", "l" },
    modifiers = {
      move = "CTRL",
      resize = "META",
    },
    at_edge = function(ctx)
      if ctx.direction == 'Left' or ctx.direction == "Right" then
        switch_window(ctx.direction)
      else
        ctx.send_key()
      end
    end
  })
  return config
end

return M
