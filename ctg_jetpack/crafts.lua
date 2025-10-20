local S = core.get_translator(core.get_current_modname())

if core.get_modpath("vacuum") then
    local t = "tnt:gunpowder"
    local c = "default:coal_lump"
    local d = "technic:coal_dust"
    local f = "technic:sulfur_lump"
    local s = "technic:sulfur_dust"
    local i = "default:tin_ingot"
    local w = "group:food_water"
    local b = "vacuum:air_bottle"
    local p = "default:paper"
    local r = "ctg_machines:carbon_dust"
    local h = "ctg_machines:hydrogen_bottle"
    core.register_craft({
        output = "ctg_jetpack:jetpack_fuel_rocket 6",
        recipe = {{"", i, ""}, {c, t, c}, {c, p, c}}
    })
    core.register_craft({
        output = "ctg_jetpack:jetpack_fuel_rocket 10",
        recipe = {{"", i, ""}, {f, f, f}, {f, p, f}}
    })
    core.register_craft({
        output = "ctg_jetpack:jetpack_fuel_rocket 2",
        recipe = {{d, i, d}, {d, t, d}, {d, p, d}}
    })
    core.register_craft({
        output = "ctg_jetpack:jetpack_fuel_rocket 3",
        recipe = {{d, i, d}, {s, s, s}, {d, p, d}}
    })

    core.register_craft({
        output = "ctg_jetpack:jetpack_fuel_hydrogen 1",
        recipe = {{d, w, d}, {p, b, p}, {d, s, d}}
    })
    core.register_craft({
        output = "ctg_jetpack:jetpack_fuel_hydrogen 5",
        recipe = {{"", p, ""}, {"", h, ""}, {"", s, ""}}
    })
end

core.register_craft({
    output = "ctg_jetpack:jetpack_copper 1 1",
    type = "shapeless",
    recipe = {"default:coal_lump", "group:food_water", "ctg_jetpack:jetpack_copper 1 60000"}
})
core.register_craft({
    output = "ctg_jetpack:jetpack_copper 1 1",
    type = "shapeless",
    recipe = {"jetpack_fuel_rocket", "ctg_jetpack:jetpack_copper 1 60000"}
})

core.register_craft({
    output = "ctg_jetpack:jetpack_iron 1 1",
    type = "shapeless",
    recipe = {"ctg_jetpack:jetpack_fuel_rocket", "ctg_jetpack:jetpack_iron 1 60000"}
})

core.register_craft({
    output = "ctg_jetpack:jetpack_bronze 1 1",
    type = "shapeless",
    recipe = {"ctg_jetpack:jetpack_fuel_rocket", "ctg_jetpack:jetpack_bronze 1 60000"}
})

core.register_craft({
    output = "ctg_jetpack:jetpack_titanium 1 1",
    type = "shapeless",
    recipe = {"ctg_jetpack:jetpack_fuel_hydrogen", "ctg_jetpack:jetpack_titanium 1 60000"}
})

if true then
    local t = "ctg_world:titanium_ingot"
    local m = "default:copper_ingot"
    local z = "default:bronze_ingot"
    local s = "default:steel_ingot"
    local b = "vessels:steel_bottle"
    local ic = "basic_materials:ic"

    local jc = "ctg_jetpack:jetpack_copper"
    local jb = "ctg_jetpack:jetpack_bronze"
    local ji = "ctg_jetpack:jetpack_iron"
    local jt = "ctg_jetpack:jetpack_titanium"
    core.register_craft({
        output = jc,
        recipe = {{m, ic, m}, {m, b, m}, {m, "", m}}
    })

    core.register_craft({
        output = jb,
        recipe = {{z, ic, z}, {z, b, z}, {z, jc, z}}
    })

    core.register_craft({
        output = ji,
        recipe = {{s, ic, s}, {s, b, s}, {s, jb, s}}
    })

    core.register_craft({
        output = jt,
        recipe = {{t, ic, t}, {t, b, t}, {t, ji, t}}
    })

    local bt = "technic:battery"
    local cs = "basic_materials:copper_strip"
    local sp = "technic:solar_panel"
    local sw = "technic:doped_silicon_wafer"

    if core.get_modpath("ship_parts") then
        local sc = "ship_parts:solar_collimator"
        core.register_craft({
            output = "ctg_jetpack:solar_helmet",
            recipe = {{"", cs, ""}, {bt, sc, bt}, {"", cs, ""}}
        })
    else
        core.register_craft({
            output = "ctg_jetpack:solar_helmet",
            recipe = {{sp, cs, sp}, {bt, sw, bt}, {sp, cs, sp}}
        })
    end

    if core.get_modpath("unified_inventory") then
        unified_inventory.register_craft_type("refueling", {
            description = "Refueling",
            icon = "ctg_jetpack_iron_item.png",
            width = 2,
            height = 1
        })
        unified_inventory.register_craft({
            type = "refueling",
            output = jt,
            items = {"ctg_jetpack:jetpack_fuel_hydrogen"},
            width = 1
        })
        unified_inventory.register_craft({
            type = "refueling",
            output = ji,
            items = {"ctg_jetpack:jetpack_fuel_rocket"},
            width = 1
        })
        unified_inventory.register_craft({
            type = "refueling",
            output = jb,
            items = {"ctg_jetpack:jetpack_fuel_rocket"},
            width = 1
        })
        unified_inventory.register_craft({
            type = "refueling",
            output = jc,
            items = {"ctg_jetpack:jetpack_fuel_rocket"},
            width = 1
        })
        unified_inventory.register_craft({
            type = "refueling",
            output = jc,
            items = {"default:coal_lump", "x_farming:bottle_water"},
            width = 2
        })

    end
end

