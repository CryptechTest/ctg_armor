local S = minetest.get_translator(minetest.get_current_modname())

local jetpacks = {} -- playername -> data

local setup_jetpack = function(player, jetpack)
    local playername = player:get_player_name()
    local jetpack_data = {}
    jetpacks[playername] = jetpack_data
    jetpack_data.jetpack = jetpack
end

local is_setup_jetpack = function(player, jetpack)
    local playername = player:get_player_name()
    return jetpacks[playername] ~= nil
end

local remove_jetpack = function(player)
    local playername = player:get_player_name()
    local jetpack_data = jetpacks[playername]
    jetpacks[playername] = nil
end

local update_jetpack = function(player, jetpack)
    local playername = player:get_player_name()
    local jetpack_data = jetpacks[playername]

    if not jetpack_data then
        return
    end

    jetpack_data.jetpack = jetpack
end

-- Staticdata handling because objects may want to be reloaded
function ctg_jetpack.get_staticdata(self)
    ctg_jetpack.setup(self._style)
    local itemstack = "ctg_jetpack:jetpack_" .. self._style
    if self._itemstack then
        itemstack = self._itemstack:to_table()
    end
    local data = {
        _lastpos = self._lastpos,
        _age = self._age,
        _itemstack = itemstack
    }
    return minetest.serialize(data)
end

function ctg_jetpack.on_activate(self, staticdata, dtime_s)
    local data = minetest.deserialize(staticdata)

    minetest.after(0.01, function()
        if self._driver and self._driver:is_player() and self._itemstack == nil then
            local player = self._driver
            local _, armor_inv = armor.get_valid_player(armor, player, "[jetpack]")
            local armor_list = armor_inv:get_list("armor")
            if armor_list then
                for i, stack in pairs(armor_inv:get_list("armor")) do
                    if not stack:is_empty() then
                        local name = stack:get_name()
                        if name:sub(1, 20) == "ctg_jetpack:jetpack_" then
                            self._itemstack = ItemStack(stack)
                        end
                    end
                end
            end
        end
    end)

    if data then
        self._lastpos = data._lastpos
        self._age = data._age
        if self._itemstack == nil and data._itemstack ~= nil then
            self._itemstack = ItemStack(data._itemstack)
        end
    end
    self._sounds = {
        engine = {
            time = 0,
            handle = nil
        }
    }
    self._flags = {}
end

ctg_jetpack.set_attach = function(self)
    if not self._driver or not self.object then
        return
    end
    self.object:set_attach(self._driver, "", {
        x = 0,
        y = 0,
        z = 0
    }, {
        x = 0,
        y = 0,
        z = 0
    })
end

ctg_jetpack.attach_object = function(self, obj)
    self._driver = obj
    ctg_jetpack.set_attach(self)
    if self._driver and self.object then
        self.object:set_yaw(minetest.dir_to_yaw(self._driver:get_look_dir()))
    end

    if not is_setup_jetpack(obj, self) then
        setup_jetpack(obj, self)
    else
        update_jetpack(obj, self)
    end
end

-- make sure the player doesn't get stuck
minetest.register_on_joinplayer(function(player)
    local pos = player:get_pos()
    if (pos.y > 4000) then
        -- space join velocity fix..
        local v = player:get_velocity()
        if (v.y < 0.01) then
            v.y = 3
        else
            v.y = 1.6
        end
        v = vector.multiply(v, 2)
        if player then
            -- minetest.after(0.2, function(vel, driver)
            --    player:add_velocity(vel)
            -- end, v, player)
            minetest.after(0.5, function(vel, driver)
                -- player:add_velocity(vel)
                player:set_velocity({0, 0, 0})
            end, v, player)
        end
    end
    -- cleanup old jetpack
    for i, obj in ipairs(minetest.get_objects_inside_radius(pos, 0.5)) do
        if (obj ~= player) then
            local parachute = obj
            if (parachute ~= nil) then
                local ent = parachute:get_luaentity()
                if ent and ent._jetpack ~= nil then
                    ent.object:set_properties({
                        physical = false
                    })
                    ctg_jetpack.detach_object(ent, true)
                    return true
                end
            end
        end
    end
end)

