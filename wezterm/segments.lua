local wezterm = require("wezterm")

local M = {}

-- Cache for right status segments
local cache = {
  memory = "",
  day = "",
  last_update_ms = 0,
}

local function is_process_running(image)
  local ok, _, _ = wezterm.run_child_process({
    "pgrep",
    "-q",
    "-x",
    image,
  })

  return ok
end

local function get_playback_status()
  -- Check if spotify_player process is running
  if not is_process_running("spotify_player") then
    return ""
  end

  local success, result, _ = wezterm.run_child_process({
    "spotify_player",
    "get",
    "key",
    "playback",
  })

  if not success or not result then
    return "1N/A"
  end

  -- Trim whitespace
  result = result:gsub("^%s*(.-)%s*$", "%1")

  if result == "null" then
    return "2N/A"
  end

  local status_data = wezterm.json_parse(result)
  local is_playing, track_name = status_data.is_playing, status_data.item.name

  -- Handle track name (nil if not found or null)
  if not track_name or track_name == "null" or track_name == "" then
    track_name = nil
  end

  if is_playing == nil and track_name == nil then
    return "󰎊"
  elseif is_playing == false and track_name then
    return "󰏤 " .. track_name
  elseif is_playing == true and track_name then
    return "󰐊 " .. track_name
  else
    return ""
  end
end

local function get_memory_usage()
  -- the below command will give us the following output:
  --  13GiB/24GiB
  local pcall_ok, success, output, _ = pcall(wezterm.run_child_process, {
    "/opt/homebrew/bin/starship",
    "module",
    "memory_usage",
  })

  if not pcall_ok then
    return ""
  end

  if not success or not output or output == "" then
    return "1N/A"
  end

  -- Remove ANSI escape sequences (pattern matches ESC[ followed by any characters until 'm')
  output = output:gsub("\27%[[0-9;]*m", "")
  -- Trim whitespace from both ends
  output = output:match("^%s*(.-)%s*$")

  return output
end

-- Returns true if we should refresh based on the effective status update interval
local function is_stale(window)
  local now_ms = os.time() * 1000
  local interval_ms = window:effective_config().status_update_interval
  return (now_ms - cache.last_update_ms) >= interval_ms
end

local function refresh_cache()
  -- Update synchronously; this runs at most as often as status_update_interval
  cache.memory = get_memory_usage() or ""
  -- cache.day = wezterm.strftime(" %a, %b %-d")
  cache.last_update_ms = os.time() * 1000
end

function M.get_right_status_segments(window)
  return {
    window:active_workspace(),
  }
end

return M
