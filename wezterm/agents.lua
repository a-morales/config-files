---@type Wezterm
local wezterm   = require("wezterm")
---@type Ribbon.Api
local ribbon    = wezterm.plugin.require("https://github.com/sravioli/ribbon.wz")
---@type Warp
local warp      = wezterm.plugin.require "https://github.com/sravioli/warp.wz"

local utils     = require("utils")

local M         = {}
local nf        = wezterm.nerdfonts

-- Processing state now arrives on the payload as `state`, derived by
-- status-hook.sh from the hook event name (replacing the stateFromHooks table
-- that used to live here). Deriving it there rather than here is what lets
-- subagents carry one too: every event fired from inside a subagent is tagged
-- with `agent_id` and routed to a per-subagent entry below, and one shared
-- table in the hook covers both scopes.
--
-- Events that carry no state signal (FileChanged, ConfigChange, CwdChanged...)
-- omit the field entirely, which means "keep the previous state" -- they used
-- to fall through the old table's `or "unknown"` and clobber a live `working`.
M.stateMarks    = {
  working = { glyph = "●", color = "Lime" },
  waiting = { glyph = "◔", color = "Yellow" },
  idle    = { glyph = "○", color = "Gray" },
}
M.unknownMark   = { glyph = "○", color = "Gray" }

M.AgentSelector = wezterm.action_callback(function(window, pane)
  local choices = {}

  for _, s in pairs(wezterm.GLOBAL.agents.state) do
    local pane_id       = tostring(s.pane_id)
    local state_pane    = wezterm.mux.get_pane(s.pane_id)
    local cwd           = s.cwd ~= "" and utils.basename(s.cwd) or ""
    local git_or_folder = utils.get_git_name(s.cwd) or cwd
    local git_branch    = utils.read_git_branch(s.cwd) or ""

    local label         = ribbon:new("AgentPane" .. tostring(s.pane_id))

    local workspace     = nf.cod_layers .. " " .. state_pane:window():get_workspace() .. " | "
    local text          = ((s.title and s.title .. "> ") or "") .. (s.message or state_pane:get_title())
    local mark          = M.stateMarks[s.state] or M.unknownMark
    local folder_icon   = (git_branch and #git_branch > 0 and nf.custom_folder_github) or nf.md_folder

    label
        :append(nil, "Red", workspace)

    if git_or_folder ~= "" then
      label
          :append(nil, "Olive", folder_icon .. " ")
          :append(nil, nil, git_or_folder .. " ")
    end

    if git_branch ~= "" then
      label
          :append(nil, "Purple", nf.dev_git_branch .. " ")
          :append(nil, nil, git_branch .. " ")
    end

    if git_or_folder ~= "" or git_branch ~= "" then
      label
          :append(nil, nil, "| ")
    end

    local label_prefix = label:format()

    label
        :append(nil, mark.color, mark.glyph .. " ")
        :append(nil, nil, text)

    table.insert(choices, {
      id = pane_id,
      label = label:format()
    })

    local subagent_list = {}
    for _, sa in pairs(s.subagents or {}) do
      table.insert(subagent_list, sa)
    end

    for i, sa in ipairs(subagent_list) do
      local pipe = (i < #subagent_list) and "├" or "└"

      local agent_text = ((sa.agent and sa.agent .. ": ") or "") ..
          ((sa.title and sa.title .. "> ") or "") .. (sa.message or "")

      local sub_mark = M.stateMarks[sa.state] or M.unknownMark

      local agent_label = ribbon:new("Subagent")
      agent_label
          :append(nil, nil, label_prefix, "Invisible")
          :append(nil, nil, pipe .. " ")
          :append(nil, sub_mark.color, sub_mark.glyph .. " ")
          :append(nil, nil, agent_text)

      table.insert(choices, {
        id = pane_id,
        label = agent_label:format()
      })
    end
  end

  if (#choices == 0) then
    return
  end

  window:perform_action(
    wezterm.action.InputSelector({
      action = wezterm.action_callback(function(_, _, id, label)
        if not id and not label then
        else
          local pane = wezterm.mux.get_pane(tonumber(id))
          if pane then
            local workspace = pane:window():get_workspace()
            if (workspace and window:active_workspace() ~= workspace) then
              wezterm.mux.set_active_workspace(workspace)
            end
            pane:activate()
          end
        end
      end),
      title = "Select agent",
      description = "Select an agent to jump to",
      choices = choices,
      fuzzy = true
    }),
    pane
  )
end)

function M.get_stats()
  return wezterm.GLOBAL.agents.stats
end

local function update_stats()
  local stats = {}
  local state_by_pane = {}

  for _, s in pairs(wezterm.GLOBAL.agents.state) do
    local state = s.state or "unknown"

    -- Subagents count toward `waiting` only. A subagent blocked on a permission
    -- prompt is the thing the status bar needs to surface, since nothing else
    -- will show it. Counting the busy ones as `working` would decouple that
    -- number from "how many panes are busy", which is what it's read as.
    for _, sa in pairs(s.subagents or {}) do
      if sa.state == "waiting" then
        stats.waiting = (stats.waiting or 0) + 1
      elseif sa.state == "working" then
        -- if a subagent is working mark the parent as also working so as to not show as actively required my input
        state = "working"
      end
    end

    state_by_pane[s.pane_id] = state
    stats[state] = (stats[state] or 0) + 1
  end

  wezterm.GLOBAL.agents.stats = stats
  wezterm.GLOBAL.agents.state_by_pane = state_by_pane
end

function M.setup()
  if (wezterm.GLOBAL.agents == nil) then
    wezterm.GLOBAL.agents = {
      state = {},
      stats = {},
      state_by_pane = {}
    }
  end

  wezterm.on('user-var-changed', function(window, pane, name, value)
    if (name == "AGENT_INPUT") then
      local input = wezterm.serde.json_decode(value)
      local event = input["event"]
      local session = input["session"]
      local agent_id = input["agent_id"]
      local state = wezterm.GLOBAL.agents.state or {}
      local pane_id = tostring(pane:pane_id())
      local agent_state = state[pane_id] or {}
      local subagents = agent_state["subagents"] or {}


      if (event == "SessionEnd") then
        agent_state = nil
      elseif (event == "SubagentStop") then
        subagents[agent_id] = nil
        agent_state.subagents = subagents
      elseif (event == "SubagentStart") or (agent_id ~= nil) then
        -- Merge into the existing entry instead of replacing it. A payload only
        -- carries the fields its event actually has, so replacing would blank
        -- the state (and tool/message) that the subagent's last stateful event
        -- established.
        local subagent = subagents[agent_id] or {}
        local previous = subagent.state
        warp.table.merge("force", subagent, input)
        subagent.state = input.state or previous or "unknown"
        subagents[agent_id] = subagent
        agent_state.subagents = subagents
      else
        -- "force" so the newest payload wins: with "keep" the leftmost table
        -- won every conflict, which froze message/tool/title at whatever the
        -- first event happened to carry and never updated them again.
        local previous = agent_state.state
        agent_state.pane_id = pane:pane_id()
        warp.table.merge("force", agent_state, input)
        agent_state.state = input.state or previous or "unknown"
      end

      state[pane_id] = agent_state
      wezterm.GLOBAL.agents.state = state
      update_stats()
    end
  end)
end

return M
