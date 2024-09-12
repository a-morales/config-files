local colors = require("helpers.colors")
local icons = require("helpers.icons")

apps = {}
appGroup = nil

function load_apps()
  if appGroup ~= nil then
    Sbar.remove("apps_bracket")
  end

  for name, app in pairs(apps) do
    Sbar.remove("app." .. name)
  end
  apps = {}
  local app_names = {}
  Sbar.exec("aerospace list-windows --workspace focused | cut -f 2 -d '|'", function(focused_apps_result)
    Sbar.exec("aerospace list-windows --focused | cut -f 2 -d '|'", function(focused_app_result)
      local focused_apps = split(focused_apps_result, "\n")
      local app_in_focus = split(focused_app_result, "\n")[1]

      for _, app_name in ipairs(focused_apps) do
        local app = Sbar.add("item", "app." .. app_name, {
          icon = {
            string = icons.apps[app_name] or icons.apps["Unknown"],
            color = app_name == app_in_focus and colors.green or colors.white,
            align = "center",
            padding_left = 5,
            padding_right = 5,
          },
          label = {
            drawing = false,
          },
        })

        apps[app_name] = app
        table.insert(app_names, "app." .. app_name)
      end

      appGroup = Sbar.add("bracket", "apps_bracket", app_names, {
        background = {
          color = colors.bg1,
          border_color = colors.white,
          corner_radius = 15,
          padding_left = 20,
          padding_right = 5,
        },
        padding_left = 20,
      })

      appGroup:subscribe({ "front_app_switched" }, function(env)
        if apps[env.INFO] == nil then
          return load_apps()
        end
        for name, app in pairs(apps) do
          app:set({
            icon = {
              color = name == env.INFO and colors.green or colors.white,
            },
          })
        end
      end)
    end)
  end)
end

return load_apps
