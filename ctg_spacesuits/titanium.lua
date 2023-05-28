-- titanium spacesuit
armor:register_armor("ctg_spacesuit:helmet_titanium", {
    description = "Spacesuit Helmet Titanium",
    inventory_image = "ctg_spacesuit_inv_helmet_titanium.png",
    groups = {
        armor_head = 5,
        armor_heal = 1,
        armor_use = spacesuit.armor_use - 10,
        not_repaired_by_anvil = 1,
        physics_speed = -0.02,
        physics_gravity = 0.02,
        physics_jump = -0.002
    },
    armor_groups = {
        fleshy = 15,
        radiation = 10
    },
    damage_groups = {
        cracky = 2,
        snappy = 1,
        choppy = 1,
        level = 3
    },
    wear = 0,
    wear_represents = "spacesuit_wear"
})

armor:register_armor("ctg_spacesuit:chestplate_titanium", {
    description = "Spacesuit Chestplate Titanium",
    inventory_image = "ctg_spacesuit_inv_chestplate_titanium.png",
    groups = {
        armor_torso = 8,
        armor_heal = 1,
        armor_use = spacesuit.armor_use - 10,
        not_repaired_by_anvil = 1,
        physics_speed = -0.05,
        physics_gravity = 0.03,
        physics_jump = -0.005
    },
    armor_groups = {
        fleshy = 25,
        radiation = 15
    },
    damage_groups = {
        cracky = 2,
        snappy = 1,
        choppy = 1,
        level = 3
    },
    wear = 0,
    wear_represents = "spacesuit_wear"
})

armor:register_armor("ctg_spacesuit:pants_titanium", {
    description = "Spacesuit Pants Titanium",
    inventory_image = "ctg_spacesuit_inv_pants_titanium.png",
    groups = {
        armor_legs = 7,
        armor_heal = 1,
        armor_use = spacesuit.armor_use - 10,
        not_repaired_by_anvil = 1,
        physics_speed = -0.04,
        physics_gravity = 0.04,
        physics_jump = -0.005
    },
    armor_groups = {
        fleshy = 20,
        radiation = 10
    },
    damage_groups = {
        cracky = 2,
        snappy = 1,
        choppy = 1,
        level = 3
    },
    wear = 0,
    wear_represents = "spacesuit_wear"
})

armor:register_armor("ctg_spacesuit:boots_titanium", {
    description = "Spacesuit Boots Titanium",
    inventory_image = "ctg_spacesuit_inv_boots_titanium.png",
    groups = {
        armor_feet = 4,
        armor_heal = 1,
        armor_use = spacesuit.armor_use - 10,
        not_repaired_by_anvil = 1,
        physics_speed = -0.02,
        physics_gravity = 0.02,
        physics_jump = -0.003
    },
    armor_groups = {
        fleshy = 15,
        radiation = 5
    },
    damage_groups = {
        cracky = 2,
        snappy = 1,
        choppy = 1,
        level = 3
    },
    wear = 0,
    wear_represents = "spacesuit_wear"
})
