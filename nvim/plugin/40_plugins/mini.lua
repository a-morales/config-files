vim.pack.add({ gh("nvim-mini/mini.nvim") })

local icons = require("icons")

require("mini.statusline").setup()
require("mini.icons").setup()

MiniIcons.mock_nvim_web_devicons()

require("mini.cursorword").setup()
require("mini.bracketed").setup({
  diagnostic = { options = { severity = vim.diagnostic.severity.ERROR } },
  comment = { suffix = "" },
})
require("mini.jump").setup()
require("mini.pairs").setup()
require("mini.trailspace").setup()
require("mini.bufremove").setup()
-- require("mini.notify").setup()

local miniAi = require("mini.ai")
miniAi.setup({
  custom_textobjects = {
    F = miniAi.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }),
  },
  search_method = "cover",
})

local miniHipatterns = require("mini.hipatterns")
local hi_words = require("mini.extra").gen_highlighter.words
miniHipatterns.setup({
  highlighters = {
    hack = hi_words({ "HACK", "Hack", "hack" }, "MiniHipatternsHack"),
    todo = hi_words({ "TODO", "Todo", "todo" }, "MiniHipatternsTodo"),
    note = hi_words({ "NOTE", "Note", "note" }, "MiniHipatternsNote"),
    hex_color = miniHipatterns.gen_highlighter.hex_color(),
  },
})

local miniIndentscope = require("mini.indentscope")
miniIndentscope.setup({
  draw = {
    animation = miniIndentscope.gen_animation.quadratic({
      easing = "out",
      duration = 100,
      unit = "total",
    }),
  },
  options = {
    n_lines = 500,
  },
  symbol = icons.misc.dashed_bar,
})
require("mini.surround").setup({
  mappings = {
    add = "ys",
    delete = "ds",
    find = "",
    find_left = "",
    highlight = "",
    replace = "cs",
  },
  search_method = "cover_or_next",
})

local miniClue = require("mini.clue")
miniClue.setup({
  window = {
    config = {
      anchor = "SE",
      row = "auto",
      col = "auto",
    },
    delay = 200,
  },
  clues = {
    Config.leader_group_clues,
    miniClue.gen_clues.builtin_completion(),
    miniClue.gen_clues.g(),
    miniClue.gen_clues.marks(),
    miniClue.gen_clues.registers(),
    miniClue.gen_clues.windows({ submode_resize = true }),
    miniClue.gen_clues.z(),
  },
  triggers = {
    { mode = "n", keys = "<Leader>" },
    { mode = "x", keys = "<Leader>" },
    -- { mode = "n", keys = "\\" }, -- mini.basics
    { mode = "n", keys = "[" },
    { mode = "n", keys = "]" },
    { mode = "x", keys = "[" },
    { mode = "x", keys = "]" },
    { mode = "i", keys = "<C-x>" }, -- Built-in completion
    { mode = "n", keys = "gr", "+LSP" },
    { mode = "n", keys = "g" },
    { mode = "x", keys = "g" },
    { mode = "n", keys = "'" }, -- Marks
    { mode = "n", keys = "`" },
    { mode = "x", keys = "'" },
    { mode = "x", keys = "`" },
    { mode = "n", keys = '"' }, -- Registers
    { mode = "x", keys = '"' },
    { mode = "i", keys = "<C-r>" },
    { mode = "c", keys = "<C-r>" },
    { mode = "n", keys = "<C-w>" }, -- Window commands
    { mode = "n", keys = "z" }, -- `z` key
    { mode = "x", keys = "z" },
  },
})
