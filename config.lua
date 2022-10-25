Config = {}

Config.EffectTypes = { -- ADD / REMOVE YOU WANT! All values in Effects = {} will be passed through "data".
    ["EAT"] = function(data, cb)
        TriggerEvent('esx_status:add', 'hunger', data.Value)
        cb()
    end,
    ["DRINK"] = function(data, cb)
        TriggerEvent('esx_status:add', 'thirst', data.Value)
        cb()
    end,
    ["HIGH"] = function(data, cb)
        local player = PlayerId()
        local ped = PlayerPedId()
        
        RequestAnimSet("MOVE_M@DRUNK@VERYDRUNK") 
        
        while not HasAnimSetLoaded("MOVE_M@DRUNK@VERYDRUNK") do
            Citizen.Wait(0)
        end    
        
        SetPedMovementClipset(ped, "MOVE_M@DRUNK@VERYDRUNK", 1.0)
        SetPedMotionBlur(ped, true)
        SetPedIsDrunk(ped, true)

        SetTimecycleModifier("spectator6")
        
        for i=1, 100 do 
            SetTimecycleModifierStrength(i * 0.01)
            ShakeGameplayCam("DRUNK_SHAKE", i * 0.01)
            Citizen.Wait(10)
        end
        
        Citizen.Wait(1000 * data.Duration)

        for i=1, 100 do 
            SetTimecycleModifierStrength(1.0 - (i * 0.01))
            ShakeGameplayCam("DRUNK_SHAKE", (1.0 - (i * 0.01)))
            Citizen.Wait(10)
        end

        SetPedMoveRateOverride(player, 1.0)
        SetRunSprintMultiplierForPlayer(player,1.0)
        
        SetPedIsDrunk(ped, false)		
        SetPedMotionBlur(ped, false)
        ResetPedMovementClipset(ped, 1.0)
        cb()
    end,
    ["DRUNK"] = function(data, cb)
        local player = PlayerId()
        local ped = PlayerPedId()
        
        RequestAnimSet("MOVE_M@DRUNK@VERYDRUNK") 
        
        while not HasAnimSetLoaded("MOVE_M@DRUNK@VERYDRUNK") do
            Citizen.Wait(0)
        end    
        
        SetPedMovementClipset(ped, "MOVE_M@DRUNK@VERYDRUNK", 1.0)
        SetPedMotionBlur(ped, true)
        SetPedIsDrunk(ped, true)

        SetTimecycleModifier("drug_wobbly")
        
        for i=1, 100 do 
            SetTimecycleModifierStrength(i * 0.01)
            ShakeGameplayCam("DRUNK_SHAKE", i * 0.01)
            Citizen.Wait(10)
        end
        
        Citizen.Wait(1000 * data.Duration)

        for i=1, 100 do 
            SetTimecycleModifierStrength(1.0 - (i * 0.01))
            ShakeGameplayCam("DRUNK_SHAKE", (1.0 - (i * 0.01)))
            Citizen.Wait(10)
        end

        SetPedMoveRateOverride(player, 1.0)
        SetRunSprintMultiplierForPlayer(player,1.0)
        
        SetPedIsDrunk(ped, false)		
        SetPedMotionBlur(ped, false)
        ResetPedMovementClipset(ped, 1.0)
        cb()
    end,
}

Config.Items = {
    ["big_burger"] = {
        Consume = 20, -- 0-100, How much to remove per use.
        Prop = { -- Prop spawn data for idle & usage.
            Model = `prop_cs_burger_01`,
            BoneID = 18905,
            Offset = vector3(0.1, 0.0, 0.05),
            Rotation = vector3(-180.0, 0.0, 0.0),
        },
        Animations = {
            Takeout = nil, -- Anim to play when taking out the item & after effects. (nil = no anim)
            Used = {
                dictionary = "mp_player_inteat@burger", 
                animation = "mp_player_int_eat_burger_fp", 
                time = 1200, 
                params = {nil, nil, nil, 49} -- rest of TaskPlayAnim after dict, anim, time.
            },
            Removed = nil, -- Anim to play when item is fully consumed or returned. (nil = no anim)
        },
        Effect = { -- Only required value is Type = "EFFECT_HERE", excess data is used for vars.
            Type = "EAT", 
            Duration = 10,
            Value = 200000
        }
    },
    ["blunt"] = {
        Consume = 20,
        Prop = {
            Model = `prop_cs_ciggy_01`,
            BoneID = 28422,
            Offset = vector3(0.0, 0.0, 0.0),
            Rotation = vector3(0.0, 0.0, 0.0),
        },
        Animations = {
            Takeout = {
                dictionary = "amb@world_human_aa_smoke@male@base", 
                animation = "base", 
                time = nil, 
                params = {nil, nil, nil, 49}
            }, 
            Used = {
                dictionary = "amb@world_human_aa_smoke@male@idle_a", 
                animation = "idle_b", 
                time = 5000, 
                params = {nil, nil, nil, 49}
            },
            Removed = nil, 
        },
        Effect = {
            Type = "HIGH", 
            Duration = 10
        }
    },
    ["beer"] = {
        Consume = 20,
        Prop = {
            Model = `prop_cs_beer_bot_01`,
            BoneID = 18905,
            Offset = vector3(0.1, 0.01, 0.01),
            Rotation = vector3(100.0, 0.0, -180.0),
        },
        Animations = {
            Takeout = nil,
            Used = {
                dictionary = "mp_player_intdrink", 
                animation = "loop_bottle", 
                time = 2000, 
                params = {nil, nil, nil, 49}
            },
            Removed = nil, 
        },
        Effect = {
            Type = "DRUNK", 
            Duration = 10
        }
    },
    ["soda"] = {
        Consume = 20,
        Prop = {
            Model = `prop_ecola_can`,
            BoneID = 18905,
            Offset = vector3(0.1, 0.01, 0.01),
            Rotation = vector3(100.0, 0.0, -180.0),
        },
        Animations = {
            Takeout = nil,
            Used = {
                dictionary = "mp_player_intdrink", 
                animation = "loop_bottle", 
                time = 2000, 
                params = {nil, nil, nil, 49}
            },
            Removed = nil, 
        },
        Effect = {
            Type = "DRINK", 
            Duration = 10,
            Value = 200000
        }
    },
}