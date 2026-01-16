local wezterm = require("wezterm")
local smart_splits = wezterm.plugin.require("https://github.com/mrjones2014/smart-splits.nvim")
local projects = require("projects")

local config = wezterm.config_builder()

config.color_scheme = "Everforest Dark (Gogh)"
config.font = wezterm.font("Cartograph CF")
config.font_size = 14
config.cell_width = 0.9
config.hide_tab_bar_if_only_one_tab = false
config.use_fancy_tab_bar = false
config.window_decorations = "RESIZE"
config.tab_max_width = 40
config.window_background_opacity = 0.9
config.macos_window_background_blur = 30
-- config.default_prog = { "/opt/homebrew/bin/fish", "-l" }
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

local function basename(s)
  return string.gsub(s, "(.*[/\\])(.*)", "%2")
end

local function tab_title(tab_info)
  local title = tab_info.tab_title
  -- if the tab title is explicitly set, take that
  if title and #title > 0 then
    return title
  end
  -- Otherwise, use the title from the active pane
  -- in that tab
  return tab_info.active_pane.title
end

local function get_progress(pane, raw_title, foreground)
  local title = raw_title
  local fg_color = foreground
  local progress = pane.progress or "None"
  if progress ~= "None" then
    local color = "green"
    local status
    if progress.Percentage ~= nil then
      status = string.format("%d%%", progress.Percentage)
    elseif progress.Error ~= nil then
      status = string.format("%d%%", progress.Error)
      color = "red"
    elseif progress == "Indeterminate" then
      status = "~"
    else
      status = wezterm.serde.json_encode(progress)
    end
    fg_color = color
    title = status .. " " .. title
  end

  return fg_color, title
end

local known_shells = {
  pwsh = true,
  powershell = true,
  cmd = true,
  bash = true,
  zsh = true,
  fish = true,
  sh = true,
  csh = true,
  tcsh = true,
  nu = true,
  elvish = true,
  xonsh = true,
}

local function ternary(a, b)
  if a and a ~= "" then
    return a
  end
  return b
end

local function get_title(tab, foreground)
  -- Figure out what title to show
  local pane = tab.active_pane
  local raw_title = tab.tab_title
  local ran_cmd = pane.user_vars.WEZTERM_CMD or ""
  local pane_title = pane.title
  local base_pane_title = basename(pane_title)
  local is_shell = base_pane_title ~= "" and known_shells[base_pane_title]
  local proc_name = basename(pane.foreground_process_name)
  if raw_title == "" then
    if pane_title == "" then
      raw_title = ternary(ran_cmd, proc_name)
    elseif ran_cmd == "" then
      if is_shell then
        raw_title = ternary(proc_name, base_pane_title)
      else
        raw_title = ternary(pane_title, proc_name)
      end
    else
      if is_shell then
        raw_title = ternary(ran_cmd, base_pane_title)
      else
        raw_title = ternary(pane_title, ran_cmd)
      end
    end
  end
  if raw_title == "" then
    raw_title = ternary(proc_name, basename(os.getenv("WEZTERM_EXECUTABLE")))
  else
    raw_title = raw_title:gsub("[%.][eE][xX][eE]$", "")
  end

  -- If there is progress, show that as well
  return get_progress(pane, raw_title, foreground)
end

local icons = {
  -- Development Tools
  ["debug"] = wezterm.nerdfonts.cod_debug_console,
  ["cargo"] = wezterm.nerdfonts.dev_rust,
  ["git"] = wezterm.nerdfonts.dev_git,
  ["go"] = wezterm.nerdfonts.seti_go,
  ["lua"] = wezterm.nerdfonts.seti_lua,
  ["node"] = wezterm.nerdfonts.md_hexagon,
  ["sbt"] = wezterm.nerdfonts.seti_sbt,
  ["bash"] = wezterm.nerdfonts.dev_terminal,
  ["zsh"] = wezterm.nerdfonts.dev_terminal,
  ["fish"] = wezterm.nerdfonts.dev_terminal,
  ["nvim"] = wezterm.nerdfonts.custom_vim,
  ["vim"] = wezterm.nerdfonts.dev_vim,
  ["docker"] = wezterm.nerdfonts.linux_docker,
  ["docker-compose"] = wezterm.nerdfonts.linux_docker,
  ["kubectl"] = wezterm.nerdfonts.linux_docker,
  ["curl"] = wezterm.nerdfonts.md_waves,
  ["gh"] = wezterm.nerdfonts.dev_github_badge,
  ["make"] = wezterm.nerdfonts.seti_makefile,
  ["sudo"] = wezterm.nerdfonts.fa_hashtag,
  ["wget"] = wezterm.nerdfonts.md_arrow_down_box,
  ["lazygit"] = wezterm.nerdfonts.dev_github_alt,
}

