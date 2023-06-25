
-- Wool Craftings

if minetest.get_modpath("wool") then

	minetest.register_craft({
		output = "ctg_spacesuit:helmet_gold",
		recipe = {
			{"default:gold_ingot", "default:glass", "default:gold_ingot"},
			{"default:gold_ingot", "default:glass", "default:gold_ingot"},
			{"group:wool", "default:goldblock", "group:wool"},
		},
	})

	minetest.register_craft({
		output = "ctg_spacesuit:chestplate_gold",
		recipe = {
			{"default:gold_ingot", "default:mese", "default:gold_ingot"},
			{"default:gold_ingot", "group:wool", "default:gold_ingot"},
			{"default:gold_ingot", "default:goldblock", "default:gold_ingot"}
		},
	})

	minetest.register_craft({
		output = "ctg_spacesuit:pants_gold",
		recipe = {
			{"default:gold_ingot", "group:wool", "default:gold_ingot"},
			{"default:gold_ingot", "group:wool", "default:gold_ingot"},
			{"default:gold_ingot", "group:wool", "default:gold_ingot"}
		},
	})

	minetest.register_craft({
		output = "ctg_spacesuit:boots_gold",
		recipe = {
			{"group:wool", "", "group:wool"},
			{"default:gold_ingot", "group:wool", "default:gold_ingot"},
			{"default:gold_ingot", "group:wool", "default:gold_ingot"},
		},
	})


	minetest.register_craft({
		output = "ctg_spacesuit:helmet_titanium",
		recipe = {
			{"ctg_world:titanium_ingot", "default:glass", "ctg_world:titanium_ingot"},
			{"ctg_world:titanium_ingot", "default:glass", "ctg_world:titanium_ingot"},
			{"group:wool", "ctg_world:titanium_block", "group:wool"},
		},
	})

	minetest.register_craft({
		output = "ctg_spacesuit:chestplate_titanium",
		recipe = {
			{"ctg_world:titanium_ingot", "default:mese", "ctg_world:titanium_ingot"},
			{"ctg_world:titanium_ingot", "group:wool", "ctg_world:titanium_ingot"},
			{"ctg_world:titanium_ingot", "ctg_world:titanium_block", "ctg_world:titanium_ingot"}
		},
	})

	minetest.register_craft({
		output = "ctg_spacesuit:pants_titanium",
		recipe = {
			{"ctg_world:titanium_ingot", "group:wool", "ctg_world:titanium_ingot"},
			{"ctg_world:titanium_ingot", "group:wool", "ctg_world:titanium_ingot"},
			{"ctg_world:titanium_ingot", "group:wool", "ctg_world:titanium_ingot"}
		},
	})

	minetest.register_craft({
		output = "ctg_spacesuit:boots_titanium",
		recipe = {
			{"group:wool", "", "group:wool"},
			{"ctg_world:titanium_ingot", "group:wool", "ctg_world:titanium_ingot"},
			{"ctg_world:titanium_ingot", "group:wool", "ctg_world:titanium_ingot"},
		},
	})
end

-- Cotton Craftings