minetest.register_on_leaveplayer(function(player)
    -- remove stale jetpack data
    local playername = player:get_player_name()
    if (jetpacks[playername] ~= nil) then
        local jetpack = jetpacks[playername].jetpack
        ctg_jetpack.detach_object(jetpack, true)
    end
end)

minetest.register_on_shutdown(function()
    local players = minetest.get_connected_players()
    for i, player in ipairs(players) do
        -- remove loaded jetpack data
        local playername = player:get_player_name()
        if (jetpacks[playername] ~= nil) then
            local jetpack = jetpacks[playername].jetpack
            ctg_jetpack.detach_object(jetpack, true)
        end
    end
end)

ctg_jetpack.detach_object = function(self, clear_jetpack)
    self._active = false
    self.object:set_detach()
    self.object:remove()
    if clear_jetpack and self._driver then
        ctg_jetpack.set_player_wearing(self._driver, false, false, false, false, nil, nil)
        remove_jetpack(self._driver)
    end
    -- minetest.log('detach_object...')
end

local function sound_play(self, soundref, instance)
    instance.time = 0
    instance.handle = minetest.sound_play(soundref.name, {
        gain = soundref.gain,
        pitch = soundref.pitch + math.random(-0.01, 0.01),
        object = self.object
    })
end

local function sound_stop(handle, fade)
    if not handle then
        return
    end
    if fade and minetest.sound_fade ~= nil then
        minetest.sound_fade(handle, 1, 0)
    else
        minetest.sound_stop(handle)
    end
end

local function sound_stop_all(self)
    if not self._sounds or type(self._sounds) ~= "table" then
        return
    end
    for _, sound in pairs(self._sounds) do
        sound_stop(sound.handle)
    end
end

local sound_list = {
    boost = {
        name = "sum_jetpack_flame",
        gain = 0.2,
        pitch = 0.7,
        duration = 3 + (3 * (1 - 0.6)) -- will stop the sound after this
    }
}

ctg_jetpack.sound_timer_update = function(self, dtime)
    for _, sound in pairs(self._sounds) do
        if sound.handle then
            sound.time = sound.time + dtime
        end
    end
end

ctg_jetpack.do_sounds = function(self)
    if self._sounds and self._sounds.engine then
        if not self._sounds.engine.handle and not self._disabled then
            sound_play(self, sound_list.boost, self._sounds.engine)
        elseif self._disabled or (self._sounds.engine.time > sound_list.boost.duration and self._sounds.engine.handle) then
            sound_stop(self._sounds.engine.handle)
            self._sounds.engine.handle = nil
        end

        if not self._driver and self._sounds.engine.handle then
            minetest.sound_stop(self._sounds.engine.handle)
            self._sounds.engine.handle = nil
        end
    else
        self._sounds.engine = {
            time = 0,
            handle = nil
        }
    end
end

ctg_jetpack.drop_self = function(self)
    -- local drop = self._itemstack
    self._flags.removed = true
end

-- clean up
ctg_jetpack.on_death = function(self, nothing)
    if self._itemstack then
        ctg_jetpack.drop_self(self)
        self._itemstack = nil
    end
    self.object:set_properties({
        physical = false
    })
    sound_stop_all(self)
    minetest.sound_play("sum_jetpack_fold", {
        gain = 1,
        object = self.object
    })
    local v = self.object:get_velocity()
    v = vector.multiply(v, 0.01)
    if self._driver then
        minetest.after(0.01, function(vel, driver)
            driver:add_velocity(vel)
        end, v, self._driver)
    end
    ctg_jetpack.detach_object(self, true)
end

-- sum_jetpack

