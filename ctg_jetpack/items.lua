local S = minetest.get_translator(minetest.get_current_modname())


minetest.register_craftitem("ctg_jetpack:jetpack_fuel_steam", {
	description = S("Jetpack Fuel"),
	_tt_help = S("Used in crafting"),
	_doc_items_longdesc = S("Fuel for a jetpack."),
	-- _doc_items_usagehelp = how_to_throw,
	inventory_image = "ctg_jetpack_fuel.png",
	stack_max = 16,
	groups = { craftitem=1, },
})

minetest.register_craftitem("ctg_jetpack:jetpack_fuel_rocket", {
	description = S("Jetpack Fuel"),
	_tt_help = S("Used in crafting"),
	_doc_items_longdesc = S("Fuel for a jetpack."),
	-- _doc_items_usagehelp = how_to_throw,
	inventory_image = "ctg_jetpack_fuel.png",
	stack_max = 16,
	groups = { craftitem=1, },
})

minetest.register_craftitem("ctg_jetpack:jetpack_fuel_hydrogen", {
	description = S("Jetpack Fuel"),
	_tt_help = S("Used in crafting"),
	_doc_items_longdesc = S("Fuel for a jetpack."),
	-- _doc_items_usagehelp = how_to_throw,
	inventory_image = "ctg_jetpack_fuel.png",
	stack_max = 16,
	groups = { craftitem=1, },
})

