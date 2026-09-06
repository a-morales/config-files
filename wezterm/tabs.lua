local wezterm     = require("wezterm")
local utils       = require("utils")

local ribbon      = wezterm.plugin.require("https://github.com/sravioli/ribbon.wz")

-- Hot-path locals: see statusbar.lua for rationale. Resolved once at load.
local NF_TERMINAL = wezterm.nerdfonts.cod_terminal
local NF_PLE_L    = wezterm.nerdfonts.ple_left_half_circle_thick
local NF_PLE_R    = wezterm.nerdfonts.ple_right_half_circle_thick

local function setup()
  -- Process accent-color cache: pane_id → color.
  -- Resolved in update-status via the full Pane API  because
  -- PaneInformation.foreground_process_name in format-tab-title is unreliable.
  local pane_proc_color = {}

  -- Process-to-color mapping for tab coloring (process name → accent color).
  -- Resolved from the active pane's title/foreground process (same path as
  -- process icons), not from the CWD.
  local process_colors = {
    nvim = "Purple",
    claude = "Teal",
    pi = "Teal",
  }

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

  local function get_tab_color(tab, gradients, color_scheme)
    if not tab then return nil end

    local process_color = pane_proc_color[tab.active_pane.pane_id]

    if (tab.is_active) then
      return (process_color or "Navy"), color_scheme.foreground
      -- elseif utils.tab_has_unseen_output(tab) then
      --   return "Olive"
    end

    local unseen_color = utils.tab_has_unseen_output(tab) and "Olive"


    return gradients[tab.tab_index + 1] or color_scheme.background,
        unseen_color or process_color or color_scheme.foreground
  end

  -- Pill-shaped tabs: process colors, process/robot icons, and an unseen dot
  wezterm.on("format-tab-title", function(tab, tabs, panes, econfig, _, max_width)
    local color_scheme = econfig.resolved_palette or {}

    -- Build a gradient across the number of tabs
    local base_bg = wezterm.color.parse(color_scheme.background)
    local base_fg = wezterm.color.parse(color_scheme.foreground)
    local gradient_from, gradient_to = base_bg, base_bg:lighten(0.2)
    local gradient = wezterm.color.gradient({
      orientation = "Horizontal",
      colors = { gradient_to, gradient_from },
      -- adding 1 to count new_tab as a tab
    }, #tabs + 1)

    local tab_color = get_tab_color(tab, graident, color_scheme)

    -- Process accent color for the active pane, resolved+cached in update-status.
    -- local process_color = pane_proc_color[tab.active_pane.pane_id]

    local tab_index = tab.tab_index + 1
    local background = gradient[tab_index]

    local next_index = tab_index + 1
    local prev_index = tab_index - 1
    local next_background = get_tab_color(tabs[next_index], gradient, color_scheme) or gradient[next_index]
    local prev_background = gradient[prev_index] or base_bg

    local bg, fg
    if tab.is_active then
      bg = tab_color or base_fg
      fg = background
    else
      bg = background
      fg = tab_color or base_fg
    end

    local proc = tab.active_pane.foreground_process_name or ""
    local vim_file = tab.active_pane.user_vars["VIM_FILE"] and #tab.active_pane.user_vars["VIM_FILE"] > 0 and
        tab.active_pane.user_vars["VIM_FILE"]
    local title = (tab.tab_title and #tab.tab_title > 0 and tab.tab_title) or vim_file or tab.active_pane.title
    local icon

    icon, title = utils.get_updated_title_and_icon(title, utils.basename(proc), NF_TERMINAL)

    -- Build title with index and icon
    local formatted = tab_index .. ": " .. icon .. " " .. title

    -- Truncate to fit (pill edges + padding = ~4 cells)
    formatted = wezterm.truncate_right(formatted, max_width - 4)

    local tab_title = ribbon:new "TabTitle"

    if tab.is_active and tab.tab_index == 0 then
      tab_title
          :append(nil, nil, " ")
          :append(prev_background or fg, bg, NF_PLE_L)
    elseif tab.is_active then
      tab_title:append(prev_background or fg, bg, NF_PLE_L)
    elseif tab.tab_index == 0 then
      tab_title:append(bg, base_bg, NF_PLE_R)
          :append(bg, fg, " ")
    else
      tab_title:append(bg, fg, " ")
    end

    tab_title:append(bg, fg, formatted)

    if (tabs[next_index] and tabs[next_index].is_active) then
      tab_title:append(bg, fg, " ")
    else
      tab_title:append(next_background or base_bg, bg, NF_PLE_R)
    end

    return tab_title:format()
  end)
end

return { setup = setup }
