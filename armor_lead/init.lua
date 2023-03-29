
--- Registered armors.
--
--  @topic armor


-- support for i18n
local S = armor.get_translator

--- Lead
--
--  Requires setting `armor_material_lead`.
--
--  @section lead

--if armor.materials.lead then
if true then

	armor:register_armor_group("radiation", 100)
	--- Lead Helmet
	--
	--  @helmet ctg_armor:helmet_lead
	--  @img ctg_armor_inv_helmet_lead.png
	--  @grp armor_head 1
	--  @grp armor_heal 0
	--  @grp armor_use 800
	--  @grp physics_speed -0.01
	--  @grp physica_gravity 0.01
	--  @armorgrp fleshy 10
	--  @damagegrp cracky 2
	--  @damagegrp snappy 3
	--  @damagegrp choppy 2
	--  @damagegrp crumbly 1
	--  @damagegrp level 2
	armor:register_armor(":ctg_armor:helmet_lead", {
		description = S("Lead Helmet"),
		inventory_image = "ctg_armor_inv_helmet_lead.png",
		groups = {radiation=-17, armor_radiation=-17, armor_head=1, armor_heal=0, armor_use=800,
			physics_speed=-0.06, physics_gravity=0.03, physics_jump=-0.086},
		armor_groups = {fleshy=10},
		damage_groups = {cracky=2, snappy=3, choppy=2, crumbly=1, level=2},
	})
	--- Lead Chestplate
	--
	--  @chestplate ctg_armor:chestplate_lead
	--  @img ctg_armor_inv_chestplate_lead.png
	--  @grp armor_torso 1
	--  @grp armor_heal 0
	--  @grp armor_use 800
	--  @grp physics_speed
	--  @grp physics_gravity
	--  @armorgrp fleshy
	--  @damagegrp cracky 2
	--  @damagegrp snappy 3
	--  @damagegrp choppy 2
	--  @damagegrp crumbly 1
	--  @damagegrp level 2
	armor:register_armor(":ctg_armor:chestplate_lead", {
		description = S("Lead Chestplate"),
		inventory_image = "ctg_armor_inv_chestplate_lead.png",
		groups = {radiation=-35, armor_radiation=-35, armor_torso=1, armor_heal=0, armor_use=800,
			physics_speed=-0.09, physics_gravity=0.06, physics_jump=-0.174},
		armor_groups = {fleshy=15},
		damage_groups = {cracky=2, snappy=3, choppy=2, crumbly=1, level=2},
	})
	--- Lead Leggings
	--
	--  @leggings ctg_armor:leggings_lead
	--  @img ctg_armor_inv_leggings_lead.png
	--  @grp armor_legs 1
	--  @grp armor_heal 0
	--  @grp armor_use 800
	--  @grp physics_speed -0.03
	--  @grp physics_gravity 0.03
	--  @armorgrp fleshy 15
	--  @damagegrp cracky 2
	--  @damagegrp snappy 3
	--  @damagegrp choppy 2
	--  @damagegrp crumbly 1
	--  @damagegrp level 2
	armor:register_armor(":ctg_armor:leggings_lead", {
		description = S("Lead Leggings"),
		inventory_image = "ctg_armor_inv_leggings_lead.png",
		groups = {radiation=-31, armor_radiation=-31, armor_legs=1, armor_heal=0, armor_use=800,
			physics_speed=-0.07, physics_gravity=0.05, physics_jump=-0.152},
		armor_groups = {fleshy=15},
		damage_groups = {cracky=2, snappy=3, choppy=2, crumbly=1, level=2},
	})
	--- Lead Boots
	--
	--  @boots ctg_armor:boots_lead
	--  @img ctg_armor_inv_boots_lead.png
	--  @grp armor_feet 1
	--  @grp armor_heal 0
	--  @grp armor_use 800
	--  @grp physics_speed -0.01
	--  @grp physics_gravity 0.01
	--  @armorgrp fleshy 10
	--  @damagegrp cracky 2
	--  @damagegrp snappy 3
	--  @damagegrp choppy 2
	--  @damagegrp crumbly 1
	--  @damagegrp level 2
	armor:register_armor(":ctg_armor:boots_lead", {
		description = S("Lead Boots"),
		inventory_image = "ctg_armor_inv_boots_lead.png",
		groups = {radiation=-17, armor_radiation=-17, armor_feet=1, armor_heal=0, armor_use=800,
			physics_speed=-0.06, physics_gravity=0.03, physics_jump=-0.088},
		armor_groups = {fleshy=10},
		damage_groups = {cracky=2, snappy=3, choppy=2, crumbly=1, level=2},
	})


	--- Crafting
	--
	--  @section craft

	--- Craft recipes for helmets, chestplates, leggings, boots, & shields.
	--
	--  @craft armor
	--  @usage
	--  Key:
	--  - m: material
	--    - wood:    group:wood
	--    - cactus:  default:cactus
	--    - lead:   default:lead_ingot
	--    - bronze:  default:bronze_ingot
	--    - diamond: default:diamond
	--    - gold:    default:gold_ingot
	--    - mithril: moreores:mithril_ingot
	--    - crystal: ethereal:crystal_ingot
	--    - nether:  nether:nether_ingot
	--
	--  helmet:        chestplate:    leggings:
	--  ┌───┬───┬───┐  ┌───┬───┬───┐  ┌───┬───┬───┐
	--  │ m │ m │ m │  │ m │   │ m │  │ m │ m │ m │
	--  ├───┼───┼───┤  ├───┼───┼───┤  ├───┼───┼───┤
	--  │ m │   │ m │  │ m │ m │ m │  │ m │   │ m │
	--  ├───┼───┼───┤  ├───┼───┼───┤  ├───┼───┼───┤
	--  │   │   │   │  │ m │ m │ m │  │ m │   │ m │
	--  └───┴───┴───┘  └───┴───┴───┘  └───┴───┴───┘
	--
	--  boots:         shield:
	--  ┌───┬───┬───┐  ┌───┬───┬───┐
	--  │   │   │   │  │ m │ m │ m │
	--  ├───┼───┼───┤  ├───┼───┼───┤
	--  │ m │   │ m │  │ m │ m │ m │
	--  ├───┼───┼───┤  ├───┼───┼───┤
	--  │ m │   │ m │  │   │ m │   │
	--  └───┴───┴───┘  └───┴───┴───┘

	local s = "lead"
	local m = "technic:lead_ingot"
	minetest.register_craft({
		output = "ctg_armor:helmet_"..s,
		recipe = {
			{m, m, m},
			{m, "", m},
			{"", "", ""},
		},
	})
	minetest.register_craft({
		output = "ctg_armor:chestplate_"..s,
		recipe = {
			{m, "", m},
			{m, m, m},
			{m, m, m},
		},
	})
	minetest.register_craft({
		output = "ctg_armor:leggings_"..s,
		recipe = {
			{m, m, m},
			{m, "", m},
			{m, "", m},
		},
	})
	minetest.register_craft({
		output = "ctg_armor:boots_"..s,
		recipe = {
			{m, "", m},
			{m, "", m},
		},
	})
end