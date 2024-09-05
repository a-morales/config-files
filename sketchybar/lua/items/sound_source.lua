local colors = require("helpers.colors")

Sbar.add("alias", "SoundSource,SSMainAppMenuIcon", {
  position = "right",
  background = {
    color = colors.bg1,
    border_width = 1,
    border_color = colors.blue,
    corner_radius = 15,
    padding_left = 5,
    padding_right = 5,
  },
  click_script = "$CONFIG_DIR/scripts/bin/menus 'SoundSource,SSMainAppMenuIcon'",
})
