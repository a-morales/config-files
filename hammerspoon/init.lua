navigation = hs.hotkey.modal.new('ctrl', ';')

local timer = nil
local modalTimeout = 0.5

function navigation:entered()
  timer = hs.timer.doAfter(modalTimeout, function()
    timer = nil
    navigation:exit()
  end)
end

function debounceTimer()
  if timer then
    timer = timer:setNextTrigger(modalTimeout)
  end
end

function focusWindow(direction)
  return function()
    hs.window.focusedWindow()[direction]()
    debounceTimer()
  end
end

navigation:bind('', 'h', focusWindow('focusWindowWest'))
navigation:bind('', 'l', focusWindow('focusWindowEast'))
navigation:bind('', 'j', focusWindow('focusWindowSouth'))
navigation:bind('', 'k', focusWindow('focusWindowNorth'))
navigation:bind('ctrl', 'h', focusWindow('focusWindowWest'))
navigation:bind('ctrl', 'l', focusWindow('focusWindowEast'))
navigation:bind('ctrl', 'j', focusWindow('focusWindowSouth'))
navigation:bind('ctrl', 'k', focusWindow('focusWindowNorth'))

navigation:bind('', 'escape', function()
  timer:stop()
  timer = nil
  navigation:exit()
end)
