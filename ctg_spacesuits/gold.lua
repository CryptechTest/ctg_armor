-- gold spacesuit
armor:register_armor("ctg_spacesuit:helmet_gold", {
    description = "Spacesuit Helmet Gold",
    inventory_image = "ctg_spacesuit_inv_helmet_gold.png",
    groups = {
        armor_head = 5,
        armor_heal = 1,
        armor_use = spacesuit.armor_use - 5,
        not_repaired_by_anvil = 1,
        physics_speed = -0.02,
        physics_gravity = 0.02,
        physics_jump = -0.02
    },
    armor_groups = {
        fleshy = 7,
        radiation = 15
    },
    damage_groups = {
        cracky = 1,
        snappy = 2,
        choppy = 2,
        level = 2
    },
    wear = 0,
    wear_represents = "spacesuit_wear"
})

armor:register_armor("ctg_spacesuit:chestplate_gold", {
    description = "Spacesuit Chestplate Gold",
    inventory_image = "ctg_spacesuit_inv_chestplate_gold.png",
    groups = {
        armor_torso = 8,
        armor_heal = 1,
        armor_use = spacesuit.armor_use - 5,
        not_repaired_by_anvil = 1,
        physics_speed = -0.05,
        physics_gravity = 0.03,
        physics_jump = -0.05
    },
    armor_groups = {
        fleshy = 16,
        radiation = 25
    },
    damage_groups = {
        cracky = 1,
        snappy = 2,
        choppy = 2,
        level = 2
    },
    wear = 0,
    wear_represents = "spacesuit_wear"
})

armor:register_armor("ctg_spacesuit:pants_gold", {
    description = "Spacesuit Pants Gold",
    inventory_image = "ctg_spacesuit_inv_pants_gold.png",
    groups = {
        armor_legs = 7,
        armor_heal = 1,
        armor_use = spacesuit.armor_use - 5,
        not_repaired_by_anvil = 1,
        physics_speed = -0.04,
        physics_gravity = 0.04,
        physics_jump = -0.05
    },
    armor_groups = {
        fleshy = 14,
        radiation = 15
    },
    damage_groups = {
        cracky = 1,
        snappy = 2,
        choppy = 2,
        level = 2
    },
    wear = 0,
    wear_represents = "spacesuit_wear"
})

armor:register_armor("ctg_spacesuit:boots_gold", {
    description = "Spacesuit Boots Gold",
    inventory_image = "ctg_spacesuit_inv_boots_gold.png",
    groups = {
        armor_feet = 4,
        armor_heal = 1,
        armor_use = spacesuit.armor_use - 5,
        not_repaired_by_anvil = 1,
        physics_speed = -0.02,
        physics_gravity = 0.02,
        physics_jump = -0.03
    },
    armor_groups = {
        fleshy = 8,
        radiation = 10
    },
    damage_groups = {
        cracky = 1,
        snappy = 2,
        choppy = 2,
        level = 2
    },
    wear = 0,
    wear_represents = "spacesuit_wear"
})
