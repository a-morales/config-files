vim.pack.add({ gh("mrjones2014/smart-splits.nvim") })

-- Shared with the Hammerspoon and WezTerm configs; see ~/.config/lua/aerospace.lua.
package.path = os.getenv("HOME") .. "/.config/lua/?.lua;" .. package.path
local aerospace = require("aerospace")

require("smart-splits").setup({
  at_edge = function(ctx)
    if (ctx.direction == "left" or ctx.direction == "right") then
      vim.system(aerospace.sh(aerospace.focus_or_cycle_cmd(ctx.direction)))
    end
  end

})
