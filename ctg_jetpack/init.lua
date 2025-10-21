local S = core.get_translator(core.get_current_modname())

ctg_jetpack = {}
ctg_jetpack.hud = {}

ctg_jetpack.move_speed = 25
ctg_jetpack.max_use_time = 30 -- default 30 seconds

ctg_jetpack.max_use_time_copper = 70
ctg_jetpack.max_use_time_iron = 90
ctg_jetpack.max_use_time_bronze = 110
ctg_jetpack.max_use_time_titanium = 150

-- load files
local default_path = core.get_modpath("ctg_jetpack")

dofile(default_path .. DIR_DELIM .. "entities.lua")
dofile(default_path .. DIR_DELIM .. "items.lua")
dofile(default_path .. DIR_DELIM .. "crafts.lua")
dofile(default_path .. DIR_DELIM .. "hud.lua")

-- insert new element into 3d_armor. must do this.
if core.global_exists("armor") and armor.elements then
    table.insert(armor.elements, "jetpack")
    table.insert(armor.elements, "module")
end

-- register module addons
dofile(default_path .. DIR_DELIM .. "solar_helmet.lua")

-- =========================================================

local function firstToUpper(str)
    return (str:gsub("^%l", string.upper))
end

local function get_nearby_jetpack(player)
    if not player then
        return
    end
    local pos = player:get_pos()
    for i, obj in ipairs(core.get_objects_inside_radius(pos, 2)) do
        if (obj ~= player) then
            local parachute = obj
            if (parachute ~= nil) then
                local ent = parachute:get_luaentity()
                if (ent and ent._jetpack ~= nil and
                    ((ent._driver and ent._driver:get_player_name() == player:get_player_name()) or
                        not ent.object:get_attach())) then
                    -- core.log("parachute has driver nearby")
                    ent.object:set_properties({
                        physical = false
                    })
                    ctg_jetpack.detach_object(ent, true)
                    return true
                end
            end
        end
    end
    return false
end

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

-- allow player to use a hydrogen bottle or rocket fuel to fill their jetpack
local function refill_player_jetpack(itemstack, player, pointed_thing)
    local name, invs = armor:get_valid_player(player, "[jetpack]")
    if not name then
        return core.item_place(itemstack, player, pointed_thing)
    end
    local take_bottle = false
    local wear_cut_off = 2500
    local wear = 0
    local jetpack = nil
    for i, item in ipairs(invs:get_list("armor")) do
        if not item:is_empty() then
            local name = item:get_name()
            local jp = player:get_armor_groups(name, "jetpack")
            local ig = core.get_item_group(name, "armor_jetpack")
            if jp ~= nil and ig ~= nil and ig >= 9 then
                jetpack = item
            end
        end
        if item and item:get_name() ~= "" then
            if itemstack:get_name() == "ctg_machines:hydrogen_bottle" then
                wear_cut_off = 65535 * 0.010
                if item:get_name() == "ctg_jetpack:jetpack_titanium" then
                    if item:get_wear() > wear_cut_off then
                        local max_refill = math.min((item:get_wear() * 2.671) + 1000, 65535)
                        armor:damage(player, i, item, -max_refill)
                        take_bottle = true
                        wear = item:get_wear();
                    end
                end
            elseif itemstack:get_name() == "ctg_jetpack:jetpack_fuel_hydrogen" then
                wear_cut_off = 65535 * 0.051
                if item:get_name() == "ctg_jetpack:jetpack_titanium" then
                    if item:get_wear() > wear_cut_off then
                        local max_refill = math.max((item:get_wear() * 0.92), 65535)
                        armor:damage(player, i, item, -max_refill)
                        take_bottle = true
                        wear = item:get_wear();
                    end
                end
            elseif itemstack:get_name() == "ctg_jetpack:jetpack_fuel_rocket" then
                wear_cut_off = 65535 * 0.051
                if item:get_name() == "ctg_jetpack:jetpack_iron" then
                    if item:get_wear() > wear_cut_off then
                        local max_refill = math.max(item:get_wear(), 65535)
                        armor:damage(player, i, item, -max_refill)
                        take_bottle = true
                        wear = item:get_wear();
                    end
                elseif item:get_name() == "ctg_jetpack:jetpack_bronze" then
                    if item:get_wear() > wear_cut_off then
                        local max_refill = math.max(item:get_wear(), 65535)
                        armor:damage(player, i, item, -max_refill)
                        take_bottle = true
                        wear = item:get_wear();
                    end
                elseif item:get_name() == "ctg_jetpack:jetpack_copper" then
                    if item:get_wear() > wear_cut_off then
                        local max_refill = math.max(item:get_wear(), 65535)
                        armor:damage(player, i, item, -max_refill)
                        take_bottle = true
                        wear = item:get_wear();
                    end
                end
            end
            if take_bottle then
                -- only repair once per found
                break;
            end
        end
    end
    if take_bottle then
        -- remove item from hand
        itemstack:set_count(itemstack:get_count() - 1)
        give_or_drop_item(player, "vessels:steel_bottle")
        -- update jetpack...
        if jetpack then
            local jp = ctg_jetpack.get_jetpack(player);
            jp._fuel = jp._fuel_max - (wear / jp._fuel_use)
            jp._itemstack = jetpack
            ctg_jetpack.update_jetpack(player, jp)
        end
        -- update hud
        ctg_jetpack.set_player_jetpack_hud(player)
        -- play sound
        if core.get_modpath("ctg_spacesuit") then
            minetest.sound_play("ctg_spacesuit_fill", {
                pos = player:get_pos(),
                pitch = 1.5,
                gain = 0.280,
                max_hear_distance = 7
            })
        end
        return itemstack
    end
    return core.item_place(itemstack, player, pointed_thing)
