
local basedir = minetest.get_worldpath() .. "/detached_chest"
minetest.mkdir(basedir)

local get_save_file = function(playername, channel)
	local saneplayername = string.gsub(playername, "[.|/]", "")
  local sanechannelname = string.gsub(channel, "[.|/]", "")

  minetest.mkdir(basedir .. "/" .. saneplayername)
	return basedir .. "/" .. saneplayername .. "/" .. sanechannelname
end

-- playername -> { inv_name = <inv>, inv_name2 = <inv> }
local player_inventories = {}

function detached_chest.get_inventory_name(player, channel)
  return player:get_player_name() .. ":" .. channel
end

-- create / get
function detached_chest.setup_inventory(player, channel)
  local inv_name = detached_chest.get_inventory_name(player, channel)
  local playername = player:get_player_name()

  local inv_map = player_inventories[playername]
  if not inv_map then
    inv_map = {}
    player_inventories[playername] = inv_map
  end

  local inv = inv_map[inv_name]
  if not inv then
    inv = minetest.create_detached_inventory(inv_name, {}) -- TODO: on_* checks
    inv:set_size("main", 8*4)

    -- restore
    local save_file = get_save_file(playername, inv_name)
    local file = io.open(save_file,"r")
    local data = file:read("*a")
    if data then
      inv:set_list("main", minetest.deserialize(data))
    end
    file:close()

    inv_map[inv_name] = inv
  end

  return inv
end

-- cleanup
minetest.register_on_leaveplayer(function(player)
  local playername = player:get_player_name()

  if not player_inventories[playername] then
    return
  end

  for inv_name, inv in pairs(player_inventories[playername]) do
    -- persist
    local save_file = get_save_file(playername, inv_name)
    local file = io.open(save_file,"w")
    local data = minetest.serialize(inv:get_list("main"))
    file:write(data)
    file:close()

    minetest.remove_detached_inventory(inv_name)
  end
end)
