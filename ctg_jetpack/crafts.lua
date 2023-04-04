local S = minetest.get_translator(minetest.get_current_modname())

if true then
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
  minetest.register_craft({
    output = "ctg_jetpack:jetpack_fuel_rocket 12",
    recipe = {
      {"",i,""},
      {c, t, c},
      {c, p, c}
    },
  })
  minetest.register_craft({
    output = "ctg_jetpack:jetpack_fuel_rocket 16",
    recipe = {
      {"",i,""},
      {f, f, f},
      {f, p, f}
    },
  })
  minetest.register_craft({
    output = "ctg_jetpack:jetpack_fuel_rocket 4",
    recipe = {
      {d, i, d},
      {d, t, d},
      {d, p, d}
    },
  })
  minetest.register_craft({
    output = "ctg_jetpack:jetpack_fuel_rocket 5",
    recipe = {
      {d, i, d},
      {s, s, s},
      {d, p, d}
    },
  })

  minetest.register_craft({
    output = "ctg_jetpack:jetpack_fuel_hydrogen 4",
    recipe = {
      {d, w, d},
      {p, b, p},
      {d, s, d}
    },
  })
  minetest.register_craft({
    output = "ctg_jetpack:jetpack_fuel_hydrogen 5",
    recipe = {
      {"", w, ""},
      {p,  b,  p},
      {f,  r,  f}
    },
  })
end


minetest.register_craft({
  output = "ctg_jetpack:jetpack_copper",
  type = "shapeless",
  recipe = { "default:coal_lump", "group:food_water", "ctg_jetpack:jetpack_copper"},
})

minetest.register_craft({
  output = "ctg_jetpack:jetpack_iron",
  type = "shapeless",
  recipe = {"ctg_jetpack:jetpack_fuel_rocket","ctg_jetpack:jetpack_iron"},
})

minetest.register_craft({
  output = "ctg_jetpack:jetpack_bronze",
  type = "shapeless",
  recipe = {"ctg_jetpack:jetpack_fuel_rocket","ctg_jetpack:jetpack_bronze"},
})

minetest.register_craft({
  output = "ctg_jetpack:jetpack_titanium",
  type = "shapeless",
  recipe = {"ctg_jetpack:jetpack_fuel_hydrogen","ctg_jetpack:jetpack_titanium"}
})


if true then
  local t = "ctg_world:titanium_ingot"
  local m = "default:copper_ingot"
  local z = "default:bronze_ingot"
  local s = "default:steel_ingot"
  local b = "vessels:steel_bottle"
  local ic = "basic_materials:ic"

  minetest.register_craft({
    output = "ctg_jetpack:jetpack_copper",
    recipe = {
      {m, ic, m},
      {m, b,  m},
      {m, "", m},
    },
  })

  minetest.register_craft({
    output = "ctg_jetpack:jetpack_bronze",
    recipe = {
      {z, ic, z},
      {z, b,  z},
      {z, "", z},
    },
  })

  minetest.register_craft({
    output = "ctg_jetpack:jetpack_iron",
    recipe = {
      {s, ic, s},
      {s, b,  s},
      {s, "", s},
    },
  })

  minetest.register_craft({
    output = "ctg_jetpack:jetpack_titanium",
    recipe = {
      {t, ic, t},
      {t, b,  t},
      {t, "", t},
    },
  })
  
  local sp = "technic:solar_panel"
  local bt = "technic:battery"
  local cs = "basic_materials:copper_strip"
  local sw = "technic:doped_silicon_wafer"

  minetest.register_craft({
    output = "ctg_jetpack:solar_helmet",
    recipe = {
      {sp, cs, sp},
      {bt, sw, bt},
      {sp, cs, sp},
    },
  })
end

if minetest.get_modpath("unified_inventory") then
	unified_inventory.register_craft_type("refueling", {
		description = "Refueling",
		icon = "ctg_jetpack_iron_item.png",
		width = 1,
		height = 1,
	})
	unified_inventory.register_craft({
		type = "refueling",
		output = "ctg_jetpack:jetpack_titanium",
		items = {"ctg_jetpack:jetpack_fuel_hydrogen"},
		width = 0,
	})
	unified_inventory.register_craft({
		type = "refueling",
		output = "ctg_jetpack:jetpack_iron",
		items = {"ctg_jetpack:jetpack_fuel_rocket"},
		width = 0,
	})
  unified_inventory.register_craft({
    type = "refueling",
    output = "ctg_jetpack:jetpack_bronze",
    items = {"ctg_jetpack:jetpack_fuel_rocket"},
    width = 0,
	})
  unified_inventory.register_craft({
    type = "refueling",
    output = "ctg_jetpack:jetpack_copper",
    items = {"default:coal_lump", "x_farming:bottle_water"},
    width = 0,
	})
end
