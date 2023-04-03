local S = minetest.get_translator(minetest.get_current_modname())

ctg_jetpack = {}

-- load files
local default_path = minetest.get_modpath("ctg_jetpack")

dofile(default_path .. DIR_DELIM .. "entities.lua")
dofile(default_path .. DIR_DELIM .. "items.lua")
dofile(default_path .. DIR_DELIM .. "crafts.lua")


-- insert new element into 3d_armor
if minetest.global_exists("armor") and armor.elements then
	table.insert(armor.elements, "jetpack")
end


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
	armor:register_armor("ctg_jetpack:jetpack_" .. style, {
		description = S("Jetpack"),
		--_tt_help = S("About 60 seconds of use per fuel"),
		_doc_items_longdesc = S("Can be used to fly."),
		inventory_image = "ctg_jetpack_"..style.."_item.png",
		groups = {armor_jetpack=1, armor_use=1, physics_gravity=-0.05},
		--armor_groups = {},
		damage_groups = {cracky=3, snappy=2, choppy=2, crumbly=1, level=2},
		on_equip = function(user, index, stack)		
			if user:get_attach() ~= nil then return false end
			if stack:get_wear() >= 65534 then return false end
			local pos = user:get_pos()
			local parachute = minetest.add_entity(pos, "ctg_jetpack:jetpack_"..style.."_entity")
			local ent = parachute:get_luaentity()
			-- if ent then ent._itemstack = itemstack end
			minetest.after(0.1, function(ent, user, stack)
				if not ent or not user then return end
				local v = user:get_velocity()
				v = vector.multiply(v, 0.8)
				v.y = math.max(v.y, -50)
				sum_jetpack.attach_object(ent, user)
				user:set_attach(ent.object)
				ent.object:set_velocity(v)
				ent.object:set_properties({
						physical = true
					})
				minetest.sound_play("sum_jetpack_open", {
					gain = 1,
					object = ent.object,
				})
				ent._itemstcack = stack
				ent._flags.ready = true
			end, ent, user, ItemStack(stack))

			return true
		end,
		on_unequip = function(player, index, stack)
			if player:get_children() then
				local parachute = player:get_children()[1]
				if (parachute ~= nil) then
					local ent = parachute:get_luaentity()
					ctg_jetpack.detach_object(ent, false)
				end
			end
			if player:get_attach() then
				parachute = player:get_attach()
				if (parachute ~= nil) then
					local ent = parachute:get_luaentity()
					ctg_jetpack.detach_object(ent, false)
					return true
				end
			end
			
			local pos = player:get_pos()
			for i,obj in ipairs(minetest.get_objects_inside_radius(pos, 1)) do
				if (obj ~= player) then
					parachute = obj
					if (parachute ~= nil) then
						local ent = parachute:get_luaentity()
						ctg_jetpack.detach_object(ent, false)
						return true
					end
				end
			end
		end
	})
end

ctg_jetpack.register_jetpack("copper")
ctg_jetpack.register_jetpack("iron")
ctg_jetpack.register_jetpack("titanium")

local c = "copper"
local i = "iron"
local t = "titanium"
local m = "default:copper_ingot"
local s = "default:steel_ingot"
local b = "vessels:steel_bottle"
minetest.register_craft({
	output = "ctg_jetpack:jetpack_copper",
	recipe = {
		{m, m, m},
		{m, b, m},
		{m, "", m},
	},
})

minetest.register_craft({
	output = "ctg_jetpack:jetpack_iron",
	recipe = {
		{s, s, s},
		{s, b, s},
		{s, "", s},
	},
})
