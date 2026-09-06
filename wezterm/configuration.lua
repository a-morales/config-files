---@type Wezterm
local wezterm = require("wezterm")
---@type Ribbon.Api
local ribbon  = wezterm.plugin.require("https://github.com/sravioli/ribbon.wz")

local SCHEME  = "Everforest Dark Medium (Gogh)"

local M       = {}

function M.setup()
  local config    = wezterm.config_builder()
  local scheme_bg = wezterm.color.parse(wezterm.color.get_builtin_schemes()[SCHEME].background)
  local scheme_fg = wezterm.color.parse(wezterm.color.get_builtin_schemes()[SCHEME].foreground)

  ribbon.setup({
    atomic = true,
    defaults = {
      foreground = scheme_fg,
      background = scheme_bg
    }
  })

  config.color_scheme = SCHEME
  config.font = wezterm.font("Cartograph CF")
  config.front_end = "WebGpu"
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
  config.notification_handling = "AlwaysShow"
  config.font_size = 14
  config.use_fancy_tab_bar = false
  config.cell_width = 0.9
  config.cursor_blink_rate = 500
  config.default_cursor_style = "BlinkingBar"
  config.hide_tab_bar_if_only_one_tab = false
  config.show_tab_index_in_tab_bar = true
  config.max_fps = 60
  config.window_close_confirmation = "AlwaysPrompt"
  config.show_close_tab_button_in_tabs = false
  config.window_decorations = "RESIZE"
  config.tab_max_width = 40
  -- config.window_background_opacity = 0.9
  config.status_update_interval = 1000
  config.macos_window_background_blur = 30
  config.bold_brightens_ansi_colors = true
  config.enable_tab_bar = true
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
  config.colors = {
    tab_bar = {
      background = scheme_bg:darken(0.1),
    },
  }
  config.tab_bar_style = {
    new_tab = ribbon:new("new_tab_text")
        :append(nil, nil, " +")
        :append(scheme_bg:darken(0.1), scheme_bg, wezterm.nerdfonts.ple_right_half_circle_thick)
        :format()
  }

  config.enable_scroll_bar = true
  config.scrollback_lines = 10000
  config.hyperlink_rules = wezterm.default_hyperlink_rules()

  table.insert(config.hyperlink_rules, {
    regex = [[APIREG-(\d+)]],
    format = "https://deept.atlassian.net/browse/APIREG-$1",
  })


  return config
end

return M