ctg_jetpack.get_movement = function(self)
    if not self._driver or not self._driver:is_player() then
        return vector.new()
    end
    local ctrl = self._driver:get_player_control()
    if not ctrl then
        return vector.new()
    end

    local cur_y = self._driver:get_pos().y
    local mod = self._speed
    local dir = self._driver:get_look_dir()
    if (cur_y < 4000) then
        -- dir.y = math.max(0.1, self._driver:get_velocity().y * 0.30)
        dir = vector.normalize(vector.add(dir, vector.multiply(dir, 0.3)))
    else
        -- dir.y = math.max(0.01, self._driver:get_velocity().y * 0.50)
        dir = vector.normalize(vector.add(dir, vector.multiply(dir, 0.5)))
    end

    local forward = 0
    local up = 0
    local right = 0
    if ctrl.up then
        forward = 4 * mod
        if (cur_y < 4000) then
            forward = 5.0 * mod
        end
    elseif ctrl.down then
        forward = -0.5 * mod
        if (cur_y < 4000) then
            forward = -3.5 * mod
        end
    end
    if ctrl.jump then
        up = 1.37 * mod
        if (cur_y < 4000) then
            up = 6.0 * mod
        end
    elseif ctrl.aux1 then
        up = -1 * mod
        if (cur_y < 4000) then
            up = -3 * mod
        end
    end
    if ctrl.left then
        right = -0.5 * mod
    elseif ctrl.right then
        right = 0.5 * mod
    end

    local v = vector.new()
    v = vector.multiply(dir, forward)

    if right ~= 0 then
        local yaw = minetest.dir_to_yaw(dir)
        yaw = yaw - (right * (math.pi / 2))
        yaw = minetest.yaw_to_dir(yaw)
        v = vector.add(v, yaw)
    end

    v.y = up
    local vn = vector.normalize(v)
    local vf = vector.add(vector.multiply(v, 0.420), vn)
    local hzm = 3.7
    local vzm = 3.8
    if cur_y < 4000 then
        vzm = 5.0
        hzm = 4.0
    end
    if vf.y > vzm then
        vf.y = vzm
    end
    if vf.y < -1.05 then
        vf.y = -1.05
    end
    if vf.x > hzm then
        vf.x = hzm
    end
    if vf.x < -hzm then
        vf.x = -hzm
    end
    if vf.z > hzm then
        vf.z = hzm
    end
    if vf.z < -hzm then
        vf.z = -hzm
    end
    return vf
end

local particles_1 = {
    flame = {
        texture = "sum_jetpack_particle_steam.png",
        vel = 30,
        time = 1,
        size = 0.7,
        glow = 7,
        cols = false
    },
    smoke = {
        texture = "sum_jetpack_particle_vapor.png",
        vel = 15,
        time = 4.0,
        size = 1.4,
        glow = 1,
        cols = true
    },
    spark = {
        texture = "sum_jetpack_particle_spark_red.png",
        vel = 40,
        time = 0.6,
        size = 1,
        glow = 13,
        cols = false
    },
    trail = {
        texture = "ctg_jetpack_smoke_cloud.png",
        vel = 22,
        time = 6,
        size = 3,
        glow = 2,
        cols = true
    }
}
local particles_2 = {
    flame = {
        texture = "sum_jetpack_particle_flame.png",
        vel = 30,
        time = 1.05,
        size = 0.7,
        glow = 10,
        cols = false
    },
    smoke = {
        texture = "sum_jetpack_particle_smoke.png",
        vel = 15,
        time = 4.1,
        size = 1.3,
        glow = 1,
        cols = true
    },
    spark = {
        texture = "sum_jetpack_particle_spark.png",
        vel = 40,
        time = 0.64,
        size = 1,
        glow = 13,
        cols = false
    },
    trail = {
        texture = "ctg_jetpack_smoke_cloud.png",
        vel = 22,
        time = 5.5,
        size = 3,
        glow = 2,
        cols = true
    }
}
local particles_3 = {
    flame = {
        texture = "sum_jetpack_particle_flame.png",
        vel = 30,
        time = 1.05,
        size = 0.7,
        glow = 10,
        cols = false
    },
    smoke = {
        texture = "sum_jetpack_particle_vapor.png",
        vel = 15,
        time = 4.0,
        size = 1.3,
        glow = 1,
        cols = true
    },
    spark = {
        texture = "sum_jetpack_particle_spark.png",
        vel = 40,
        time = 0.64,
        size = 1,
        glow = 13,
        cols = false
    },
    trail = {
        texture = "ctg_jetpack_vapor_cloud.png",
        vel = 22,
        time = 5,
        size = 3,
        glow = 2,
        cols = true
    }
}
local particles_4 = {
    flame = {
        texture = "sum_jetpack_particle_flame_blue.png",
        vel = 30,
        time = 1,
        size = 0.7,
        glow = 8,
        cols = false
    },
    smoke = {
        texture = "sum_jetpack_particle_vapor.png",
        vel = 15,
        time = 4.0,
        size = 1.3,
        glow = 1,
        cols = true
    },
    spark = {
        texture = "sum_jetpack_particle_spark_blue.png",
        vel = 45,
        time = 0.7,
        size = 0.95,
        glow = 13,
        cols = false
    },
    trail = {
        texture = "ctg_jetpack_vapor_cloud.png",
        vel = 22,
        time = 6,
        size = 3,
        glow = 2,
        cols = true
    }
}
local particles_5 = {
    flame = {},
    smoke = {},
    spark = {},
    trail = {}
}

