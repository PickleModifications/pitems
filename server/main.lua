PlayerState = {}

for k, v in pairs(Config.Items) do 
    ESX.RegisterUsableItem(k, function(source, item, data)
        if (not PlayerState[source]) then
            Inventory:RemoveItem(source, k, 1, metadata, data.slot)
            PlayerState[source] = data
            PlayerState[source].metadata.item_durability = (data.metadata.item_durability and data.metadata.item_durability or 100)
            TriggerClientEvent("pitems:takeoutItem", source, PlayerState[source])
        end
    end)
end

ESX.RegisterServerCallback("pitems:useItem", function(source, cb)
    if (PlayerState[source]) then
        local data = PlayerState[source]
        if (PlayerState[source].metadata.item_durability > 0) then 
            PlayerState[source].metadata.item_durability = (PlayerState[source].metadata.item_durability - Config.Items[data.name].Consume)
            if (PlayerState[source].metadata.item_durability < 0) then 
                PlayerState[source].metadata.item_durability = 0
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
        if (data.metadata.item_durability > 0) then
            if (data.metadata.item_durability >= 100) then 
                data.metadata.item_durability = nil
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
