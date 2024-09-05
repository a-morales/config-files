local colors = require("helpers.colors")
local font = require("helpers.font")

Sbar.default({
  updates = "when_shown",
  icon = {
    font = {
      family = font.text,
      style = font.style_map["Bold"],
      size = 14.0,
    },
    color = colors.white,
    padding_left = 2,
    padding_right = 2,
    background = { image = { corner_radius = 9 } },
  },
  label = {
    font = {
      family = font.text,
      style = font.style_map["Semibold"],
      size = 14.0,
    },
    y_offset = -2,
    color = colors.white,
    padding_left = 2,
    padding_right = 2,
  },
  background = {
    height = 28,
    corner_radius = 9,
    border_width = 2,
    border_color = colors.bg2,
    image = {
      corner_radius = 9,
      border_color = colors.grey,
      border_width = 1,
    },
  },
  popup = {
    background = {
      border_width = 2,
      corner_radius = 9,
      border_color = colors.popup.border,
      color = colors.popup.bg,
      shadow = { drawing = true },
    },
    blur_radius = 50,
  },
  scroll_texts = true,
})