particles_1.flame.texture_r180 = particles_1.flame.texture .. "^[transformR180"
particles_1.smoke.texture_r180 = particles_1.smoke.texture .. "^[transformR180"
particles_1.spark.texture_r180 = particles_1.spark.texture .. "^[transformR180"
particles_1.trail.texture_r180 = particles_1.trail.texture .. "^[transformR180"
particles_2.flame.texture_r180 = particles_2.flame.texture .. "^[transformR180"
particles_2.smoke.texture_r180 = particles_2.smoke.texture .. "^[transformR180"
particles_2.spark.texture_r180 = particles_2.spark.texture .. "^[transformR180"
particles_2.trail.texture_r180 = particles_2.trail.texture .. "^[transformR180"
particles_3.flame.texture_r180 = particles_3.flame.texture .. "^[transformR180"
particles_3.smoke.texture_r180 = particles_3.smoke.texture .. "^[transformR180"
particles_3.spark.texture_r180 = particles_3.spark.texture .. "^[transformR180"
particles_3.trail.texture_r180 = particles_3.trail.texture .. "^[transformR180"
particles_4.flame.texture_r180 = particles_4.flame.texture .. "^[transformR180"
particles_4.smoke.texture_r180 = particles_4.smoke.texture .. "^[transformR180"
particles_4.spark.texture_r180 = particles_4.spark.texture .. "^[transformR180"
particles_4.trail.texture_r180 = particles_4.trail.texture .. "^[transformR180"
particles_5.flame.texture = "sum_jetpack_particle_spark.png^[transformR90]^sum_jetpack_particle_spark_orange.png"

