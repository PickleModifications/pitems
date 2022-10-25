function RequestNetworkControl(entity, cb)
    NetworkRequestControlOfEntity(entity)
	
    local timeout = 2000
	while timeout > 0 and not NetworkHasControlOfEntity(entity) do
		Wait(100)
		timeout = timeout - 100
	end

	SetEntityAsMissionEntity(entity, true, true)
	
	local timeout = 2000
	while timeout > 0 and not IsEntityAMissionEntity(entity) do
		Wait(100)
		timeout = timeout - 100
	end

	cb(NetworkHasControlOfEntity(entity))
end

function LoadModel(model)
	RequestModel(model)
	while not HasModelLoaded(model) do Wait(0) end
end

function LoadDictionary(dict)
	RequestAnimDict(dict)
	while not HasAnimDictLoaded(dict) do Wait(0) end
end

function CreateAttachedProp(data)
	local ped = PlayerPedId()
	local x, y, z = GetEntityCoords(ped)
	local modelHash = data.model
	LoadModel(modelHash)
	local prop = CreateObject(modelHash, x, y, z, true)
	AttachEntityToEntity(prop, ped, GetPedBoneIndex(ped, data.bone_id), data.coords.x, data.coords.y, data.coords.z, 
	data.rotation.x, data.rotation.y, data.rotation.z, false, false, false, false, 2, true)
	return prop
end

function PlayAnim(data, cb)
	if not data then 
		if (cb) then 
			cb() 
		end 
		return 
	end
	data.params = data.params or {}
	local ped = PlayerPedId()
	LoadDictionary(data.dictionary)
	TaskPlayAnim(ped, data.dictionary, data.animation, data.params[1] or 1.0, data.params[2] or -1.0, data.params[3] or -1, data.params[4] or 1, data.params[5] or 1, data.params[6], data.params[7], data.params[8])
	if not (data.time) then return end
	SetTimeout(data.time, function()
		cb()
	end)
end