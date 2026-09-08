local wezterm     = require("wezterm")
local utils       = require("utils")

local ribbon      = wezterm.plugin.require("https://github.com/sravioli/ribbon.wz")
local agents      = require("agents")

-- Hot-path locals: see statusbar.lua for rationale. Resolved once at load.
local NF_TERMINAL = wezterm.nerdfonts.cod_terminal
local NF_PLE_L    = utils.NF_PLE_L
local NF_PLE_R    = utils.NF_PLE_R

local function setup()
  -- Process accent-color cache: pane_id → color.
  -- Resolved in update-status via the full Pane API  because
  -- PaneInformation.foreground_process_name in format-tab-title is unreliable.
  local pane_proc_color = {}

  -- Process-to-color mapping for tab coloring (process name → accent color).
  -- Resolved from the active pane's title/foreground process (same path as
  -- process icons), not from the CWD. Shared with process_icons in utils.lua.
  local process_colors = utils.process_colors

  -- Agent detection (runs every ~1s via update-status timer)
  -- Uses full Pane objects to inspect process argv and user_vars
  wezterm.on("update-status", function(window, _)
    local new_proc_color = {}
    for _, mux_tab in ipairs(window:mux_window():tabs()) do
      for _, p in ipairs(mux_tab:panes()) do
        local pane_id = p:pane_id()

        -- Foreground process argv: the reliable command identity. Wrapped CLIs
        -- defeat the other signals — Claude's foreground path basename is a
        -- version dir ("2.1.215") and its title is a spinner glyph, but
        -- argv[0] stays "claude" even while it is working.
        local argv0
        local ok_info, info = pcall(p.get_foreground_process_info, p)
        if ok_info and info and info.argv and info.argv[1] then
          argv0 = utils.basename(info.argv[1])
        end

        -- Pane title carries identity for terminal apps (nvim, herdr).
        local title = p:get_title() or ""
        local title_cmd = title:match("^(%S+)")

        -- Process accent color: argv[0] first, then title, then fg basename.
        local fg_name = p:get_foreground_process_name()
        local pc = (argv0 and process_colors[argv0])
            or (title_cmd and process_colors[title_cmd])
            or (fg_name and process_colors[utils.basename(fg_name)])
        if pc then
          new_proc_color[pane_id] = pc
        end
      end
    end
    pane_proc_color = new_proc_color
  end)

  local function get_tab_color(tab, gradient, unseen_gradient, color_scheme)
    if not tab then return nil, nil end

    local process_color = color_scheme.ansi[pane_proc_color[tab.active_pane.pane_id]]

    local bg, fg
    if tab.is_active then
      bg = process_color or color_scheme.ansi[5]
      local _, _, l, _ = wezterm.color.parse(bg):hsla()
      fg = l < 0.5 and color_scheme.foreground or color_scheme.background
    elseif utils.tab_has_unseen_output(tab) then
      bg = unseen_gradient[tab.tab_index + 1]
      local _, _, l, _ = bg:hsla()
      fg = l < 0.5 and color_scheme.foreground or color_scheme.background
    else
      bg = gradient[tab.tab_index + 1] or color_scheme.background
      fg = process_color or color_scheme.foreground
    end

    return bg, fg
  end

  -- Gradient cache: format-tab-title fires once per tab per redraw, but the
  -- gradient only depends on the tab count and the resolved palette, so
  -- rebuilding it on every call is O(#tabs^2) work per redraw. Cache the last
  -- build and reuse it while the inputs haven't changed.
  local _gradient_cache = {}

  local function get_gradients(tab_count, gradient_from, gradient_to, olive)
    local sig = tab_count .. "|" .. tostring(gradient_from) .. "|" .. tostring(gradient_to) .. "|" .. tostring(olive)
    if _gradient_cache.sig == sig then
      return _gradient_cache.gradient, _gradient_cache.unseen_gradient
    end

    local gradient = wezterm.color.gradient({
      orientation = "Horizontal",
      colors = { gradient_from, gradient_to },
      -- adding 1 to count new_tab as a tab
    }, tab_count + 1)
    local unseen_gradient = wezterm.color.gradient({
      orientation = "Horizontal",
      colors = { olive, wezterm.color.parse(olive):darken(0.5) },
    }, tab_count)

    _gradient_cache = { sig = sig, gradient = gradient, unseen_gradient = unseen_gradient }
    return gradient, unseen_gradient
  end

  -- Pill-shaped tabs: process colors, process/robot icons, and an unseen dot
  wezterm.on("format-tab-title", function(tab, tabs, _, econfig, _, max_width)
    local color_scheme = econfig.resolved_palette or {}

    local tab_background = color_scheme.tab_bar.background
    local olive = color_scheme.ansi[utils.ANSI_OLIVE]
    local gradient_from, gradient_to = color_scheme.background, color_scheme.tab_bar.new_tab.bg_color
    local gradient, unseen_gradient = get_gradients(#tabs, gradient_from, gradient_to, olive)

    local tab_index = tab.tab_index + 1
    local next_tab = tabs[tab_index + 1]
    local prev_tab = tabs[tab_index - 1]

    local bg, fg = get_tab_color(tab, gradient, unseen_gradient, color_scheme)
    local next_background = get_tab_color(next_tab, gradient, unseen_gradient, color_scheme) or
        color_scheme.tab_bar.new_tab.bg_color
    local prev_background = get_tab_color(prev_tab, gradient, unseen_gradient, color_scheme) or tab_background

    local proc = tab.active_pane.foreground_process_name or ""
    local vim_file = tab.active_pane.user_vars["VIM_FILE"] and #tab.active_pane.user_vars["VIM_FILE"] > 0 and
        tab.active_pane.user_vars["VIM_FILE"]
    local title = (tab.tab_title and #tab.tab_title > 0 and tab.tab_title) or vim_file or tab.active_pane.title
    local icon

    -- local has_agent = false
    -- for _, p in ipairs(tab.panes) do
    --   wezterm.log_info("==checking pane " .. p.pane_id)
    --   for key, state in pairs(agents.state) do
    --     wezterm.log_info(key)
    --     wezterm.log_info(state)
    --     if (state.pane_id == p.pane_id) then
    --       has_agent = true
    --     end
    --   end
    -- end

    icon, title = utils.get_updated_title_and_icon(title, utils.basename(proc), NF_TERMINAL)

    -- Build title with index and icon
    local formatted = tab_index .. ": " .. icon .. " " .. title

    formatted = wezterm.truncate_right(formatted, max_width - 2)

    local tab_title = ribbon:new "TabTitle"

    if tab.is_active and tab.tab_index == 0 then
      tab_title
          :append(tab_background, nil, " ")
          :append(prev_background, bg, NF_PLE_L)
    elseif tab.is_active then
      tab_title:append(prev_background, bg, NF_PLE_L)
    elseif tab.tab_index == 0 then
      tab_title:append(bg, tab_background, NF_PLE_R)
          :append(bg, fg, " ")
    else
      tab_title:append(bg, fg, " ")
    end

    tab_title:append(bg, fg, formatted)

    if (next_tab and next_tab.is_active) then
      tab_title:append(bg, fg, " ")
    else
      tab_title:append(next_background, bg, NF_PLE_R)
    end

    return tab_title:format()
  end)
end

return { setup = setup }
