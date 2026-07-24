local M = {}

---@param wezterm Wezterm
M.setup = function(wezterm)
  wezterm.on('user-var-changed', function(window, pane, name, value)
    wezterm.log_info("got a var ", name, " = ", value, " from window: ", window:window_id(), ", pane: ", pane:pane_id())
  end)
end

return M
