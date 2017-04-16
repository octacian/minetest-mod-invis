-- invis/init.lua

invis = {}
local invisible = {}

-- [function] Get visible
function invis.get(name)
  if type(name) == "userdata" then
    name = player:get_player_name()
  end

  return invisible[name]
end

-- [function] Toggle invisible
function invis.toggle(player, toggle)
  if type(player) == "string" then
    player = minetest.get_player_by_name(player)
  end

  local prop, msg
  local name      = player:get_player_name()
  invisible[name] = toggle

  if toggle == true then
    -- Hide player and nametag
    prop = {
      visual_size = {x = 0, y = 0},
      collisionbox = {0, 0, 0, 0, 0, 0},
    }
    player:set_nametag_attributes({
      color = {a = 0, r = 255, g = 255, b = 255},
    })
    msg = "now invisible"
  else
    -- Show player and nametag
    prop = {
			visual_size = {x = 1, y = 1},
			collisionbox = {-0.35, -1, -0.35, 0.35, 1, 0.35},
		}
		player:set_nametag_attributes({
			color = {a = 255, r = 255, g = 255, b = 255},
		})
    msg = "no longer invisible"
  end

  -- Update properties
  player:set_properties(prop)
  -- Return message
  return name.." is "..msg
end

-- [register] Privilege
minetest.register_privilege("invisibility", "Allow use of /invisible command")

-- [register] Command
minetest.register_chatcommand("invisible", {
  description = "Make yourself or another player invisible",
  params = "<name>",
  privs = {invisibility=true},
  func = function(name, param)
    if minetest.get_player_by_name(param) then
      name = param
    elseif param ~= "" then
      return false, "Invalid player \""..param.."\""
    end

    return true, invis.toggle(name, not invisible[name])
  end,
})
