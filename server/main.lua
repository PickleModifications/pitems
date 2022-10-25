PlayerState = {}

for k, v in pairs(Config.Items) do 
    ESX.RegisterUsableItem(k, function(source, item, data)
        if (not PlayerState[source]) then
            Inventory:RemoveItem(source, k, 1, metadata, data.slot)
            PlayerState[source] = data
            PlayerState[source].metadata.durability = (data.metadata.durability and data.metadata.durability or 100)
            TriggerClientEvent("pitems:takeoutItem", source, PlayerState[source])
        end
    end)
end

ESX.RegisterServerCallback("pitems:useItem", function(source, cb)
    if (PlayerState[source]) then
        local data = PlayerState[source]
        if (PlayerState[source].metadata.durability > 0) then 
            PlayerState[source].metadata.durability = (PlayerState[source].metadata.durability - Config.Items[data.name].Consume)
            if (PlayerState[source].metadata.durability < 0) then 
                PlayerState[source].metadata.durability = 0
            end
            cb(true)
        else
            cb(false)
        end
    else
        cb(false)
    end
end)

ESX.RegisterServerCallback("pitems:returnItem", function(source, cb)
    if (PlayerState[source]) then
        local data = PlayerState[source]
        if (data.metadata.durability > 0) then
            if (data.metadata.durability >= 100) then 
                data.metadata.durability = nil
            end
            Inventory:AddItem(source, data.name, 1, data.metadata, data.slot, function(success) 
                if (not success) then 
                    Inventory:AddItem(source, data.name, 1, data.metadata)
                end
            end)  
        end
        PlayerState[source] = nil  
        cb(true)
    else
        cb(false)
    end
end)