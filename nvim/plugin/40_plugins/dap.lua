vim.pack.add({
  gh("igorlfs/nvim-dap-view"),
  gh("mfussenegger/nvim-dap"),
})

local dap = require("dap")
local dapview = require("dap-view")

dapview.setup({
  winbar = {
    controls = {
      enabled = true,
    },
  },
})

dap.listeners.before.attach.dapui_config = function()
  dapview.open()
end
dap.listeners.before.launch.dapui_config = function()
  dapview.open()
end

dap.listeners.after["event_terminated"]["nvim-metals"] = function()
  dapview.open()
  dapview.jump_to_view("repl")
end
