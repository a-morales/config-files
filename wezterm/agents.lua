---@type Wezterm
local wezterm        = require("wezterm")
---@type Ribbon.Api
local ribbon         = wezterm.plugin.require("https://github.com/sravioli/ribbon.wz")
---@type Warp
local warp           = wezterm.plugin.require "https://github.com/sravioli/warp.wz"

local M              = {}
local nf             = wezterm.nerdfonts

local stateFromHooks = {
  UserPromptSubmit = "working",
  PostToolUse = "working",
  PermissionRequest = "waiting",
  Notification = "waiting",
  Stop = "idle",
  SessionStart = "idle",
}

M.state              = {}

M.stats              = {}

M.AgentSelector      = wezterm.action_callback(function(window, pane)
  local choices = {}

  for _, s in pairs(M.state) do
    local pane_id = tostring(s.pane_id)
    local state_pane = wezterm.mux.get_pane(s.pane_id)
    local workspace = nf.cod_layers .. " " .. state_pane:window():get_workspace() .. " | "
    local text = ((s.title and s.title .. "> ") or "") .. (s.message or "")

    local label = ribbon:new("AgentPane" .. tostring(s.pane_id))
        :append(nil, "Red", workspace)
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

      local agent_label = ribbon:new("Subagent")
          :append(nil, nil, workspace, "Invisible")
          :append(nil, nil, pipe .. agent_text)

      table.insert(choices, {
        id = pane_id,
        label = agent_label:format()
      })
    end
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

local function update_stats()
  local stats = {}

  for _, s in pairs(M.state) do
    local state = s.state or "unknown"
    local count = stats[state] or 0
    stats[state] = count + 1
  end

  M.stats = stats
end

function M.setup()
  wezterm.on('user-var-changed', function(window, pane, name, value)
    if (name == "AGENT_INPUT") then
      local input = wezterm.serde.json_decode(value)
      local event = input["event"]
      local session = input["session"]
      local agent_id = input["agent_id"]
      local agent_state = M.state[session] or {}
      local subagents = agent_state["subagents"] or {}

      if (event == "SessionEnd") then
        agent_state = nil
      elseif (event == "SubagentStop") then
        subagents[agent_id] = nil
        agent_state.subagents = subagents
      elseif (event == "SubagentStart") or (agent_id ~= nil) then
        subagents[agent_id] = input
        agent_state.subagents = subagents
      else
        agent_state.pane_id = pane:pane_id()
        agent_state.state = stateFromHooks[event] or "unknown"
        warp.table.merge("keep", agent_state, input)
      end

      M.state[session] = agent_state
      update_stats()

      wezterm.log_info("processed input")
      wezterm.log_info(input)
      wezterm.log_info("updated state")
      wezterm.log_info(M.state)
    end
  end)
end

return M
