local QBCore = exports['qb-core']:GetCoreObject()
local NotifyType = Config.CoreSettings.Notify.Type
local InvType = Config.CoreSettings.Inventory.Type


--useable items for eating
for k, v in pairs(Config.XmasTreats) do
    QBCore.Functions.CreateUseableItem(k, function(source, item)
        TriggerClientEvent('lusty94_xmas:client:eatFood', source, item.name)
    end)
end

--useable teddy
QBCore.Functions.CreateUseableItem('xmasteddy', function(source, item)
    TriggerClientEvent('lusty94_xmas:client:ChristmasTeddy', source)
end)

--notification function
local function SendNotify(src, msg, type, time, title)
    if NotifyType == nil then print('Lusty94_Xmas: NotifyType Not Set in Config.CoreSettings.Notify.Type!') return end
    if not title then title = 'Xmas' end
    if not time then time = 5000 end
    if not type then type = 'success' end
    if not msg then print('Notification Sent With No Message') return end
    if NotifyType == 'qb' then
        TriggerClientEvent('QBCore:Notify', src, msg, type, time)
    elseif NotifyType == 'okok' then
        TriggerClientEvent('okokNotify:Alert', src, title, msg, time, type, Config.CoreSettings.Notify.Sound)
    elseif NotifyType == 'mythic' then
        TriggerClientEvent('mythic_notify:client:SendAlert', src, { type = type, text = msg, style = { ['background-color'] = '#00FF00', ['color'] = '#FFFFFF' } })
    elseif NotifyType == 'ox' then 
        TriggerClientEvent('ox_lib:notify', src, ({ title = title, description = msg, length = time, type = type, style = 'default'}))
    end
end

--remove items
local function removeItem(src, item, amount)
    if InvType == 'qb' then
        if exports['qb-inventory']:RemoveItem(src, item, amount, false, false, false) then
            TriggerClientEvent('qb-inventory:client:ItemBox', src, QBCore.Shared.Items[item], 'remove', amount)
        end
    elseif InvType == 'ox' then
        exports.ox_inventory:RemoveItem(src, item, amount)
    elseif Invtype == 'custom' then
        --add your own inventory support here following the format above
    end
end

--add items
local function addItem(src, item, amount)
    if InvType == 'qb' then
        if exports['qb-inventory']:AddItem(src, item, amount, false, false, false) then
            TriggerClientEvent('qb-inventory:client:ItemBox', src, QBCore.Shared.Items[item], 'add', amount)
        end
    elseif InvType == 'ox' then
        if exports.ox_inventory:CanCarryItem(src, item, amount) then
            exports.ox_inventory:AddItem(src, item, amount)
        else
            SendNotify(src, Config.Language.Notifications.CantCarry, 'error', 5000)
        end
    elseif Invtype == 'custom' then
        --add your own inventory support here following the format above
    end
end

--add money
local function addMoney(src, account, amount)
    local Player = QBCore.Functions.GetPlayer(src)
    if Player then
        if InvType == 'qb' then
            Player.Functions.AddMoney(account, amount)
        elseif InvType == 'ox' then
            if exports.ox_inventory:CanCarryItem(src, account, amount) then
                exports.ox_inventory:AddItem(src, account, amount)
            else
                SendNotify(src, Config.Language.Notifications.CantCarry, 'error', 5000)
            end
        end
    end
end


--Gets the amount of a specific item in the player's inventory -- dont touch this its used to display data in the processing menus
QBCore.Functions.CreateCallback('lusty94_xmas:getPlayerItemAmount', function(source, cb, requiredItems)
    local Player = QBCore.Functions.GetPlayer(source)
    local hasAllItems = true
    local amounts = {}
    if Player then
        for _, item in pairs(requiredItems) do
            local playerItem = Player.Functions.GetItemByName(item)
            if not playerItem or playerItem.amount < 1 then
                hasAllItems = false
                break
            else
                table.insert(amounts, playerItem.amount)
            end
        end
    else
        hasAllItems = false
    end    
    if hasAllItems then
        cb(amounts) -- Returns table of item amounts
    else
        cb(false)
    end
end)