local exhaust = {
    dist = 0.6,
    yaw = 0.5
}
ctg_jetpack.do_particles = function(self, dtime)
    if self._driver == nil then
        return false
    end
    if not self._driver then
        return false
    end
    local ctrl = self._driver:get_player_control()
    local moving = ctrl.jump or ctrl.up or ctrl.down or ctrl.left or ctrl.right
    local wind_vel = vector.new()
    local vel = self._driver:get_velocity()
    local p = self.object:get_pos()
    local v = self._driver:get_velocity()
    local d = self._driver:get_look_dir()
    v = vector.multiply(v, vector.normalize(d))
    v = vector.normalize(v)
    local sum_air_currents = minetest.get_modpath("sum_air_currents") ~= nil
    if sum_air_currents then
        sum_air_currents.get_wind(p)
    end
    local particles = nil
    if self._style == "copper" then
        particles = particles_1
    elseif self._style == "iron" then
        particles = particles_2
    elseif self._style == "bronze" then
        particles = particles_3
    elseif self._style == "titanium" then
        particles = particles_4
    end
    -- minetest.log("vel y: " .. vel.y)
    for i = -1, 0 do
        if i == 0 then
            i = 1
        end
        local yaw = self.object:get_yaw() + (exhaust.yaw * i) + math.pi
        yaw = minetest.yaw_to_dir(yaw)
        yaw = vector.multiply(yaw, exhaust.dist)
        local ex = vector.add(p, yaw)
        if vel.y < -6 then
            ex.y = ex.y + 0.25
        elseif vel.y < -3 then
            ex.y = ex.y + 0.5
        elseif vel.y > 9 then
            ex.y = ex.y + 2
        elseif vel.y > 5 then
            ex.y = ex.y + 1.5
        else
            ex.y = ex.y + 1
        end
        if particles ~= nil then
            for _, prt in pairs(particles) do
                if prt.texture ~= "ctg_jetpack_vapor_cloud.png" and prt.texture ~= "ctg_jetpack_smoke_cloud.png" then
                    local rx = math.random(-0.01, 0.01) * 0.5
                    local rz = math.random(-0.01, 0.01) * 0.5
                    local texture = prt.texture
                    if (math.random() >= 0.6) then
                        texture = prt.texture_r180
                    end
                    minetest.add_particle({
                        pos = ex,
                        velocity = vector.add(v, vector.add(wind_vel, {
                            x = rx,
                            y = prt.vel * -math.random(0.2 * 100, 0.7 * 100) / 100,
                            z = rz
                        })),
                        minacc = {
                            x = -0.02,
                            y = -0.07,
                            z = -0.02
                        },
                        maxacc = {
                            x = 0.02,
                            y = -0.03,
                            z = 0.02
                        },
                        expirationtime = ((math.random() / 5) + 0.25) * prt.time,
                        size = ((math.random()) * 4 + 0.1) * prt.size,
                        collisiondetection = prt.cols,
                        vertical = false,
                        texture = texture,
                        glow = prt.glow
                    })
                elseif math.random() >= 0.6 then
                    local exm = ex
                    exm.y = exm.y - 1.2
                    local rx = math.random(-0.01, 0.01) * 0.9
                    local rz = math.random(-0.01, 0.01) * 0.9
                    local texture = prt.texture
                    if (math.random() >= 0.6) then
                        texture = prt.texture_r180
                    end
                    minetest.add_particle({
                        pos = exm,
                        velocity = vector.add(v, vector.add(wind_vel, {
                            x = rx,
                            y = prt.vel * -math.random(0.2 * 100, 0.7 * 100) / 100,
                            z = rz
                        })),
                        expirationtime = ((math.random() / 5) + 0.25) * prt.time,
                        size = ((math.random()) * 5 + 0.1) * prt.size,
                        collisiondetection = prt.cols,
                        vertical = false,
                        texture = texture,
                        glow = prt.glow
                    })
                end
            end
        end

        local prt = {
            texture = particles_5.flame.texture,
            vel = 45,
            time = 1.25,
            size = 0.5,
            glow = 13,
            cols = true
        }
        if moving and math.random() >= 0.46 then
            local rx = math.random(-0.01, 0.01) * 0.6
            local rz = math.random(-0.01, 0.01) * 0.6
            minetest.add_particle({
                pos = ex,
                velocity = vector.add(v, vector.add(wind_vel, {
                    x = rx,
                    y = prt.vel * -math.random(0.2 * 100, 0.7 * 100) / 100,
                    z = rz
                })),
                expirationtime = ((math.random() / 5) + 0.25) * prt.time,
                size = ((math.random()) * 4 + 0.1) * prt.size,
                collisiondetection = prt.cols,
                vertical = false,
                texture = prt.texture,
                glow = prt.glow
            })
        end
    end
end

local function has_in_range(p, c_name, rng, thres)
    local pos = {
        x = p.x,
        y = p.y,
        z = p.z
    }
    local range = {
        x = rng,
        y = rng,
        z = rng
    }
    local pos1 = vector.subtract(pos, range)
    local pos2 = vector.add(pos, range)
    local nodes = minetest.find_nodes_in_area(pos1, pos2, {c_name})
    return #nodes >= thres
end

