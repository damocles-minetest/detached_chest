
local FORMNAME = "detached_chest_inventory"

function detached_chest.show_form_inventory(pos, player)

  local meta = minetest.get_meta(pos)
  local channel = meta:get_string("channel")
  detached_chest.setup_inventory(player, channel)

  local inv_name = detached_chest.get_inventory_name(player, channel)

  local playername = player:get_player_name()
  local formspec = "size[8,9]"..
    default.gui_bg ..
    default.gui_bg_img ..
    default.gui_slots ..
    "list[detached:" .. inv_name .. ";main;0,0.3;8,4;]"..
    "list[current_player;main;0,4.85;8,1;]" ..
    "list[current_player;main;0,6.08;8,3;8]" ..
    "listring[detached:" .. inv_name .. ";main]" ..
    "listring[current_player;main]" ..
    default.get_hotbar_bg(0,4.85)

  minetest.show_formspec(playername,
		FORMNAME .. ";" .. minetest.pos_to_string(pos),
		formspec
	)
end