--presents callback
QBCore.Functions.CreateCallback('lusty94_xmas:get:Presents', function(source, cb, amount)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local item = Player.Functions.GetItemByName('xmaspresent')
    if item and item.amount >= amount then
        cb(true)
    else
        cb(false)
    end
end)


--collect a present
RegisterServerEvent('lusty94_xmas:server:CollectPresent', function(playerCoords, presentCoords)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player then
        local distance = #(playerCoords - presentCoords)
        local threshold = Config.CoreSettings.Security.MaxDist
        if distance > threshold then
            if Config.CoreSettings.Security.KickPlayer then
                DropPlayer(src, 'Kicked: Distance validation failed while collecting a present!')
            end
            if Config.CoreSettings.Security.Prints then
                print(string.format('^2[Lusty94_Xmas]^7: ^3 Failed Distance Check! ^7 ^1 Server ID: ^2^7 ^2 ' ..src.. '^7^3 Collected A Present From Outside The Maximum Threshold! ^7'))
                print(string.format('^2[Lusty94_Xmas]^7: ^3 Player Distance: ^1%.2f^7 (Threshold: %.2f)', distance, threshold))
            end
        else
            if Config.CoreSettings.Chances.GetPresent >= math.random(1,100) then
                addItem(src, 'xmaspresent', 1)
            else
                addItem(src, 'coal', math.random(1,4))
                SendNotify(src, Config.Language.Notifications.GoatCoal, 'error', 5000)
            end
        end
    end
end)




--open presents
RegisterServerEvent('lusty94_xmas:server:OpenPresents', function(amount)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local requiredAmount = 1 -- dont touch
    local items = { 'xmascookie', 'xmascandycane', 'xmasteddy', 'xmasmincepie', 'xmasgingerbread' } -- add or remove items here found in presents
    local returnAmount = math.random(1, 2) -- edit amount of items you receive from EACH here so dont set too high
    if Player then
        removeItem(src, 'xmaspresent', requiredAmount * amount)
        Wait(500)
        for _, v in pairs(items) do
            Wait(250)
            addItem(src, v, returnAmount * amount)
        end
        if Config.CoreSettings.Chances.CashInPresents >= math.random(1,100) then
            addMoney(src, 'cash', math.random(100,250)) -- ox_inventory users change 'cash' to 'money'
            SendNotify(src, Config.Language.Notifications.FoundCash, 'success', 5000)
        end
    end
end)


--eat food
RegisterServerEvent('lusty94_xmas:server:eatFood', function(item)
    local src = source
    local Player = QBCore.Functions.GetPlayer(source)
    if Player then
        local xmasFood = nil
        for k in pairs(Config.XmasTreats) do
            if k == item then
                xmasFood = k
                break
            end
        end
        if not xmasFood then return end
        removeItem(src, xmasFood, 1)
    end
end)



--------------< VERSION CHECK >-------------

local function CheckVersion()
    PerformHttpRequest('https://raw.githubusercontent.com/Lusty94/UpdatedVersions/main/Xmas/version.txt', function(err, newestVersion, headers)
        local currentVersion = GetResourceMetadata(GetCurrentResourceName(), 'version')
        if not newestVersion then
            print('^1[Lusty94_Xmas]^7: Unable to fetch the latest version.')
            return
        end

        newestVersion = newestVersion:gsub('%s+', '')
        currentVersion = currentVersion and currentVersion:gsub('%s+', '') or 'Unknown'

        if newestVersion == currentVersion then
            print(string.format('^2[Lusty94_Xmas]^7: ^6You are running the latest version.^7 (^2v%s^7)', currentVersion))
        else
            print(string.format('^2[Lusty94_Xmas]^7: ^3Your version: ^1v%s^7 | ^2Latest version: ^2v%s^7\n^1Please update to the latest version | Changelogs can be found in the support discord.^7', currentVersion, newestVersion))
        end
    end)
end

CheckVersion()