end

-- make explosion with protection and tnt mod check
local function boom(self, pos, radius, damage_radius)
	if minetest.get_modpath("ship_weapons") and ship_weapons then
        if ship_weapons.plasma_boom and not minetest.is_protected(pos, "") then
            ship_weapons.plasma_boom(pos, {
                radius = radius,
                damage_radius = damage_radius,
                sound = self.sounds and self.sounds.explode,
                explode_center = true,
                ignore_protection = false,
                fire = false,
            })
        elseif ship_weapons.safe_plasma_boom then
            ship_weapons.safe_plasma_boom(pos, {
                radius = radius,
                sound = self.sounds and self.sounds.explode,
                explode_center = true,
                damage_radius * 1.25,
                ignore_protection = false,
                fire = false,
            })
        end
    end
end

local on_blast_bottle = function(pos)
    core.remove_node(pos)
    local radius = 2.07
    local t = math.random(0,3) * 0.01
    core.after(t, function()
        boom({sounds = {explode = "tnt_explode"}}, pos, radius, radius)
    end)
    return nil
end

local on_dig_bottle = function(pos, oldnode, digger)
    core.remove_node(pos)
    if not digger or not digger:is_player() then
        return -- Dug by a mod. Don't drop anything
    end
    local inv = digger:get_inventory()
    inv:add_item("main", oldnode.name)
end

if core.get_modpath("ctg_machines") then
    -- refil from hydrogen bottle
    core.override_item("ctg_machines:hydrogen_bottle", {
        on_secondary_use = refill_player_jetpack,
        on_place = refill_player_jetpack,
        on_blast = on_blast_bottle,
        on_dig = on_dig_bottle
    })
    -- refill from adv rocket fuel
    core.override_item("ctg_jetpack:jetpack_fuel_hydrogen", {
        on_secondary_use = refill_player_jetpack,
        on_place = refill_player_jetpack
    })
    -- refill from rocket fuel
    core.override_item("ctg_jetpack:jetpack_fuel_rocket", {
        on_secondary_use = refill_player_jetpack,
        on_place = refill_player_jetpack
    })
end

-- =========================================================
-- =========================================================