local function generate_from_solar(self, dtime)
    if self._itemstack then
        local wear = self._itemstack:get_wear()
        if wear and wear > 60100 then
            return
        end
        if wear == 0 then
            return
        end
        if (math.random(0, 10) == 0) then
            return
        end
        if self._driver and self._driver:is_player() then
            local player = self._driver
            local _, armor_inv = armor.get_valid_player(armor, player, "[jetpack]")
            local armor_list = armor_inv:get_list("armor")
            local jetpack = nil
            local pos = player:get_pos()
            local _time = minetest.get_timeofday() * 24000
            local light = 0
            if (_time > 0) then
                light = minetest.get_node_light(pos, _time / 24000)
                if light == nil then
                    light = 0
                end
                if (light < 12) then
                    -- minetest.log("Not enough light! " .. light)
                    if self._generating then
                        ctg_jetpack.set_player_wearing(player, true, true, false, false, armor_list, armor_inv, true)
                        self._generating = false
                    end
                    return false
                end
            end
            if (has_in_range(pos, "group:torch", 1, 1)) then
                light = light - 5
            elseif (has_in_range(pos, "group:illumination_light", 1, 1)) then
                light = light - 5
            elseif (has_in_range(pos, "technic:lv_lamp", 2, 1)) then
                light = light - 5
            end
            local index = 0
            for i, stack in ipairs(armor_inv:get_list("armor")) do
                if not stack:is_empty() then
                    local name = stack:get_name()
                    local jp = player:get_armor_groups(name, "jetpack")
                    local ig = minetest.get_item_group(name, "armor_jetpack")
                    if jp ~= nil and ig ~= nil and ig >= 9 then
                        jetpack = stack
                        index = i
                        break
                    end
                end
            end
            local amt = 10 + (light - 10) * dtime * 2.5
            local update = false
            if (jetpack ~= nil and light >= 12 and amt >= 5 and jetpack:get_wear() < 60100) then
                for i, stack in ipairs(armor_inv:get_list("armor")) do
                    if not stack:is_empty() then
                        local name = stack:get_name()
                        local addon_module = minetest.get_item_group(name, "armor_module")
                        if (addon_module ~= nil) and addon_module == 3 then
                            if (stack:get_wear() < 60100) then
                                local wear = self._itemstack:get_wear()
                                if (wear - amt >= 0) then
                                    -- minetest.log("Repaired!!  wear: " .. wear)
                                    armor:damage(player, i, stack, amt * 0.05)
                                    armor:damage(player, index, self._itemstack, -(amt))
                                    update = true
                                    self._generating = true
                                else
                                    self._itemstack:set_wear(0)
                                end
                                break
                            end
                        end
                    end
                end
            end
            if (update) then
                ctg_jetpack.set_player_wearing(player, true, true, false, self._generating, armor_list, armor_inv)
            elseif self._generating then
                ctg_jetpack.set_player_wearing2(player, true, true, false, false, armor_list, armor_inv, true)
                self._generating = false
            end
            return true
        end
    end
end

local move_speed = 25
ctg_jetpack.max_use_time = 30
ctg_jetpack.wear_per_sec = 60100 / ctg_jetpack.max_use_time
-- warn the player 5 sec before fuel runs out
ctg_jetpack.wear_warn_level = (ctg_jetpack.max_use_time - 5) * ctg_jetpack.wear_per_sec

function ctg_jetpack.setup(style)
    if style == "copper" then
        ctg_jetpack.max_use_time = 70
    elseif style == "iron" then
        ctg_jetpack.max_use_time = 90
    elseif style == "bronze" then
        ctg_jetpack.max_use_time = 110
    elseif style == "titanium" then
        ctg_jetpack.max_use_time = 150
    end
    ctg_jetpack.wear_per_sec = 60100 / ctg_jetpack.max_use_time
    -- warn the player a few sec before fuel runs out
    ctg_jetpack.wear_warn_level = (ctg_jetpack.max_use_time - 10) * ctg_jetpack.wear_per_sec
end

