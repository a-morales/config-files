local colors = require("helpers.colors")

local cal = Sbar.add("item", {
  position = "right",
  icon = {
    color = colors.white,
    align = "left",
    padding_left = 10,
    padding_right = 5,
  },
  label = {
    color = colors.white,
    align = "right",
    padding_right = 10,
  },
  background = {
    drawing = true,
    color = colors.bg1,
    border_width = 1,
    border_color = colors.red,
    corner_radius = 15,
    padding_left = 5,
    padding_right = 5,
  },
})

cal:subscribe({ "forced", "routine", "system_woke" }, function(_)
  cal:set({ icon = os.date("%b %d"), label = os.date("%H:%M") })
end)