--
--  @helmet 3d_armor:helmet_bronze
--  @img 3d_armor_inv_helmet_bronze.png
--  @grp armor_jetpack 1
--  @grp physics_speed -0.01
--  @grp physics_gravity 0.01
--  @damagegrp cracky 3
--  @damagegrp snappy 2
--  @damagegrp choppy 2
--  @damagegrp crumbly 1
--  @damagegrp level 2
function ctg_jetpack.register_jetpack(style)
    local g = ""
    if style == "copper" then
        g = 1
    elseif style == "iron" then
        g = 2
    elseif style == "bronze" then
        g = 5
    elseif style == "titanium" then
        g = 9
    end
    armor:register_armor("ctg_jetpack:jetpack_" .. style, {
        description = S(firstToUpper(style) .. " Jetpack"),
        -- _tt_help = S("About 60 seconds of use per fuel"),
        _tt_help = S("Uses fuel to fly around"),
        _doc_items_longdesc = S("Can be used to fly."),
        inventory_image = "ctg_jetpack_" .. style .. "_item.png",
        groups = {
            armor_jetpack = g,
            armor_use = 1,
            physics_gravity = -0.07,
            physics_speed = 0.1,
            metal = 1,
            not_repaired_by_anvil = 1
        },
        armor_groups = {
            armor_jetpack = g,
            fall_damage_add_percent = -0.1
        },
        damage_groups = {
            cracky = 3,
            explody = 1,
            level = 2
        },
        wear = 0,
        wear_represents = "jetpack_wear",
        on_equip = function(user, index, stack)
            if user:get_attach() ~= nil then
                return false
            end
            if stack:get_wear() > 61400 then
                return false
            end
            if stack:get_wear() >= 61400 and user then
                core.chat_send_player(user:get_player_name(), S("Your @1 is out of fuel!", description))
            end
            if get_nearby_jetpack(user) then
                -- core.log("removed old jetpack entity...")
            end
            -- core.log("equipping jetpack")
            local pos = user:get_pos()
            core.after(0.2, function(pos, style, user, stack)
                if (user:get_hp() <= 0) then
                    return
                end
                local parachute = core.add_entity(pos, "ctg_jetpack:jetpack_" .. style .. "_entity")
                local ent = parachute:get_luaentity()
                if not ent or not user then
                    return
                end
                local v = user:get_velocity()
                if not v then
                    return
                end
                v = vector.multiply(v, 0.8)
                v.y = math.max(v.y, -50)
                ctg_jetpack.attach_object(ent, user)
                ent.object:set_velocity(v)
                ent.object:set_properties({
                    physical = true
                })
                core.sound_play("sum_jetpack_open", {
                    gain = 1,
                    object = ent.object
                })
                ent._itemstack = stack
                ent._flags.ready = true
                local _, armor_inv = armor:get_valid_player(user, "[jetpack]")
                local armor_list = armor_inv:get_list("armor")
                for i, stack in pairs(armor_inv:get_list("armor")) do
                    if not stack:is_empty() then
                        local name = stack:get_name()
                        local wear = stack:get_wear()
                        if name:sub(1, 12) == "ctg_jetpack:" then
                            ctg_jetpack.mod_player_wearing(user, true, wear < 61400, true, armor_list, armor_inv)
                        end
                    end
                end
            end, pos, style, user, ItemStack(stack))

            return true
        end,
        on_unequip = function(player, index, stack)
            core.after(0.1, function(user)
                ctg_jetpack.mod_player_wearing(player, false, false, false, nil, nil)
            end, player)

            if player:get_children() then
                local parachute = player:get_children()[1]
                if (parachute ~= nil) then
                    local ent = parachute:get_luaentity()
                    if (ent and ent.object) then
                        ent.object:set_properties({
                            physical = false
                        })
                        ctg_jetpack.detach_object(ent, true)
                    end
                end
            elseif player:get_attach() then
                local parachute = player:get_attach()
                if (parachute ~= nil) then
                    local ent = parachute:get_luaentity()
                    ent.object:set_properties({
                        physical = false
                    })
                    ctg_jetpack.detach_object(ent, true)
                end
            end

            -- check nearby
            get_nearby_jetpack(player)
        end
    })
end

ctg_jetpack.register_jetpack("copper")
ctg_jetpack.register_jetpack("iron")
ctg_jetpack.register_jetpack("bronze")
ctg_jetpack.register_jetpack("titanium")
