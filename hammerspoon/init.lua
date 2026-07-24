-- Aerospace keybindings, driven from Hammerspoon.
--
-- Aerospace still does the actual tiling; Hammerspoon just owns the
-- keybindings so that the "active" and "resize" modes can auto-exit back to
-- "main" after a period of inactivity (something aerospace can't do on its
-- own). The bindings below mirror the old aerospace.toml [mode.*.binding]
-- sections.

local AEROSPACE    = "/opt/homebrew/bin/aerospace"
local BORDERS      = "/opt/homebrew/bin/borders"

-- Seconds of inactivity before the active/resize modes drop back to main.
-- Set to 0 to disable the auto-exit timeout.
local MODE_TIMEOUT = 1

-- JankyBorders active color per mode (from the old aerospace config; the
-- main color fixes the stray "0x0x" typo in the original).
local COLORS       = {
  main   = "0xddd5c4a1",
  active = "0xddbdd322",
  resize = "0x4f809da1",
}

-- Helpers -------------------------------------------------------------------

-- Run an aerospace subcommand asynchronously.
local function aero(...)
  hs.task.new(AEROSPACE, nil, { ... }):start()
end

-- Run a shell pipeline asynchronously (needed for piped aerospace commands).
local function shell(cmd)
  hs.task.new("/bin/sh", nil, { "-c", cmd }):start()
end

-- Set the JankyBorders active color.
local function borders(color)
  hs.task.new(BORDERS, nil, { "active_color=" .. color }):start()
end

-- Cycle to the next/prev non-empty workspace on the focused monitor.
local function cycleWorkspace(dir)
  shell(AEROSPACE .. " list-workspaces --monitor focused --empty no | "
    .. AEROSPACE .. " workspace --wrap-around " .. dir .. " --stdin")
end

-- Modes ---------------------------------------------------------------------

local modes = {
  main   = hs.hotkey.modal.new(),
  active = hs.hotkey.modal.new(),
  resize = hs.hotkey.modal.new(),
}

-- Only these modes auto-exit on inactivity; main is the resting state.
local timed = { active = true, resize = true }

local timeoutTimer = nil
local enterMode -- forward declaration

local function clearTimeout()
  if timeoutTimer then
    timeoutTimer:stop()
    timeoutTimer = nil
  end
end

-- (Re)arm the inactivity timer that drops back to main.
local function armTimeout()
  clearTimeout()
  if MODE_TIMEOUT and MODE_TIMEOUT > 0 then
    timeoutTimer = hs.timer.doAfter(MODE_TIMEOUT, function()
      enterMode("main")
    end)
  end
end

enterMode = function(name)
  for n, m in pairs(modes) do
    if n ~= name then m:exit() end
  end
  modes[name]:enter()
  borders(COLORS[name])
  if timed[name] then armTimeout() else clearTimeout() end
end

-- Wrap an action so that, after running, it resets the inactivity timer.
-- Used for the in-mode action keys (not the mode-transition keys).
local function tick(fn)
  return function()
    fn()
    armTimeout()
  end
end

-- main mode -----------------------------------------------------------------

modes.main:bind({ "ctrl" }, ";", function() enterMode("active") end)
modes.main:bind({ "ctrl", "cmd" }, ";", function() enterMode("resize") end)
modes.main:bind({ "ctrl", "cmd" }, "l", function() cycleWorkspace("next") end)
modes.main:bind({ "ctrl", "cmd" }, "h", function() cycleWorkspace("prev") end)

-- active mode ---------------------------------------------------------------

modes.active:bind({ "ctrl", "cmd" }, ";", function() enterMode("resize") end)
modes.active:bind({}, "escape", function() enterMode("main") end)

modes.active:bind({ "ctrl" }, "h", tick(function() aero("focus", "left") end))
modes.active:bind({ "ctrl" }, "j", tick(function() aero("focus", "down") end))
modes.active:bind({ "ctrl" }, "k", tick(function() aero("focus", "up") end))
modes.active:bind({ "ctrl" }, "l", tick(function() aero("focus", "right") end))
modes.active:bind({ "ctrl" }, "n", tick(function() aero("focus-back-and-forth") end))

modes.active:bind({ "ctrl", "cmd" }, "h", tick(function() aero("move", "left") end))
modes.active:bind({ "ctrl", "cmd" }, "j", tick(function() aero("move", "down") end))
modes.active:bind({ "ctrl", "cmd" }, "k", tick(function() aero("move", "up") end))
modes.active:bind({ "ctrl", "cmd" }, "l", tick(function() aero("move", "right") end))

for i = 1, 5 do
  modes.active:bind({}, tostring(i), tick(function() aero("workspace", tostring(i)) end))
end

modes.active:bind({}, ",", tick(function() aero("reload-config") end))
modes.active:bind({}, "=", tick(function() aero("balance-sizes") end))

-- resize mode ---------------------------------------------------------------

modes.resize:bind({ "ctrl" }, ";", function() enterMode("active") end)
modes.resize:bind({}, "escape", function() enterMode("main") end)

modes.resize:bind({}, "z", tick(function() aero("fullscreen") end))
modes.resize:bind({}, "f", tick(function() aero("layout", "floating", "tiling") end))
modes.resize:bind({}, "s", tick(function() aero("layout", "tiles", "accordion") end))
modes.resize:bind({}, "\\", tick(function() aero("layout", "horizontal", "vertical") end))

modes.resize:bind({}, "-", tick(function() aero("resize", "smart", "-50") end))
modes.resize:bind({}, "=", tick(function() aero("resize", "smart", "+50") end))

for i = 1, 5 do
  modes.resize:bind({}, tostring(i), tick(function() aero("move-node-to-workspace", tostring(i)) end))
end
modes.resize:bind({}, "l", tick(function() aero("move-node-to-workspace", "--wrap-around", "next") end))
modes.resize:bind({}, "h", tick(function() aero("move-node-to-workspace", "--wrap-around", "prev") end))

-- Start in main mode.
enterMode("main")
hs.alert.show("Aerospace bindings loaded")