if minetest.get_modpath("x_farming") then

	minetest.register_craft({
		output = "ctg_spacesuit:helmet_gold",
		recipe = {
			{"default:gold_ingot", "default:glass", "default:gold_ingot"},
			{"default:gold_ingot", "default:glass", "default:gold_ingot"},
			{"x_farming:pillow_yellow", "default:goldblock", "x_farming:pillow_yellow"},
		},
	})

	minetest.register_craft({
		output = "ctg_spacesuit:chestplate_gold",
		recipe = {
			{"default:gold_ingot", "default:mese", "default:gold_ingot"},
			{"default:gold_ingot", "x_farming:pillow_yellow", "default:gold_ingot"},
			{"default:gold_ingot", "default:goldblock", "default:gold_ingot"}
		},
	})

	minetest.register_craft({
		output = "ctg_spacesuit:pants_gold",
		recipe = {
			{"default:gold_ingot", "x_farming:pillow_yellow", "default:gold_ingot"},
			{"default:gold_ingot", "x_farming:pillow_yellow", "default:gold_ingot"},
			{"default:gold_ingot", "x_farming:pillow_yellow", "default:gold_ingot"}
		},
	})

	minetest.register_craft({
		output = "ctg_spacesuit:boots_gold",
		recipe = {
			{"x_farming:pillow_yellow", "", "x_farming:pillow_yellow"},
			{"default:gold_ingot", "x_farming:pillow_yellow", "default:gold_ingot"},
			{"default:gold_ingot", "x_farming:pillow_yellow", "default:gold_ingot"},
		},
	})


	minetest.register_craft({
		output = "ctg_spacesuit:helmet_titanium",
		recipe = {
			{"ctg_world:titanium_ingot", "default:glass", "ctg_world:titanium_ingot"},
			{"ctg_world:titanium_ingot", "default:glass", "ctg_world:titanium_ingot"},
			{"x_farming:pillow_blue", "ctg_world:titanium_block", "x_farming:pillow_blue"},
		},
	})

	minetest.register_craft({
		output = "ctg_spacesuit:chestplate_titanium",
		recipe = {
			{"ctg_world:titanium_ingot", "default:mese", "ctg_world:titanium_ingot"},
			{"ctg_world:titanium_ingot", "x_farming:pillow_blue", "ctg_world:titanium_ingot"},
			{"ctg_world:titanium_ingot", "ctg_world:titanium_block", "ctg_world:titanium_ingot"}
		},
	})

	minetest.register_craft({
		output = "ctg_spacesuit:pants_titanium",
		recipe = {
			{"ctg_world:titanium_ingot", "x_farming:pillow_blue", "ctg_world:titanium_ingot"},
			{"ctg_world:titanium_ingot", "x_farming:pillow_blue", "ctg_world:titanium_ingot"},
			{"ctg_world:titanium_ingot", "x_farming:pillow_blue", "ctg_world:titanium_ingot"}
		},
	})

	minetest.register_craft({
		output = "ctg_spacesuit:boots_titanium",
		recipe = {
			{"x_farming:pillow_blue", "", "x_farming:pillow_blue"},
			{"ctg_world:titanium_ingot", "x_farming:pillow_blue", "ctg_world:titanium_ingot"},
			{"ctg_world:titanium_ingot", "x_farming:pillow_blue", "ctg_world:titanium_ingot"},
		},
	})
end

-- spacesuit repair recipes
local function repair_recipe(partname)
	minetest.register_craft({
		type = "shapeless",
		output = partname,
		recipe = {
			"vacuum:air_bottle",
			partname
		},
		replacements = {
			{"vacuum:air_bottle", "vessels:steel_bottle"}
		}
	})
end

if minetest.get_modpath("vacuum") then
	repair_recipe("ctg_spacesuit:helmet_gold")
	repair_recipe("ctg_spacesuit:chestplate_gold")
	repair_recipe("ctg_spacesuit:pants_gold")
	repair_recipe("ctg_spacesuit:boots_gold")

	repair_recipe("ctg_spacesuit:helmet_titanium")
	repair_recipe("ctg_spacesuit:chestplate_titanium")
	repair_recipe("ctg_spacesuit:pants_titanium")
	repair_recipe("ctg_spacesuit:boots_titanium")
	
	if minetest.get_modpath("unified_inventory") then
		unified_inventory.register_craft({
			type = "filling",
			output = "ctg_spacesuit:helmet_gold 1 1",
			items = {"ctg_spacesuit:helmet_gold 1 60000"},
			width = 0,
		})
		unified_inventory.register_craft({
			type = "filling",
			output = "ctg_spacesuit:chestplate_gold 1 1",
			items = {"ctg_spacesuit:chestplate_gold 1 60000"},
			width = 0,
		})
		unified_inventory.register_craft({
			type = "filling",
			output = "ctg_spacesuit:pants_gold 1 1",
			items = {"ctg_spacesuit:pants_gold 1 60000"},
			width = 0,
		})
		unified_inventory.register_craft({
			type = "filling",
			output = "ctg_spacesuit:boots_gold 1 1",
			items = {"ctg_spacesuit:boots_gold 1 60000"},
			width = 0,
		})
		
		unified_inventory.register_craft({
			type = "filling",
			output = "ctg_spacesuit:helmet_titanium 1 1",
			items = {"ctg_spacesuit:helmet_titanium 1 60000"},
			width = 0,
		})
		unified_inventory.register_craft({
			type = "filling",
			output = "ctg_spacesuit:chestplate_titanium 1 1",
			items = {"ctg_spacesuit:chestplate_titanium 1 60000"},
			width = 0,
		})
		unified_inventory.register_craft({
			type = "filling",
			output = "ctg_spacesuit:pants_titanium 1 1",
			items = {"ctg_spacesuit:pants_titanium 1 60000"},
			width = 0,
		})
		unified_inventory.register_craft({
			type = "filling",
			output = "ctg_spacesuit:boots_titanium 1 1",
			items = {"ctg_spacesuit:boots_titanium 1 60000"},
			width = 0,
		})
	end
end