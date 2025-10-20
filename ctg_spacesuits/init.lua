local S = core.get_translator(core.get_current_modname())

ctg_spacesuit = {}

-- load files
local default_path = core.get_modpath("ctg_spacesuit")

dofile(default_path .. DIR_DELIM .. "gold.lua")
dofile(default_path .. DIR_DELIM .. "titanium.lua")

dofile(default_path .. DIR_DELIM .. "crafts.lua")

-- =========================================================
-- =========================================================

local function give_or_drop_item(player, itemstack)
    local inv = core.get_inventory({
        type = "player",
        name = player:get_player_name()
    })
    local remaining = inv:add_item("main", itemstack)
    core.add_item(player:get_pos(), remaining)
end

-- allow player to use an air bottle to fill their suit
local function refill_player_suit(itemstack, player, pointed_thing)
    local name, invs = armor:get_valid_player(player, "[refill_spacesuit]")
    if not name then
        return
    end
    local wear_cut_off = 2500
    local take_bottle = false
    for i, item in ipairs(invs:get_list("armor")) do
        if item and item:get_name() ~= "" then
            if item:get_name() == "spacesuit:helmet_base" or item:get_name() == "spacesuit:chestplate_base" or
                item:get_name() == "spacesuit:pants_base" or item:get_name() == "spacesuit:boots_base" then
                if item:get_wear() > wear_cut_off then
                    local max_refill = math.min(item:get_wear() + wear_cut_off * 2, 65535)
                    armor:damage(player, i, item, -max_refill)
                    take_bottle = true
                end
            elseif item:get_name() == "ctg_spacesuit:helmet_gold" or item:get_name() == "ctg_spacesuit:chestplate_gold" or
                item:get_name() == "ctg_spacesuit:pants_gold" or item:get_name() == "ctg_spacesuit:boots_gold" then
                if item:get_wear() > wear_cut_off then
                    local max_refill = math.min(item:get_wear() + wear_cut_off * 2, 65535)
                    armor:damage(player, i, item, -max_refill)
                    take_bottle = true
                end
            elseif item:get_name() == "ctg_spacesuit:helmet_titanium" or item:get_name() == "ctg_spacesuit:chestplate_titanium" or
                item:get_name() == "ctg_spacesuit:pants_titanium" or item:get_name() == "ctg_spacesuit:boots_titanium" then
                if item:get_wear() > wear_cut_off then
                    local max_refill = math.min(item:get_wear() + wear_cut_off * 2, 65535)
                    armor:damage(player, i, item, -max_refill)
                    take_bottle = true
                end
            end
        end
    end
    if take_bottle then
        itemstack:set_count(itemstack:get_count() - 1)
        give_or_drop_item(player, "vessels:steel_bottle")
        -- update hud
        if core.get_modpath("ctg_jetpack") then
            ctg_jetpack.set_player_jetpack_hud(player)
        end
        -- play sound
        minetest.sound_play("ctg_spacesuit_fill", {
            pos = player:get_pos(),
            pitch = 1.7,
            gain = 0.405,
            max_hear_distance = 9
        })
    end
    return itemstack
end

if core.get_modpath("spacesuit") then
    -- refill spacesuit from air bottle
    core.override_item("vacuum:air_bottle", {
        on_secondary_use = refill_player_suit,
        on_place = refill_player_suit
    })
end
