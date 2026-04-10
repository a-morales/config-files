vim.pack.add({ gh("ibhagwan/fzf-lua") })

local icons = require("icons")
local actions = require("fzf-lua.actions")

require("fzf-lua").setup({
  { "border-fused", "hide" },
  fzf_opts = {
    ["--info"] = "default",
    ["--layout"] = "reverse",
  },
  keymap = {
    builtin = {
      ["<C-/>"] = "toggle-help",
      ["<C-a>"] = "toggle-fullscreen",
      ["<C-i>"] = "toggle-preview",
    },
    fzf = {
      ["alt-s"] = "toggle",
      ["alt-a"] = "toggle-all",
      ["ctrl-i"] = "toggle-preview",
      ["ctrl-q"] = "select-all+accept",
    },
  },
  winopts = {
    height = 0.7,
    width = 0.55,
    preview = {
      layout = "vertical",
      vertical = "up:40%",
    },
  },
  buffers = {
    formatter = "path.filename_first",
    winopts = {
      height = 12,
      preview = { hidden = true },
    },
  },
  files = {
    winopts = {
      preview = { hidden = true },
    },
  },
  helptags = {
    actions = {
      -- Open help pages in a vertical split.
      ["enter"] = actions.help_vert,
    },
  },
  lsp = {
    symbols = {
      symbol_icons = icons.symbol_kinds,
    },
    code_actions = {
      winopts = {
        width = 70,
        height = 20,
        relative = "cursor",
        preview = {
          hidden = true,
          vertical = "down:50%",
        },
      },
    },
  },
})

local fzf_ui_select = require("fzf-lua.providers.ui_select")
fzf_ui_select.register(function(ui_opts)
  if ui_opts.kind == "luasnip" then
    ui_opts.prompt = "Snippet choice: "
    ui_opts.winopts = {
      relative = "cursor",
      height = 0.35,
      width = 0.3,
    }
  elseif ui_opts.kind == "color_presentation" then
    ui_opts.winopts = {
      relative = "cursor",
      height = 0.35,
      width = 0.3,
    }
  else
    ui_opts.winopts = { height = 0.5, width = 0.4 }
  end

  -- Use the kind (if available) to set the previewer's title.
  if ui_opts.kind then
    ui_opts.winopts.title = string.format(" %s ", ui_opts.kind)
  end

  -- Ensure that there's a space at the end of the prompt.
  if ui_opts.prompt and not vim.endswith(ui_opts.prompt, " ") then
    ui_opts.prompt = ui_opts.prompt .. " "
  end

  return ui_opts
end)
