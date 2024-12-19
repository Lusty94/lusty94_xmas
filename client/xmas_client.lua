local QBCore = exports['qb-core']:GetCoreObject()
local TargetType = Config.CoreSettings.Target.Type
local NotifyType = Config.CoreSettings.Notify.Type
local InvType = Config.CoreSettings.Inventory.Type
local busy, bearSpawned = false, false
local spawnedPresents, presentBlips, spawnedSnowmen = {}, {}, {}


--notification function
local function SendNotify(msg,type,time,title)
    if NotifyType == nil then print("Lusty94_Xmas: NotifyType Not Set in Config.CoreSettings.Notify.Type!") return end
    if not title then title = "Xmas" end
    if not time then time = 5000 end
    if not type then type = 'success' end
    if not msg then print("Notification Sent With No Message.") return end
    if NotifyType == 'qb' then
        QBCore.Functions.Notify(msg,type,time)
    elseif NotifyType == 'okok' then
        exports['okokNotify']:Alert(title, msg, time, type, true)
    elseif NotifyType == 'mythic' then
        exports['mythic_notify']:DoHudText(type, msg)
    elseif NotifyType == 'ox' then
        lib.notify({ title = title, description = msg, type = type, duration = time})
    end
end

--spawn presents
function spawnPresents()
    local icon = Config.InteractionLocations.Presents.Icon
    local label = Config.InteractionLocations.Presents.Label
    local prop = Config.InteractionLocations.Presents.Prop
    local dist = Config.InteractionLocations.Presents.Distance
	for k,v in pairs(Config.InteractionLocations.Presents.Locations) do
		lib.requestModel(prop, 20000)
		presents = CreateObject(prop, v.Coords.x, v.Coords.y, v.Coords.z - 1, true, false, false)
		SetEntityHeading(presents, v.Coords.W)
		PlaceObjectOnGroundProperly(presents, true)
		FreezeEntityPosition(presents, true)
		spawnedPresents[#spawnedPresents+1] = presents
		SetModelAsNoLongerNeeded(prop)
		if TargetType == 'qb' then
		    exports['qb-target']:AddTargetEntity(presents, { options = { 
                { 
                    type = "client", 
                    action = function() 
                        if not busy then 
                            collectPresent()
                        else 
                            SendNotify(Config.Language.Notifications.Busy, 'error', 2000) 
                        end 
                    end, 
                    icon = icon, 
                    label = label, 
                }, 
            }, distance = dist })
        elseif TargetType == 'ox' then
            exports.ox_target:addLocalEntity(presents, { 
                { 
                    name = 'presents', 
                    icon = icon, 
                    label = label, 
                    onSelect = function() 
                        if not busy then 
                            collectPresent()
                        else 
                            SendNotify(Config.Language.Notifications.Busy, 'error', 2000) 
                        end 
                    end, 
                    distance = dist
                }, 
            })
        end
        if Config.CoreSettings.Blips.Presents then
            local blip = AddBlipForCoord(v.Coords.x, v.Coords.y, v.Coords.z)
            SetBlipSprite(blip, 58)
            SetBlipDisplay(blip, 4)
            SetBlipScale(blip, 0.8)
            SetBlipColour(blip, 2)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString("Christmas Present")
            EndTextCommandSetBlipName(blip)
            presentBlips[presents] = blip
        end
	end
end

--spawn snowmen
function spawnSnowmen()
    local icon = Config.InteractionLocations.Snowmen.Icon
    local label = Config.InteractionLocations.Snowmen.Label
    local prop = Config.InteractionLocations.Snowmen.Prop
    local dist = Config.InteractionLocations.Snowmen.Distance
	for k, v in pairs(Config.InteractionLocations.Snowmen.Locations) do
		lib.requestModel(prop, 20000)
		snowmen = CreateObject(prop, v.Coords.x, v.Coords.y, v.Coords.z - 1, true, false, false)
		SetEntityHeading(snowmen, v.Coords.w - 180)
		PlaceObjectOnGroundProperly(snowmen, true)
		FreezeEntityPosition(snowmen, true)
		spawnedSnowmen[#spawnedSnowmen+1] = snowmen
		SetModelAsNoLongerNeeded(prop)
		if TargetType == 'qb' then
		    exports['qb-target']:AddTargetEntity(snowmen, { options = { 
                { 
                    type = "client", 
                    action = function() 
                        if not busy then 
                            openPresents() 
                        else 
                            SendNotify(Config.Language.Notifications.Busy, 'error', 2000) 
                        end 
                    end, 
                    icon = icon, 
                    label = label, 
                }, 
            }, distance = dist })
        elseif TargetType == 'ox' then
            exports.ox_target:addLocalEntity(snowmen, { 
                { 
                    name = 'snowmen', 
                    icon = icon, 
                    label = label, 
                    onSelect = function() 
                        if not busy then 
                            openPresents()
                        else 
                            SendNotify(Config.Language.Notifications.Busy, 'error', 2000) 
                        end 
                    end, 
                    distance = dist
                }, 
            })
        end
        if Config.CoreSettings.Blips.Exchange then
            local blip = AddBlipForCoord(v.Coords.x, v.Coords.y, v.Coords.z)
            SetBlipSprite(blip, 103)
            SetBlipDisplay(blip, 4)
            SetBlipScale(blip, 0.8)
            SetBlipColour(blip, 5)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString("Snowman")
            EndTextCommandSetBlipName(blip)
        end
	end
end


--collect presents
function collectPresent()
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    local nearbyObject, nearbyID
    for i = 1, #spawnedPresents, 1 do
        if #(coords - GetEntityCoords(spawnedPresents[i])) < 3 then
            nearbyObject, nearbyID = spawnedPresents[i], i
        end
    end
    if nearbyObject and IsPedOnFoot(playerPed) then
        if busy then
            SendNotify(Config.Language.Notifications.Busy, 'error', 2000)
        else
            busy = true
            LockInventory(true)
            if lib.progressCircle({
                duration = Config.CoreSettings.Timers.CollectPresent,
                label = Config.Language.ProgressBar.CollectPresent,
                position = 'bottom',
                useWhileDead = false,
                canCancel = true,
                disable = { car = true, move = true, combat = true, },
                anim = {
                    dict = Config.Animations.CollectPresent.AnimDict,
                    clip = Config.Animations.CollectPresent.Anim,
                    flag = Config.Animations.CollectPresent.Flags,
                },
                prop = {
                    model = Config.Animations.CollectPresent.Prop,
                    pos = Config.Animations.CollectPresent.Pos,
                    rot = Config.Animations.CollectPresent.Rot,
                    bone = Config.Animations.CollectPresent.Bone,
                },
            }) then
                local presentCoords = GetEntityCoords(nearbyObject)
                TriggerServerEvent('lusty94_xmas:server:CollectPresent', vector3(coords.x, coords.y, coords.z), vector3(presentCoords.x, presentCoords.y, presentCoords.z))
                SetEntityAsMissionEntity(nearbyObject, false, true)
                DeleteObject(nearbyObject)
                spawnedPresents[nearbyID] = nil
                if Config.CoreSettings.Blips.Presents then
                    if presentBlips[nearbyObject] then
                        RemoveBlip(presentBlips[nearbyObject])
                        presentBlips[nearbyObject] = nil
                    end
                end
                busy = false
                LockInventory(false)
            else
                busy = false
                LockInventory(false)
                SendNotify(Config.Language.Notifications.Cancelled, 'error', 2000)
            end
        end
    end
end


--open christmas presents
function openPresents()
    local playerPed = PlayerPedId()
    local requiredItems = {"xmaspresent"}
    local requiredAmount = 1 -- dont touch
    if busy then
        SendNotify(Config.Language.Notifications.Busy, 'error', 2000)
    else
        QBCore.Functions.TriggerCallback('lusty94_xmas:getPlayerItemAmount', function(amounts)
            if amounts then
                local minAmount = math.min(math.floor(amounts[1] / requiredAmount))
                local input = lib.inputDialog('Open Christmas Presents', {
                    { type = 'input', placeholder = 'How many do you want to open?', icon = 'question', disabled = true },
                    { type = 'slider', required = true, default = 1, min = 1, max = minAmount },
                    { type = 'input', placeholder = 'You have: ' .. amounts[1] .. ' presents', icon = 'bars', disabled = true },
                })
                if input then
                    local amount = tonumber(input[2])
                    if amount and amount > 0 then
                        QBCore.Functions.TriggerCallback('lusty94_xmas:get:Presents', function(HasItems)
                            if HasItems then
                                busy = true
                                LockInventory(true)
                                if lib.progressCircle({
                                    duration = 3000 * amount, -- edit processing timer here
                                    label = Config.Language.ProgressBar.OpenPresents,
                                    position = 'bottom',
                                    useWhileDead = false,
                                    canCancel = true,
                                    disable = { car = true, move = true },
                                    anim = {
                                        dict = Config.Animations.OpenPresents.AnimDict,
                                        clip = Config.Animations.OpenPresents.Anim,
                                        flag = Config.Animations.OpenPresents.Flags,
                                    },
                                }) then
                                    if Config.CoreSettings.Sound.Enabled then
                                        TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 10, Config.CoreSettings.Sound.ChristmasCheer, 0.5)
                                    end
                                    TriggerServerEvent('lusty94_xmas:server:OpenPresents', amount)
                                    busy = false
                                    LockInventory(false)
                                else
                                    busy = false
                                    LockInventory(false)
                                    SendNotify(Config.Language.Notifications.Cancelled, 'error', 2000)
                                end
                            else
                                SendNotify(Config.Language.Notifications.NotEnough, 'error', 2000)
                            end
                        end, amount)
                    else
                        SendNotify(Config.Language.Notifications.InvalidAmount, 'error', 2000)
                    end
                else
                    SendNotify(Config.Language.Notifications.Cancelled, 'error', 2000)
                end
            else
                SendNotify('You need at least ' .. requiredAmount .. ' christmas present to do that!', 'error', 3000)
            end
        end, requiredItems)
    end
end


--use teddy bear
RegisterNetEvent('lusty94_xmas:client:ChristmasTeddy', function()
    local playerPed = PlayerPedId()
    local dict = 'anim@heists@box_carry@'
    local anim = 'idle'
    if bearSpawned then
        ClearPedTasks(playerPed)
        RemoveAnimDict(dict)
        DeleteObject(bearProp)
        bearSpawned = false
        return
    end
    local bear = 'v_club_vu_bear'
    lib.requestModel(bear, 10000)
    bearProp = CreateObject(bear, GetEntityCoords(PlayerPedId()), true, false, false)
    SetModelAsNoLongerNeeded(bearProp)
    bearSpawned = true
    AttachEntityToEntity(bearProp, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 18905), 0.2, -0.05, 0.1, -135.0, 90.0, 0.0, true, true, false, false, 1, true)
    lib.requestAnimDict(dict, 10000)
    TaskPlayAnim(playerPed, dict, anim, 1.0, -1.0, 1.0, 49, 0, 0, 0, 0)
end)


