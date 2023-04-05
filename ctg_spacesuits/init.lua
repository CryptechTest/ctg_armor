local S = minetest.get_translator(minetest.get_current_modname())

ctg_spacesuit = {}

-- load files
local default_path = minetest.get_modpath("ctg_spacesuit")

dofile(default_path .. DIR_DELIM .. "gold.lua")
dofile(default_path .. DIR_DELIM .. "titanium.lua")

dofile(default_path .. DIR_DELIM .. "crafts.lua")



