return {
  "folke/snacks.nvim",
  keys = {
    { "<C-n>", "<leader>fe", desc = "Explorer Snacks (root dir)", remap = true },
    { "<C-p>", "<leader>fg", desc = "Find Files (git-files)", remap = true },
    { "<C-space>", "<leader>,", desc = "Buffers", remap = true },
  },
  opts = {
    picker = {
      sources = {
        explorer = {
          actions = {
            bufadd = function(_, item)
              if vim.fn.bufexists(item.file) == 0 then
                local buf = vim.api.nvim_create_buf(true, false)
                vim.api.nvim_buf_set_name(buf, item.file)
                vim.api.nvim_buf_call(buf, vim.cmd.edit)
              end
            end,
            confirm_nofocus = function(picker, item)
              if item.dir then
                picker:action("confirm")
              else
                picker:action("bufadd")
              end
            end,
          },
          win = {
            list = {
              keys = {
                ["l"] = "confirm_nofocus",
                ["L"] = "confirm",
              },
            },
          },
          auto_close = true,
          layout = {
            cycle = true,
            preview = true, ---@diagnostic disable-line: assign-type-mismatch
            layout = {
              box = "horizontal",
              position = "float",
              height = 0.75,
              width = 0.75,
              border = "rounded",
              {
                box = "vertical",
                width = 40,
                min_width = 40,
                { win = "input", height = 1, title = "{title} {live} {flags}", border = "single" },
                { win = "list" },
              },
              { win = "preview", width = 0, border = "left" },
            },
          },
        },
      },
    },
  },
}
