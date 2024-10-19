local colors = require("helpers.colors")

local cal = Sbar.add("item", {
  position = "right",
  update_freq = 30,
  icon = {
    color = colors.white,
    align = "left",
    padding_right = 5,
  },
  label = {
    color = colors.white,
    align = "right",
    padding_right = 10,
  },
})

cal:subscribe({ "forced", "routine", "system_woke" }, function(_)
  cal:set({ icon = os.date("%b %d"), label = os.date("%H:%M") })
end)
