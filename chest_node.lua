
minetest.register_node("detached_chest:detached_chest", {
	description = "Detached Chest",
	tiles = {
    "wifi_top.png",
    "wifi_top.png",
    "wifi_side.png",
		"wifi_side.png",
    "wifi_side.png",
    "wifi_front.png"
  },
	paramtype2 = "facedir",

	groups = {
    snappy=2,
    choppy=2,
    oddly_breakable_by_hand=2
  },

	sounds = default.node_sound_wood_defaults(),

  after_place_node = function(pos, placer)
		local meta = minetest.get_meta(pos)
		meta:set_string("owner", placer:get_player_name())
    meta:set_string("infotext", "Detached Chest (unconfigured)")
	end,

	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_string("formspec",
				"size[8,9]"..
				default.gui_bg ..
				default.gui_bg_img ..
				default.gui_slots ..
				"list[current_player;more_chests:wifi;0,0.3;8,4;]"..
				"list[current_player;main;0,4.85;8,1;]" ..
				"list[current_player;main;0,6.08;8,3;8]" ..
				"listring[current_player;more_chests:wifi]" ..
				"listring[current_player;main]" ..
				default.get_hotbar_bg(0,4.85))

	end,

  on_rightclick = function(pos, _, player)
    local meta = minetest.get_meta(pos)
    if meta:get_string("channel") == "" then
      detached_chest.show_form_configure(pos, player)
    else
      detached_chest.show_form_inventory(pos, player)
    end
  end

})
