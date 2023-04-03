local S = minetest.get_translator(minetest.get_current_modname())

if true then
  local i = "default:steel_ingot"
  local s = "default:string"
	local l = "group:wool"
	if minetest.get_modpath("mcl_mobitems") then
		s = "mcl_mobitems:string"
		l = "mcl_mobitems:leather"
	end
  if minetest.get_modpath("mcl_core") then
    i = "mcl_core:iron_ingot"
  end
  local f = "ctg_jetpack:jetpack_fuel"
	minetest.register_craft({
		output = "ctg_jetpack:jetpack",
		recipe = {
			{l, f, l},
			{i, s, i},
			{i, l, i},
		},
	})
end

if true then
  local c = "default:coal_lump"
  if minetest.get_modpath("mcl_core") then
    c = "mcl_core:coal_lump"
  end

	local s = "default:coal_lump"
  if minetest.get_modpath("mcl_mobitems") then
    s = "mcl_mobitems:slimeball"
  elseif minetest.get_modpath("tnt") then
		s = "tnt:gunpowder"
	end

  minetest.register_craft({
    output = "ctg_jetpack:jetpack_fuel 8",
    recipe = {
      {"",s,""},
      {c, c, c},
      {c, c, c}
    },
  })
  if minetest.get_modpath("mcl_core") then
    c = "mcl_core:charcoal_lump"
    minetest.register_craft({
      output = "ctg_jetpack:jetpack_fuel 8",
      recipe = {
        {s,"", s},
        {c, c, c},
        {c, c, c}
      },
    })
  end
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
end
