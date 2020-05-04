
local FORMNAME = "detached_chest_configure"

function detached_chest.show_form_configure(pos, player)

  local playername = player:get_player_name()
  local formspec = "field[channel;Channel;channel_name]"

  minetest.show_formspec(playername,
		FORMNAME .. ";" .. minetest.pos_to_string(pos),
		formspec
	)
end


minetest.register_on_player_receive_fields(function(player, formname, fields)
	local parts = formname:split(";")
	local name = parts[1]
	if name ~= FORMNAME then
		return
	end

	local pos = minetest.string_to_pos(parts[2])
	local meta = minetest.get_meta(pos)
	local playername = player:get_player_name()

	if minetest.is_protected(pos, playername) then
		return
	end

	if fields.channel then
		meta:set_string("channel", fields.channel)
    meta:set_string("infotext", "Detached Chest (channel: " .. fields.channel .. ")")
	end

end)
