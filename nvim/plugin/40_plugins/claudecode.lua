vim.pack.add({ gh("coder/claudecode.nvim") })

require("claudecode").setup({
  terminal = {
    -- Don't use Neovim's built-in terminal; launch Claude in a new WezTerm pane.
    provider = "external",
    provider_opts = {
      -- `wezterm cli split-pane` spawns through the mux server, which inherits
      -- neither this process's environment nor a login shell's PATH. Two things
      -- to handle:
      --   1. Run the command inside `fish -l -i` so PATH is populated and
      --      `claude` (in ~/.local/bin) resolves. The `-i` is required: our
      --      config.fish early-returns for non-interactive shells, so a plain
      --      `fish -l -c` bails before it adds ~/.local/bin to PATH.
      --   2. Forward Claude's IDE-connection vars (CLAUDE_CODE_SSE_PORT,
      --      ENABLE_IDE_INTEGRATION, ...) explicitly via `env`.
      -- Returning a table makes the provider use these argv parts verbatim, so
      -- there is no shell-quoting to get wrong. `; exec fish` keeps the pane open
      -- after Claude exits instead of letting it close instantly.
      external_terminal_cmd = function(cmd, env)
        local sets = {}
        for key, value in pairs(env or {}) do
          sets[#sets + 1] = string.format("%s=%s", key, value)
        end
        local inner = string.format("env %s %s; exec fish", table.concat(sets, " "), cmd)
        return {
          "wezterm",
          "cli",
          "split-pane",
          "--right",
          "--percent",
          "35",
          "--",
          "fish",
          "-l",
          "-i",
          "-c",
          inner,
        }
      end,
    },
  },
})
