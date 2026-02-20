local wezterm = require("wezterm")
local smart_splits = wezterm.plugin.require("https://github.com/mrjones2014/smart-splits.nvim")
local tabline = wezterm.plugin.require("https://github.com/michaelbrusegard/tabline.wez")
local projects = require("projects")

local config = wezterm.config_builder()

config.color_scheme = "Everforest Dark (Gogh)"
config.font = wezterm.font("Cartograph CF")
config.font_rules = {
  {
    intensity = "Bold",
    italic = false,
    font = wezterm.font("Cartograph CF", { weight = "Bold", stretch = "Normal", style = "Normal" }),
  },
  {
    intensity = "Bold",
    italic = true,
    font = wezterm.font("Cartograph CF", { weight = "Bold", stretch = "Normal", style = "Italic" }),
  },
}
config.font_size = 14
config.cell_width = 0.9
config.hide_tab_bar_if_only_one_tab = false
config.use_fancy_tab_bar = false
config.window_decorations = "RESIZE"
config.tab_max_width = 40
config.window_background_opacity = 0.9
config.macos_window_background_blur = 30
config.bold_brightens_ansi_colors = true
config.set_environment_variables = {
  PATH = "/opt/homebrew/bin:" .. os.getenv("PATH"),
}
config.inactive_pane_hsb = {
  saturation = 0.8,
  brightness = 0.6,
}
config.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 0,
}
config.enable_scroll_bar = true
config.scrollback_lines = 10000
config.colors = {
  tab_bar = {
    background = "#2D353B",
    active_tab = {
      bg_color = "#56635f",
      fg_color = "#D3C6AA",
    },
    new_tab = {
      bg_color = "#2D353B",
      fg_color = "#D3C6AA",
    },
  },
}

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
  {
    key = "p",
    mods = "LEADER",
    action = projects.choose_project(),
  },
  {
    key = "f",
    mods = "LEADER",
    action = wezterm.action.ShowLauncherArgs({ flags = "FUZZY|WORKSPACES" }),
  },
  {
    key = ",",
    mods = "LEADER",
    action = wezterm.action.PromptInputLine({
      description = "Enter new name for tab",
      action = wezterm.action_callback(function(window, pane, line)
        if line then
          window:active_tab():set_title(line)
        end
      end),
    }),
  },
}

smart_splits.apply_to_config(config, {
  direction_keys = { "h", "j", "k", "l" },
  modifiers = {
    move = "CTRL",
    resize = "META",
  },
})

tabline.setup({
  options = {
    theme = "Everforest Dark (Gogh)",
    tab_separators = {
      left = wezterm.nerdfonts.pl_left_hard_divider,
      right = wezterm.nerdfonts.pl_right_hard_divider,
    },
  },
  sections = {
    tabline_a = { "workspace" },
    tabline_b = {},
    tabline_c = {},
    tabline_x = {},
    tabline_y = { "ram", "cpu" },
    tabline_z = {},
  },
})

config.hyperlink_rules = wezterm.default_hyperlink_rules()

table.insert(config.hyperlink_rules, {
  regex = [[APIREG-(\d+)]],
  format = "https://jira.disney.com/browse/APIREG-$1",
})

return config
