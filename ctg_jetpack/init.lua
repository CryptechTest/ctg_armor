local S = minetest.get_translator(minetest.get_current_modname())

ctg_jetpack = {}

-- load files
local default_path = minetest.get_modpath("ctg_jetpack")

dofile(default_path .. DIR_DELIM .. "entities.lua")
dofile(default_path .. DIR_DELIM .. "items.lua")
dofile(default_path .. DIR_DELIM .. "crafts.lua")
dofile(default_path .. DIR_DELIM .. "hud.lua")

-- insert new element into 3d_armor. must do this.
if minetest.global_exists("armor") and armor.elements then
    table.insert(armor.elements, "jetpack")
    table.insert(armor.elements, "module")
end

-- register module addons
dofile(default_path .. DIR_DELIM .. "solar_helmet.lua")

-- =========================================================

function firstToUpper(str)
    return (str:gsub("^%l", string.upper))
end

local function get_nearby_jetpack(player)
    if not player then
        return
    end
    local pos = player:get_pos()
    for i, obj in ipairs(minetest.get_objects_inside_radius(pos, 2)) do
        if (obj ~= player) then
            local parachute = obj
            if (parachute ~= nil) then
                local ent = parachute:get_luaentity()
                if (ent and ent._jetpack ~= nil and
                    ((ent._driver and ent._driver:get_player_name() == player:get_player_name()) or
                        not ent.object:get_attach())) then
                    -- minetest.log("parachute has driver nearby")
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
            if stack:get_wear() > 60100 then
                return false
            end
            if stack:get_wear() >= 60100 and user then
                minetest.chat_send_player(user:get_player_name(), S("Your @1 is out of fuel!", description))
            end
            if get_nearby_jetpack(user) then
                -- minetest.log("removed old jetpack entity...")
            end
            -- minetest.log("equipping jetpack")
            local pos = user:get_pos()
            minetest.after(0.2, function(pos, style, user, stack)
                if (user:get_hp() <= 0) then
                    return
                end
                local parachute = minetest.add_entity(pos, "ctg_jetpack:jetpack_" .. style .. "_entity")
                local ent = parachute:get_luaentity()
                if not ent or not user then
                    return
                end
                local v = user:get_velocity()
                v = vector.multiply(v, 0.8)
                v.y = math.max(v.y, -50)
                ctg_jetpack.attach_object(ent, user)
                ent.object:set_velocity(v)
                ent.object:set_properties({
                    physical = true
                })
                minetest.sound_play("sum_jetpack_open", {
                    gain = 1,
                    object = ent.object
                })
                ent._itemstcack = stack
                ent._flags.ready = true
                local _, armor_inv = armor.get_valid_player(armor, user, "[jetpack]")
                local armor_list = armor_inv:get_list("armor")
                for i, stack in pairs(armor_inv:get_list("armor")) do
                    if not stack:is_empty() then
                        local name = stack:get_name()
                        local wear = stack:get_wear()
                        if name:sub(1, 12) == "ctg_jetpack:" then
                            ctg_jetpack.set_player_wearing(user, true, wear < 60100, false, armor_list, armor_inv)
                        end
                    end
                end
            end, pos, style, user, ItemStack(stack))

            return true
        end,
        on_unequip = function(player, index, stack)
            minetest.after(0.1, function(user)
                ctg_jetpack.set_player_wearing(player, false, false, false, nil, nil)
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