ctg_jetpack.on_step = function(self, dtime)
    if not self._driver and self._age > 1 then
        -- minetest.log("has no driver.. ")
        self.object:remove()
        return
    end
    if (self._age > 1 and self._driver:get_hp() <= 0) then
        self._driver:set_velocity({0, 0, 0})
        ctg_jetpack.detach_object(self, true)
        return
    end
    local move = false
    local jump = false
    if self._driver and self._driver:is_player() then
        local ctrl = self._driver:get_player_control()
        if ctrl and ctrl.left or ctrl.right or ctrl.up or ctrl.down then
            move = true
        end
        if ctrl and ctrl.jump then
            jump = true
        else
            self._press = 0
        end
    end
    if self._age > 1 and jump and not self._active then
        local wear = self._itemstack:get_wear()
        if self._press > 0.300 and wear and wear < 60000 then
            if (self._driver and self._driver:get_hp() <= 0) then
                self.object:remove()
                return
            end
            if (self._driver and self._driver:get_attach() and #self._driver:get_attach() > 0) then
                return
            end
            self.object:set_properties({
                physical = true
            })
            self._disabled = false
            self._active = true
            self._press = 0
            self._age = 1
            minetest.sound_play("sum_jetpack_flame_start", {
                gain = 0.3,
                object = self.object
            })
        end
        self._press = self._press + dtime
        return
    end
    if self._age > 1 and not self._active then
        generate_from_solar(self, dtime)
    end
    if self._age < 1000 then
        self._age = self._age + dtime
    end
    if not self._active then
        return
    end
    if not self._flags.ready and self._age < 1 then
        return
    end
    if self._itemstack then
        local wear = self._itemstack:get_wear()
        if wear and wear > 60100 then
            return
        end
        if self._driver and self._driver:is_player() then
            local player = self._driver
            local _, armor_inv = armor.get_valid_player(armor, player, "[jetpack]")
            local armor_list = armor_inv:get_list("armor")
            for i, stack in pairs(armor_inv:get_list("armor")) do
                if not stack:is_empty() then
                    local name = stack:get_name()
                    -- local addon_jetpack = minetest.get_item_group(name, "armor_jetpack")	
                    wear = stack:get_wear()
                    if name:sub(1, 20) == "ctg_jetpack:jetpack_" and wear + ctg_jetpack.wear_per_sec * dtime < 60100 then
                        -- if addon_jetpack ~= nil and wear + ctg_jetpack.wear_per_sec * dtime < 60100 then
                        ctg_jetpack.set_player_wearing(player, true, true, true, self._generating, armor_list, armor_inv)
                        if jump then
                            armor:damage(player, i, stack, (ctg_jetpack.wear_per_sec * dtime) * 4.0)
                        elseif move then
                            armor:damage(player, i, stack, (ctg_jetpack.wear_per_sec * dtime) * 1.5)
                        else
                            armor:damage(player, i, stack, (ctg_jetpack.wear_per_sec * dtime) * 0.5)
                        end
                        self._itemstack = stack
                        break
                    elseif name:sub(1, 20) == "ctg_jetpack:jetpack_" then
                        -- elseif addon_jetpack ~= nil then
                        if (self._fuel > 0) then
                            local warn_sound = minetest.sound_play("sum_jetpack_warn", {
                                gain = 0.3,
                                pitch = 0.5,
                                object = self.object
                            })
                        end
                        self._itemstack = stack
                        ctg_jetpack.set_player_wearing(player, true, false, false, self._generating, armor_list,
                            armor_inv)
                        self._fuel = 0
                        self._active = false
                        self._disabled = true
                        return false
                    end
                end
            end
        end

        self._fuel = ctg_jetpack.max_use_time - (wear / ctg_jetpack.wear_per_sec)
        if wear >= 60100 then
            self._disabled = true
            -- ctg_jetpack.on_death(self, nil)
            -- self.object:remove()
            self._active = false
            return false
        elseif wear >= ctg_jetpack.wear_warn_level and (not self._flags.warn) then
            minetest.chat_send_player(self._driver:get_player_name(), S("Your @1 is almost out of fuel!", "Jetpack"))
            local warn_sound = minetest.sound_play("sum_jetpack_warn", {
                gain = 0.5,
                object = self.object
            })
            if warn_sound and minetest.sound_fade ~= nil then
                minetest.sound_fade(warn_sound, 0.1, 0)
            end
            self._flags.warn = true
        end
    end
    if self._sounds then
        ctg_jetpack.sound_timer_update(self, dtime)
        ctg_jetpack.do_sounds(self)
    end

    ctg_jetpack.do_particles(self, dtime)

    local p = self.object:get_pos()
    local node_floor = minetest.get_node(vector.offset(p, 0, -0.2, 0))
    -- local exit = self._age > 1 and not self._driver
    local exit = (self._driver and self._driver:get_player_control().sneak) or (self._age > 1 and not self._driver)
    if exit or (not self._driver) or (not self.object:get_attach()) then
        self._active = false
        self.object:set_properties({
            physical = false
        })
        sound_stop_all(self)
        minetest.sound_play("sum_jetpack_fold", {
            gain = 1,
            object = self.object
        })
        local v = self.object:get_velocity()
        v = vector.multiply(v, 0.8)
        if self._driver then
            minetest.after(0.01, function(vel, driver)
                driver:add_velocity(vel)
            end, v, self._driver)
        end
        local _, armor_inv = armor.get_valid_player(armor, self._driver, "[jetpack]")
        local armor_list = armor_inv:get_list("armor")
        for i, stack in pairs(armor_inv:get_list("armor")) do
            if not stack:is_empty() then
                local name = stack:get_name()
                local wear = stack:get_wear()
                if name:sub(1, 12) == "ctg_jetpack:" then
                    ctg_jetpack.set_player_wearing(self._driver, true, wear < 60100, false, self._generating,
                        armor_list, armor_inv)
                end
            end
        end
        return false
    end

    if self._driver then
        self.object:set_yaw(minetest.dir_to_yaw(self._driver:get_look_dir()))
    end

    local a = vector.new()
    local move_mult = math.min(10, move_speed * math.min(1, dtime) * 0.357 + 0.01)
    -- if self._disabled then move_mult = move_mult / 10 end

    local move_vect = ctg_jetpack.get_movement(self)
    a = vector.multiply(move_vect, move_mult)

    local sum_air_currents = minetest.get_modpath("sum_air_currents") ~= nil
    if sum_air_currents and sum_air_currents.get_wind ~= nil then
        a = vector.add(a, vector.multiply(sum_air_currents.get_wind(p), dtime * 0.1))
    end

    local cur_y = self._driver:get_pos().y
    local vel = self._driver:get_velocity()
    if cur_y > 4000 then
        vel = vector.multiply(vel, -0.0964)
    else
        vel = vector.multiply(vel, -0.1051)
    end
    if vel.y > 0 then
        if cur_y > 4000 then
            vel.y = math.min(vel.y * 2, 2.0)
        else
            vel.y = math.min(vel.y * 2, 2.0)
        end
    end
    vel = vector.add(a, vel)
    self._driver:add_velocity(vel)
end

local function register_jetpack_entity(style, speed)
    local cbsize = 0.3
    local entity = {
        physical = false,
        timer = 0,
        visual = "mesh",
        mesh = "sum_jetpack.b3d",
        textures = {"ctg_jetpack_" .. style .. "_texture.png"},
        visual_size = {
            x = 1,
            y = 1,
            z = 1
        },
        collisionbox = {-cbsize, -0, -cbsize, cbsize, cbsize * 6, cbsize},
        pointable = false,
        get_staticdata = ctg_jetpack.get_staticdata,
        on_activate = ctg_jetpack.on_activate,
        on_step = ctg_jetpack.on_step,
        groups = {
            immortal = 1
        },
        armor_groups = {
            immortal = 1
        },
        immortal = 1,
        _style = style,
        _thrower = nil,
        _driver = nil,
        _age = 0,
        _press = 0,
        _sounds = nil,
        _itemstack = nil,
        _disabled = false,
        _active = false,
        _flags = {},
        _fuel = ctg_jetpack.max_use_time,
        _speed = speed,
        _generating = false,
        _jetpack = 1,
        _lastpos = {}
    }

    minetest.register_entity("ctg_jetpack:jetpack_" .. style .. "_entity", entity)
end

register_jetpack_entity("iron", 1.10)
register_jetpack_entity("copper", 1.00)
register_jetpack_entity("bronze", 1.21)
register_jetpack_entity("titanium", 1.35)