--food effects
function xmasFoodEffects()
    local playerPed = PlayerPedId()
    local health = Config.CoreSettings.Buffs.Health.Enabled
    local healthAmount = Config.CoreSettings.Buffs.Health.Amount
    local armour = Config.CoreSettings.Buffs.Armour.Enabled
    local armourAmount = Config.CoreSettings.Buffs.Armour.Amount
    local stress = Config.CoreSettings.Buffs.Stress.Enabled
    local stressAmount = Config.CoreSettings.Buffs.Stress.Amount
    if health then
        SetEntityHealth(playerPed, GetEntityHealth(playerPed) + healthAmount)
    end
    if armour then
        AddArmourToPed(playerPed, armourAmount)
    end
    if stress then
        TriggerServerEvent('hud:server:RelieveStress', stressAmount) -- change this event name to suit your hud if required
    end
end


--eat food items
RegisterNetEvent('lusty94_xmas:client:eatFood', function(itemName)
    if busy then
        SendNotify(Config.Language.Notifications.Busy, 'error', 2000)
    else
        busy = true
        LockInventory(true)
        if lib.progressCircle({
            duration = 5000,
            label = 'Eating '..ItemLabel(itemName),
            position = 'bottom',
            useWhileDead = false,
            canCancel = true,
            disable = { car = false, move = false, },
            anim = { 
                dict = Config.XmasTreats[itemName].AnimDict, 
                clip = Config.XmasTreats[itemName].Anim, 
                flag = Config.XmasTreats[itemName].Flag,
            },
            prop = { 
                model = Config.XmasTreats[itemName].Prop, 
                bone = Config.XmasTreats[itemName].Bone, 
                pos = Config.XmasTreats[itemName].Pos, 
                rot = Config.XmasTreats[itemName].Rot,
            },
        }) then
            TriggerServerEvent("lusty94_xmas:server:eatFood", itemName)
            TriggerServerEvent("consumables:server:addHunger", QBCore.Functions.GetPlayerData().metadata["hunger"] + Config.XmasTreats[itemName].Replenish)
            busy = false
            LockInventory(false)
            xmasFoodEffects()
        else 
            busy = false
            LockInventory(false)
            SendNotify(Config.Language.Notifications.Cancelled, 'error', 2000)
        end
    end
end)


