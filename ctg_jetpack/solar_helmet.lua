local S = minetest.get_translator(minetest.get_current_modname())


armor:register_armor("ctg_jetpack:solar_helmet", {
    description = S("Jetpack Solar Addon"),
    _tt_help = S("Supplemental solar charger"),
    _doc_items_longdesc = S("Can be used to refuel."),
    inventory_image = "ctg_jetpack_solar_helmet_item.png",
    groups = { armor_module=3, physics_gravity=0.01, physics_speed=-0.02, metal=1, not_repaired_by_anvil=1},
    armor_groups = { armor_module=3 },
    damage_groups = {cracky=3, explody=1, level=2},
    on_equip = function(user, index, stack)

        return true
    end,
    on_unequip = function(player, index, stack)
        local _, armor_inv = armor.get_valid_player(armor, player, "[jetpack]")
        local armor_list = armor_inv:get_list("armor")
        ctg_jetpack.set_player_wearing(player, true, true, false, armor_list, armor_inv, true)
        return true
    end
})