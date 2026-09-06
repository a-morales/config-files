--- @type Wezterm
local wezterm    = require("wezterm")
local agent_deck = wezterm.plugin.require('https://github.com/Eric162/wezterm-agent-deck')

--- @type Config
local config     = require("configuration").setup()

agent_deck.apply_to_config(config, {
  tab_title = { enabled = false },
  right_status = { enabled = false },
})

require("statusbar").setup()
require("tabs").setup()
require("keymaps").apply_to_config(config)

wezterm.on('user-var-changed', function(window, pane, name, value)
  wezterm.log_info("user-var-changed: " .. name .. "='" .. value .. "'")
end)

return config