--lock inventory to prevent exploits
function LockInventory(toggle)
	if toggle then
        LocalPlayer.state:set("inv_busy", true, true)
    else 
        LocalPlayer.state:set("inv_busy", false, true)
    end
end

--get the label of an item for progressCircle
function ItemLabel(label)
	if InvType == 'ox' then
		local Items = exports['ox_inventory']:Items()
		return Items[label]['label']
    elseif InvType == 'qb' then
		return QBCore.Shared.Items[label]['label']
	end
end

--onstart
AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() == resourceName) then
		spawnPresents()
        spawnSnowmen()
    end
end)

--onLoad
RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    -- on player load delete objects that are already spawned, empty the objects table and then respawn them to prevent duplications
    for _, v in pairs(spawnedPresents) do SetEntityAsMissionEntity(v, false, true) DeleteObject(v) SetEntityAsNoLongerNeeded(v) end
    spawnedPresents = {}
    spawnPresents()
    for _, v in pairs(spawnedSnowmen) do SetEntityAsMissionEntity(v, false, true) DeleteObject(v) SetEntityAsNoLongerNeeded(v) end
    spawnedSnowmen = {}
    spawnSnowmen()
end)

--onStop
AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		busy = false
		LockInventory(false)
		for _, v in pairs(spawnedPresents) do SetEntityAsMissionEntity(v, false, true) DeleteObject(v) end
        for _, v in pairs(spawnedSnowmen) do SetEntityAsMissionEntity(v, false, true) DeleteObject(v) SetEntityAsNoLongerNeeded(v) end
        spawnedPresents = {}
        spawnedSnowmen = {}
        if TargetType == 'qb' then exports['qb-target']:RemoveTargetEntity(presents, 'presents') elseif TargetType == 'ox' then exports.ox_target:removeLocalEntity(presents, 'presents') end
        if TargetType == 'qb' then exports['qb-target']:RemoveTargetEntity(snowmen, 'snowmen') elseif TargetType == 'ox' then exports.ox_target:removeLocalEntity(snowmen, 'snowmen') end
		print('^5--<^3!^5>-- ^7| Lusty94 |^5 ^5--<^3!^5>--^7 Xmas V1.0.0 Stopped Successfully ^5--<^3!^5>--^7')
	end
end)  