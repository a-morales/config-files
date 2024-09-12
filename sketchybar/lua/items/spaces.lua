local colors = require("helpers.colors")
local load_apps = require("items.apps")

Sbar.add("event", "aerospace_workspace_change")

local spaces = {}
local space_names = {}

Sbar.exec("aerospace list-workspaces --all", function(all_workspaces)
  Sbar.exec("aerospace list-workspaces --focused", function(focused_workspace_output)
    local workspaces = split(all_workspaces, "\n")
    local focused_workspace = split(focused_workspace_output, "\n")[1]

    Sbar.add("item", { width = 5 })

    for _, workspace in ipairs(workspaces) do
      local space = Sbar.add("item", "space." .. workspace, {
        position = "left",
        icon = {
          string = workspace,
          color = colors.white,
          align = "center",
          width = 30,
        },
        background = {
          drawing = focused_workspace == workspace,
          color = colors.blue,
          corner_radius = 15,
          border_color = colors.blue,
          border_width = 1,
        },
        padding_left = 0,
        padding_right = 0,
        label = {
          drawing = false,
        },
        click_script = "aerospace workspace " .. workspace,
      })

      spaces[workspace] = space
      table.insert(space_names, "space." .. workspace)
    end

    local bracket = Sbar.add("bracket", "spaces_bracket", space_names, {
      position = "left",
      background = {
        color = colors.bg1,
        border_width = 1,
        border_color = colors.blue,
        corner_radius = 15,
        padding_left = 5,
        padding_right = 5,
      },
    })

    bracket:subscribe({ "aerospace_workspace_change" }, function(env)
      for name, s in pairs(spaces) do
        s:set({ background = { drawing = name == env["FOCUSED_WORKSPACE"] } })
      end
      load_apps()
    end)

    load_apps()
  end)
end)
