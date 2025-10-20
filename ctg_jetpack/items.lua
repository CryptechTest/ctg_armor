local S = core.get_translator(core.get_current_modname())

core.register_craftitem("ctg_jetpack:jetpack_fuel_rocket", {
    description = S("Jetpack Fuel"),
    _tt_help = S("Used for basic jetpacks"),
    _doc_items_longdesc = S("Fuel for a jetpack."),
    -- _doc_items_usagehelp = how_to_throw,
    inventory_image = "ctg_jetpack_fuel.png",
    stack_max = 16,
    groups = {
        craftitem = 1
    }
})

core.register_craftitem("ctg_jetpack:jetpack_fuel_hydrogen", {
    description = S("Hydrogen Jetpack Fuel"),
    _tt_help = S("Used for advanced jetpacks"),
    _doc_items_longdesc = S("Fuel for a jetpack."),
    -- _doc_items_usagehelp = how_to_throw,
    inventory_image = "ctg_jetpack_fuel_hydrogen.png",
    stack_max = 16,
    groups = {
        craftitem = 1
    }
})
