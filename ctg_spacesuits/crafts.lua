
-- recipe registration
local function register_recipe(_type, ingot, block, soft)
    local mod = "ctg_spacesuit"
    core.register_craft({
        output = mod .. ":helmet_" .. _type,
        recipe = {{ingot, "default:glass", ingot},
                  {ingot, "default:glass", ingot},
                  {soft, block, soft}}
    })
    core.register_craft({
        output = mod .. ":chestplate_" .. _type,
        recipe = {{ingot, "default:mese", ingot},
                  {ingot, soft, ingot},
                  {ingot, soft, ingot}}
    })
    core.register_craft({
        output = mod .. ":pants_" .. _type,
        recipe = {{ingot, soft, ingot},
                  {ingot, soft, ingot},
                  {ingot, soft, ingot}}
    })
    core.register_craft({
        output = mod .. ":boots_" .. _type,
        recipe = {{soft, "", soft},
                  {ingot, soft, ingot},
                  {ingot, soft, ingot}}
    })
end

-- Wool Craftings
if core.get_modpath("wool") then
    -- gold spacesuit
    register_recipe("gold", "default:gold_ingot", "default:goldblock", "wool:yellow")
    -- titanium spacesuit
    register_recipe("titanium", "ctg_world:titanium_ingot", "ctg_world:titanium_block", "wool:cyan")
end

-- Cotton Craftings
if core.get_modpath("x_farming") then
    -- gold spacesuit
    register_recipe("gold", "default:gold_ingot", "default:goldblock", "x_farming:pillow_yellow")
    -- titanium spacesuit
    register_recipe("titanium", "ctg_world:titanium_ingot", "ctg_world:titanium_block", "x_farming:pillow_blue")
    register_recipe("titanium", "ctg_world:titanium_ingot", "ctg_world:titanium_block", "x_farming:pillow_cyan")
end

-- spacesuit repair recipes
local function repair_recipe(partname)
    core.register_craft({
        type = "shapeless",
        output = partname,
        recipe = {"vacuum:air_bottle", partname},
        replacements = {{"vacuum:air_bottle", "vessels:steel_bottle"}}
    })
end

if core.get_modpath("vacuum") then
    repair_recipe("ctg_spacesuit:helmet_gold")
    repair_recipe("ctg_spacesuit:chestplate_gold")
    repair_recipe("ctg_spacesuit:pants_gold")
    repair_recipe("ctg_spacesuit:boots_gold")

    repair_recipe("ctg_spacesuit:helmet_titanium")
    repair_recipe("ctg_spacesuit:chestplate_titanium")
    repair_recipe("ctg_spacesuit:pants_titanium")
    repair_recipe("ctg_spacesuit:boots_titanium")

    if core.get_modpath("unified_inventory") then
        unified_inventory.register_craft({
            type = "filling",
            output = "ctg_spacesuit:helmet_gold 1 1",
            items = {"ctg_spacesuit:helmet_gold 1 60000"},
            width = 0
        })
        unified_inventory.register_craft({
            type = "filling",
            output = "ctg_spacesuit:chestplate_gold 1 1",
            items = {"ctg_spacesuit:chestplate_gold 1 60000"},
            width = 0
        })
        unified_inventory.register_craft({
            type = "filling",
            output = "ctg_spacesuit:pants_gold 1 1",
            items = {"ctg_spacesuit:pants_gold 1 60000"},
            width = 0
        })
        unified_inventory.register_craft({
            type = "filling",
            output = "ctg_spacesuit:boots_gold 1 1",
            items = {"ctg_spacesuit:boots_gold 1 60000"},
            width = 0
        })

        unified_inventory.register_craft({
            type = "filling",
            output = "ctg_spacesuit:helmet_titanium 1 1",
            items = {"ctg_spacesuit:helmet_titanium 1 60000"},
            width = 0
        })
        unified_inventory.register_craft({
            type = "filling",
            output = "ctg_spacesuit:chestplate_titanium 1 1",
            items = {"ctg_spacesuit:chestplate_titanium 1 60000"},
            width = 0
        })
        unified_inventory.register_craft({
            type = "filling",
            output = "ctg_spacesuit:pants_titanium 1 1",
            items = {"ctg_spacesuit:pants_titanium 1 60000"},
            width = 0
        })
        unified_inventory.register_craft({
            type = "filling",
            output = "ctg_spacesuit:boots_titanium 1 1",
            items = {"ctg_spacesuit:boots_titanium 1 60000"},
            width = 0
        })
    end
end
