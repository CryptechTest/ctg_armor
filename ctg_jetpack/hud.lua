
local HUD_POSITION = { x = 0.09, y = 0.48 }
local OFFSET_LABEL = { x = 0, y = -16 }
local OFFSET_LEVEL = { x = 0, y = 16}
local OFFSET_WARNING = { x = 0, y = -34 }
local OFFSET_BAR = { x = 0, y = 0 }
local HUD_ALIGNMENT = { x = 1, y = 0 }

local hud = {} -- playername -> data


local setup_hud = function(player)
	local playername = player:get_player_name()
	local hud_data = {}
	hud[playername] = hud_data

	hud_data.fuel_bg = player:hud_add({
		hud_elem_type = "image",
		position = HUD_POSITION,
		offset = OFFSET_BAR,
		text = "jetpack_fuel_levels_bg.png",
		alignment = HUD_ALIGNMENT,
		scale = { x = -7, y = 1 }
	})

	hud_data.fuel_fg = player:hud_add({
		hud_elem_type = "image",
		position = HUD_POSITION,
		offset = OFFSET_BAR,
		text = "jetpack_fuel_levels_fg_blue.png",
		alignment = HUD_ALIGNMENT,
		scale = { x = 0, y = 1 }
	})

	hud_data.fuel_label = player:hud_add({
		hud_elem_type = "text",
		position = HUD_POSITION,
		offset = OFFSET_LABEL,
		text = "Fuel-Level:",
		alignment = HUD_ALIGNMENT,
		scale = { x = 100, y = 100 },
		number = 0x00FF00
	})

	hud_data.fuel_level = player:hud_add({
		hud_elem_type = "text",
		position = HUD_POSITION,
		offset = OFFSET_LEVEL,
		text = "",
		alignment = HUD_ALIGNMENT,
		scale = { x = 100, y = 100 },
		number = 0x00FF00
	})

	hud_data.status_message = player:hud_add({
		hud_elem_type = "text",
		position = HUD_POSITION,
		offset = OFFSET_WARNING,
		text = "",
		alignment = HUD_ALIGNMENT,
		scale = { x = 100, y = 100 },
		number = 0xFF0000
	})

end

local remove_hud = function(player)
	local playername = player:get_player_name()
	local hud_data = hud[playername]

	player:hud_remove(hud_data.fuel_bg)
	player:hud_remove(hud_data.fuel_fg)
	player:hud_remove(hud_data.fuel_label)
	player:hud_remove(hud_data.fuel_level)
	player:hud_remove(hud_data.status_message)

	hud[playername] = nil
end

local get_color = function(r,g,b)
	return b + (g * 256) + (r * 256 * 256)
end

local update_hud = function(player, has_fuel, is_running, armor_list)
	local playername = player:get_player_name()
	local hud_data = hud[playername]

	if not hud_data then
		return
	end

    if is_running then
        player:hud_change(hud_data.status_message, "text", "Jetpack active!")
    elseif not has_fuel then
		player:hud_change(hud_data.status_message, "text", "Jetpack is out of fuel!")
	else
		player:hud_change(hud_data.status_message, "text", "")
	end

	local max_wear = 0
	for _,item in pairs(armor_list) do
		if item:get_name() and string.find(item:get_name(), "ctg_jetpack:jetpack_copper") then
			max_wear = math.max(max_wear, item:get_wear())
		elseif item:get_name() and string.find(item:get_name(), "ctg_jetpack:jetpack_iron") then
			max_wear = math.max(max_wear, item:get_wear())
		elseif item:get_name() and string.find(item:get_name(), "ctg_jetpack:jetpack_titanium") then
			max_wear = math.max(max_wear, item:get_wear())
		end
	end

	local factor_full = 1 - (max_wear / 60100)

	player:hud_change(hud_data.fuel_level, "text", math.floor(factor_full * 1000) * 0.1 .. "%")
	player:hud_change(hud_data.fuel_fg, "scale", { x = factor_full * -7, y = 1 })

	local color

	if factor_full > 0.8 then
		-- green
		color = get_color(0,255,0)
		player:hud_change(hud_data.fuel_fg, "text", "jetpack_fuel_levels_fg_green.png")

    elseif factor_full > 0.4 then
        -- blue
        color = get_color(0,180,255)
		player:hud_change(hud_data.fuel_fg, "text", "jetpack_fuel_levels_fg_blue.png")

	elseif factor_full > 0.1 then
		-- yellow
		color = get_color(255,255,40)
		player:hud_change(hud_data.fuel_fg, "text", "jetpack_fuel_levels_fg_yellow.png")

	else
		-- red
		color = get_color(255,20,20)
		player:hud_change(hud_data.fuel_fg, "text", "jetpack_fuel_levels_fg_red.png")

	end

	player:hud_change(hud_data.fuel_label, "number", color)
	player:hud_change(hud_data.fuel_level, "number", color)

end

minetest.register_on_leaveplayer(function(player)
	-- remove stale hud data
	local playername = player:get_player_name()
	hud[playername] = nil
end)

ctg_jetpack.set_player_wearing = function(player, has_jetpack, has_fuel, is_active, armor_list, armor_inv)
	local playername = player:get_player_name()
	local hud_data = hud[playername]

    local has_helmet = armor_inv and (armor_inv:contains_item("armor", "spacesuit:helmet_base") 
                                    or armor_inv:contains_item("armor", "spacesuit:helmet"))

	if hud_data and has_jetpack and has_helmet then
		-- player wears it
		update_hud(player, has_fuel, is_active, armor_list)

	elseif hud_data and not has_jetpack then
		-- player stopped wearing
		remove_hud(player)

    elseif hud_data and not has_helmet then
		-- player stopped wearing
		remove_hud(player)

	elseif not hud_data and has_jetpack and has_helmet then
		-- player started wearing
		setup_hud(player)
		minetest.after(0.1, function()
			update_hud(player, has_fuel, is_active, armor_list)
		end)

	end
end