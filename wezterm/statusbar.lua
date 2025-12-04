local wezterm = require("wezterm")
local segments = require("segments")
local M = {}

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

function M.configure_status_bar(wezterm)
  wezterm.on("update-status", function(window, pane)
    local segs = segments.get_right_status_segments(window, pane)
    local color_scheme = window:effective_config().resolved_palette

    -- wezterm.color.parse returns a Color object, which we can
    -- lighten or darken (amongst other things).
    local bg = wezterm.color.parse(color_scheme.background)
    local fg = color_scheme.foreground

    local gradient_to, gradient_from = bg, bg
    if is_appearance_dark() then
      gradient_from = gradient_to:lighten(0.15)
    else
      gradient_from = gradient_to:darken(0.15)
    end
    local gradient = wezterm.color.gradient(
      {
        orientation = "Horizontal",
        colors = { gradient_from, gradient_to },
      },
      #segs -- as many colours as no. of segments
    )

    -- Build up the elements to send to wezterm.format
    local elements = {}

    for i, seg in ipairs(segs) do
      local is_first = i == 1

      if is_first then
        table.insert(elements, { Background = { Color = "none" } })
      end
      table.insert(elements, { Foreground = { Color = gradient[i] } })
      table.insert(elements, { Text = "" })

      table.insert(elements, { Foreground = { Color = fg } })
      table.insert(elements, { Background = { Color = gradient[i] } })
      table.insert(elements, { Text = " " .. seg .. " " })
    end
    window:set_right_status(wezterm.format(elements))

    -- Hide scrollbar if content fits in the scrollback, or if alternate screen is active
    local overrides = window:get_config_overrides() or {}
    local dimensions = pane:get_dimensions()
    overrides.enable_scroll_bar = dimensions.scrollback_rows > dimensions.viewport_rows
      and not pane:is_alt_screen_active()
    window:set_config_overrides(overrides)
  end)
end

return M
