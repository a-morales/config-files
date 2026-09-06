-- statusbar.lua: Left and right status bar rendering via the update-status event.
-- Includes workspace/leader display, CWD, git branch (cached), command, and session stats.

local wezterm      = require("wezterm")
local utils        = require("utils")
local ribbon       = wezterm.plugin.require("https://github.com/sravioli/ribbon.wz")
---@type AgentDeck
local agent_deck   = wezterm.plugin.require('https://github.com/Eric162/wezterm-agent-deck')

-- Hot-path locals: resolve module-level functions + constants once at load time.
-- In Lua 5.4 (WezTerm's runtime) globals/table lookups are ~20x slower than
-- local register access. Pays off every time update-status fires.
local nf           = wezterm.nerdfonts
local NF_LIGHTNING = nf.md_lightning_bolt
local NF_LAYERS    = nf.cod_layers
local NF_FOLDER    = nf.md_folder
local NF_GIT       = nf.custom_folder_github
local NF_BRANCH    = nf.dev_git_branch
local NF_PLE_L     = nf.ple_left_half_circle_thick
local NF_PLE_R     = nf.ple_right_half_circle_thick

local function setup()
  -- Last-rendered signature per GUI window; used to skip rendering when nothing
  -- visible changed. Keyed by window id — a single shared slot would let two
  -- windows invalidate each other's entry on alternating ticks, defeating the
  -- skip entirely.
  local _last_sig = {}

  -- Branch cache: cwd_path → branch string. Avoids re-walking the filesystem
  -- on every tick for an unchanged cwd. Bounded LRU keeps memory under control
  -- across many directory visits; ~32 entries is plenty for typical workflows
  -- and ensures we don't thrash when switching between panes in different
  -- repos (the original single-slot cache did thrash).
  -- Trade-off: `git checkout` in the same pane (cwd unchanged) won't refresh
  -- the displayed branch until cwd changes. Matches the original behavior.
  local GIT_CACHE_MAX = 32
  local _branch_cache = {}       -- cwd_path → branch
  local _branch_cache_order = {} -- insertion order for LRU eviction

  local function branch_for(cwd_path)
    if not cwd_path or cwd_path == "" then return "" end
    local cached = _branch_cache[cwd_path]
    if cached ~= nil then return cached end
    local branch = utils.read_git_branch(cwd_path)
    _branch_cache[cwd_path] = branch
    _branch_cache_order[#_branch_cache_order + 1] = cwd_path
    if #_branch_cache_order > GIT_CACHE_MAX then
      local evict = table.remove(_branch_cache_order, 1)
      _branch_cache[evict] = nil
    end
    return branch
  end

  wezterm.on("update-status", function(window, pane)
    local color_scheme = window:effective_config().resolved_palette or {}
    local bg = wezterm.color.parse(color_scheme.background)
    local fg = wezterm.color.parse(color_scheme.foreground)
    -- Pre-read inputs for both the signature check and the rest of the handler.
    -- Pane handles are resolved against the mux at call time, so a pane that
    -- exited between event dispatch and now raises "pane id N not found in mux".
    -- Skip the tick; the next one arrives with the successor pane.
    local alive, info = pcall(function()
      return {
        cwd   = pane:get_current_working_dir(),
        title = pane:get_title(),
      }
    end)
    if not alive then return end

    local workspace         = window:active_workspace()
    local key_table         = window:active_key_table() or ""
    local leader            = window:leader_is_active()
    local cwd_path          = utils.get_cwd_path(info.cwd)
    local title             = info.title or ""
    local status_cwd_path   = cwd_path
    local local_tab_count   = #window:mux_window():tabs()
    local workspace_count   = #wezterm.mux.get_workspace_names()
    local active_tab        = window:active_tab()
    local active_pane_count = active_tab and #active_tab:panes() or 0

    -- Cheap discriminator: if nothing display-affecting has changed, skip
    -- the expensive mux walk and status re-render. Branch is intentionally
    -- NOT in the sig — it's cached per-cwd by branch_for() below, matching
    -- the original behavior of only refreshing on cwd change.
    local sig               = workspace .. "|" .. cwd_path .. "|" .. title
        .. "|" .. key_table .. "|" .. tostring(leader)
        .. "|" .. local_tab_count .. "|" .. workspace_count
        .. "|" .. active_pane_count

    local win_key           = window:window_id()
    if sig == _last_sig[win_key] then return end
    _last_sig[win_key] = sig

    -- Branch (cached by cwd_path; runs only on sig change, not every tick)
    local branch = branch_for(status_cwd_path)

    -- Determine left-status label + color.
    local stat = workspace
    local stat_color = "Red"
    if key_table ~= "" then
      stat = key_table
      stat_color = "Purple"
    end
    if leader then
      stat = NF_LIGHTNING .. NF_LIGHTNING
      stat_color = "Cyan"
    end

    local cwd              = status_cwd_path ~= "" and utils.basename(status_cwd_path) or ""

    local total_workspaces = workspace_count

    -- Right status: mutate dynamic text slots
    local git_name         = utils.get_git_name(status_cwd_path)
    local folder_icon      = git_name and NF_GIT or NF_FOLDER
    local git_or_folder    = (git_name and #git_name > 0 and git_name) or cwd

    local left_status      = ribbon:new "LeftStatus"
        :append(nil, stat_color, " " .. NF_LAYERS .. " " .. stat)

    window:set_left_status(left_status:format())

    local right_status = ribbon:new "RightStatus"
    right_status
        :append(bg:darken(0.1), bg, NF_PLE_L)
        :append(nil, "Olive", " " .. folder_icon .. " ")
        :append(nil, nil, git_or_folder)
        :append(nil, "Purple", " ⋮ ")

    if branch ~= "" then
      right_status
          :append(nil, "Purple", NF_BRANCH .. " ")
          :append(nil, nil, branch)
          :append(nil, "Purple", " ⋮ ")
    end

    right_status
        :append(nil, "Red", NF_LAYERS .. " ")
        :append(nil, nil, tostring(total_workspaces))

    local counts = agent_deck.count_agents_by_status()
    local cfg = agent_deck.get_config()

    right_status
        :append(nil, "Purple", " ⋮ ")
        :append(nil, "Yellow", cfg.icons.unicode.waiting .. " " .. counts.waiting .. " ")
        :append(nil, "Lime", cfg.icons.unicode.working .. " " .. counts.working .. " ")
        :append(nil, "Gray", cfg.icons.unicode.idle .. " " .. counts.idle .. " ")


    window:set_right_status(right_status:format())
  end)
end

return { setup = setup }
