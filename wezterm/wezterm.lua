local wezterm = require("wezterm")
local smart_splits = wezterm.plugin.require("https://github.com/mrjones2014/smart-splits.nvim")

local config = wezterm.config_builder()

config.color_scheme = "OneNord"
config.font = wezterm.font("Cartograph CF")
config.font_size = 14
config.hide_tab_bar_if_only_one_tab = false
config.use_fancy_tab_bar = false
config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"
config.tab_max_width = 40
config.inactive_pane_hsb = {
  saturation = 0.9,
  brightness = 0.6,
}
config.window_padding = {
  left = "0.5cell",
  right = "0.5cell",
  top = "0.5cell",
  bottom = "0.5cell",
}
config.enable_scroll_bar = true
config.scrollback_lines = 10000

config.leader = { key = "o", mods = "CTRL", timeout_milliseconds = 1000 }
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
    action = wezterm.action.SpawnTab("CurrentPaneDomain"),
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
    key = "r",
    mods = "LEADER",
    action = wezterm.action.RotatePanes("Clockwise"),
  },
  {
    key = "w",
    mods = "LEADER",
    action = wezterm.action.CloseCurrentPane({ confirm = true }),
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
}

smart_splits.apply_to_config(config, {
  direction_keys = { "h", "j", "k", "l" },
  modifiers = {
    move = "CTRL",
    resize = "META",
  },
})

local function basename(s)
  return string.gsub(s, "(.*[/\\])(.*)", "%2")
end

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
  local working_dir = basename(tab.active_pane.current_working_dir.file_path)
  wezterm.log_warn("working dir: " .. working_dir)
  local process_name = basename(tab.active_pane.foreground_process_name)
  local process_icon = process_name

  if tab.is_active then
    local title = (tab.tab_index + 1) .. ": " .. working_dir .. " - " .. process_icon .. " "
    return title
  else
    local title = (tab.tab_index + 1) .. ": " .. working_dir .. " "
    return title
  end
end)

return config