wezterm.on("format-tab-title", function(tab, tabs, _, econfig, _, max_width)
  local color_scheme = econfig.resolved_palette
  local total_tabs = #tabs > 0 and #tabs or 1
  local foreground = color_scheme.foreground
  local edge_background = color_scheme.tab_bar.background

  -- Build a gradient across the number of tabs
  local base_bg = wezterm.color.parse(color_scheme.background)
  local bg5 = "#56635f"
  local gradient_to, gradient_from = bg5, base_bg
  -- gradient_to = gradient_from:lighten(0.15)
  local gradient = wezterm.color.gradient({
    orientation = "Horizontal",
    colors = { gradient_to, gradient_from },
  }, total_tabs)

  -- Use the tab index (0-based) to pick the colour for this tab
  local current_index0 = tab.tab_index or 0

  local background = gradient[current_index0 + 1]
  local tab_background = background

  -- Make the right wedge blend into the NEXT tab's background color
  local next_index0 = current_index0 + 1
  local next_background

  if next_index0 < total_tabs then
    if tabs[next_index0 + 1].is_active then
      next_background = color_scheme.ansi[5]
    else
      next_background = gradient[next_index0 + 1]
    end
  end

  local fg_color, raw_title = get_title(tab, foreground)

  if tab.is_active then
    tab_background = "#7FBBB3"
    fg_color = "#343F44"
  end

  local is_zoomed = ""
  if tab.active_pane.is_zoomed then
    is_zoomed = wezterm.nerdfonts.fa_magnifying_glass .. " "
  end

  -- Ensure that the titles fit in the available space,
  local title_cells = math.max(0, max_width - 3) -- (leading space + trailing space + wedge)
  local title = wezterm.truncate_right(is_zoomed .. (tab.tab_index + 1) .. ": " .. raw_title, title_cells)

  return {
    { Background = { Color = tab_background } },
    { Foreground = { Color = fg_color } },

    { Text = " " .. title .. " " },

    { Background = { Color = next_background or edge_background } },
    { Foreground = { Color = tab_background } },
    { Text = "" },
  }
end)

config.hyperlink_rules = wezterm.default_hyperlink_rules()

table.insert(config.hyperlink_rules, {
  regex = [[APIREG-(\d+)]],
  format = "https://jira.disney.com/browse/APIREG-$1",
})

wezterm.on("update-status", function(window, pane)
  --   local segs = {
  --     window:active_workspace(),
  --   }
  --   local color_scheme = window:effective_config().resolved_palette
  --
  --   -- wezterm.color.parse returns a Color object, which we can
  --   -- lighten or darken (amongst other things).
  --   local bg = wezterm.color.parse(color_scheme.background)
  --   local fg = color_scheme.foreground
  --
  --   local gradient_to, gradient_from = bg, bg
  --   gradient_to = gradient_from:lighten(0.15)
  --   local gradient = wezterm.color.gradient(
  --     {
  --       orientation = "Horizontal",
  --       colors = { gradient_from, gradient_to },
  --     },
  --     #segs -- as many colours as no. of segments
  --   )
  --
  --   -- Build up the elements to send to wezterm.format
  --   local elements = {}
  --
  --   for i, seg in ipairs(segs) do
  --     local is_first = i == 1
  --
  --     if is_first then
  --       table.insert(elements, { Background = { Color = bg } })
  --     end
  --     table.insert(elements, { Foreground = { Color = gradient[i] } })
  --     table.insert(elements, { Text = "" })
  --
  --     table.insert(elements, { Foreground = { Color = fg } })
  --     table.insert(elements, { Background = { Color = gradient[i] } })
  --     table.insert(elements, { Text = " " .. seg .. " " })
  --   end
  window:set_right_status(wezterm.format({
    { Text = " " .. window:active_workspace() .. " " },
  }))
end)

return config
