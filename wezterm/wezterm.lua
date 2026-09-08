--- @type Config
local config = require("configuration").setup()

require("agents").setup()
require("statusbar").setup()
require("tabs").setup()
require("keymaps").apply_to_config(config)

return config
