local colors = require("helpers.colors")

Sbar.add("alias", "Control Center,BentoBox", {
  position = "right",
  background = {
    color = colors.bg1,
    border_width = 1,
    border_color = colors.green,
    corner_radius = 15,
    padding_left = 5,
    padding_right = 5,
  },
  click_script = "$CONFIG_DIR/scripts/bin/menus 'Control Center,BentoBox'",
})
