return {
  "nvim-mini/mini.hipatterns",
  opts = {
    highlighters = {
      fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
      todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
      note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },
    },
  },
  config = function(_, opts)
    require("mini.hipatterns").setup(vim.tbl_deep_extend("force", opts, {
      highlighters = {
        hex_color = require("mini.hipatterns").gen_highlighter.hex_color(),
      },
    }))
  end,
}
