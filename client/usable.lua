STATE = {}

function StartEffect(data, cb)
	if not data then cb() return end
    if (not STATE.EFFECT_STATUS) then 
        STATE.EFFECT_STATUS = data.Type
        Citizen.CreateThread(function()
            Config.EffectTypes[data.Type](data, function()
                STATE.EFFECT_STATUS = nil
                cb()
            end)
        end)
    end
end

function GetRemainingUses(durability, item)
    local itemdata = Config.Items[item]
    if (durability > 0) then 
        if (durability >= itemdata.Consume) then
            return (durability // itemdata.Consume)
        else
            return 1
        end
    else
        return 0
    end
end

function OnTakeout(item)
    local itemdata = Config.Items[item]
    if (STATE.CURRENT_ITEM ~= item) then             
        STATE.CURRENT_ITEM = item
        CreateItemProp(itemdata.Prop)
        PlayAnim(itemdata.Animations.Takeout)
        Citizen.CreateThread(function() 
            while STATE.CURRENT_ITEM == item do 
                if (not STATE.ITEM_USING and STATE.DURABILITY) then 
                    ESX.ShowHelpNotification("Remaining Uses: ".. GetRemainingUses(STATE.DURABILITY, item) .. "\nPress ~INPUT_FRONTEND_RDOWN~ to use the item.\nPress ~INPUT_FRONTEND_RRIGHT~ to put it away.")
                end
                Citizen.Wait(10)
            end
        end)
    end
end

function OnUsed()
    local item = STATE.CURRENT_ITEM
    if (item) then 
        local itemdata = Config.Items[item]
        if (not STATE.ITEM_USING) then       
            STATE.ITEM_USING = true
            ESX.TriggerServerCallback("pitems:useItem", function(result) 
                if (result) then 
                    PlayAnim(itemdata.Animations.Used, function()
                        ClearPedTasks(PlayerPedId())
                        StartEffect(itemdata.Effect, function()
                            STATE.ITEM_USING = false
                            STATE.DURABILITY = STATE.DURABILITY - itemdata.Consume
                            if (STATE.DURABILITY <= 0) then 
                                OnRemove()
                            else
                                CreateItemProp(itemdata.Prop)
                                ClearPedTasks(PlayerPedId())
                                PlayAnim(itemdata.Animations.Takeout)
                            end
                        end)
                    end)
                end
            end)
        end 
    end
end

function OnRemove()
    local item = STATE.CURRENT_ITEM
    if (item and not STATE.ITEM_USING and Config.Items[item]) then 
        local itemdata = Config.Items[item] 
        PlayAnim(itemdata.Animations.Remove, function()
            ClearPedTasks(PlayerPedId())
        end)
        DeleteItemProp()
        STATE.CURRENT_ITEM = nil
        STATE.DURABILITY = nil
        ESX.TriggerServerCallback("pitems:returnItem", function(result) 
        end)
    end
end

function DeleteItemProp()
    if (STATE.CURRENT_PROP) then 
        RequestNetworkControl(STATE.CURRENT_PROP, function() 
            DetachEntity(STATE.CURRENT_PROP, false, false)
            DeleteEntity(STATE.CURRENT_PROP)
        end)
        STATE.CURRENT_PROP = nil
    end
end

function CreateItemProp(propdata)
    DeleteItemProp()
    STATE.CURRENT_PROP = CreateAttachedProp({model = propdata.Model, bone_id = propdata.BoneID, coords = propdata.Offset, rotation = propdata.Rotation})
end

RegisterNetEvent("pitems:takeoutItem", function(data)
    STATE.DURABILITY = data.metadata.durability
    OnTakeout(data.name)
end)

RegisterCommand("+pitems_use", function()
    OnUsed()
end)

RegisterCommand("-pitems_use", function() end)

RegisterCommand("+pitems_remove", function() OnRemove() end)
RegisterCommand("-pitems_remove", function() end)

RegisterKeyMapping('+pitems_use', 'Use Item', 'keyboard', 'RETURN')
RegisterKeyMapping('+pitems_remove', 'Use Item', 'keyboard', 'BACK')