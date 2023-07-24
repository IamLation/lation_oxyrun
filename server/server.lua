local ox_inventory = exports.ox_inventory
local discordWebhook = Config.WebhookLink
local discordName = Config.WebhookName
local discordImage = Config.WebhookAvatarIcon
local pickADoctor = math.random(1, #Config.DoctorNames)
local selectADoctor = Config.DoctorNames[pickADoctor]

-- Event for Discord webhook logs
function sendToDiscord(name, message, color, timestamp)
    local connect = {
        {
            ["color"] = color,
            ["title"] = "**".. name .."**",
            ["description"] = message,
            ["footer"] = {
                ["text"] = os.date("%a %b %d, %I:%M%p"),
                ["icon_url"] = Config.WebhookFooterIcon
            },
        }
    }
    PerformHttpRequest(discordWebhook, function(err, text, headers) end, 'POST', json.encode({username = discordName, embeds = connect, avatar_url = discordImage}), { ['Content-Type'] = 'application/json' })
end

-- Prints a webhook log displaying the chosen Doctor for this session
if Config.EnableWebhook then
    sendToDiscord('Today\'s Doctor', 'The selected doctor for this session is: **' ..selectADoctor..'**', 65280)
end

-- Event used for checking if the player has a specific item
lib.callback.register('lation_oxyrun:hasItem', function(source, item)
    local hasItem = ox_inventory:Search(source, 'count', item)
    return hasItem
end)

-- Event that officially starts the mission
lib.callback.register('lation_oxyrun:startOxyRun', function(source, price)
    local source = source
    local player = GetPlayer(source)
    local playerName = GetName(source)
    local playerIdentifier = GetIdentifier(source)
    local playerBalance = GetPlayerAccountFunds(source, Config.Money)
    local playerId = player.source or player.PlayerData.source
    if playerBalance < price then
        return false
    else
        ox_inventory:AddItem(playerId, Config.BlankPrescription, Config.BlankPrescriptionRewardAmount)
        ox_inventory:RemoveItem(playerId, Config.Money, price)
        if Config.EnableWebhook then
            sendToDiscord('Blank Prescription', '**'..playerName.. '** (*ID: ' ..playerId.. '*) has purchased a blank prescription for $' ..price.. '  \n **Identifier:** ||*' ..playerIdentifier..'*||', 16776960)
        end
        return true
    end
end)

-- Checks the players manually filled in script with the necessary information and proceeds accordingly
RegisterNetEvent('lation_oxyrun:getItemMetadata')
AddEventHandler('lation_oxyrun:getItemMetadata', function()
    local source = source
    local player = GetPlayer(source)
    local playerName = GetName(source)
    local playerIdentifier = GetIdentifier(source)
    local playerId = player.source or player.PlayerData.source
    local prescriptionData = lib.callback.await('lation_oxyrun:getPrescriptionData', playerId)
    if string.lower(playerName) ~= string.lower(prescriptionData[1]) or string.lower(selectADoctor) ~= string.lower(prescriptionData[6]) or prescriptionData[4] ~= true then
        TriggerClientEvent('lation_oxyrun:fakeScript', playerId)
        ox_inventory:RemoveItem(playerId, Config.SignedPerscription, 1)
        if Config.EnableWebhook then
            sendToDiscord('Fraudulent Prescription', '**' ..playerName.. '** (*ID: ' ..playerId.. '*) has attempted to get a prescription filled but was found to be fraudulent.   \n **Identifier:** ||*' ..playerIdentifier..'*||', 15548997)
        end
    else
        ox_inventory:RemoveItem(playerId, Config.SignedPerscription, 1)
        ox_inventory:AddItem(playerId, Config.OxyBottleItem, Config.OxyBottleQuantity)
        if Config.EnableWebhook then
            sendToDiscord('Successful Prescription', '**' ..playerName.. '** (*ID: ' ..playerId.. '*) has successfully filled their prescription.   \n **Identifier:** ||*' ..playerIdentifier..'*||', 65280)
        end
    end
end)

RegisterUsableItem(Config.BlankPrescription, function(source)
    local source = source
    local player = GetPlayer(source)
    local playerId = player.source or player.PlayerData.source
    local getInputData = lib.callback.await('lation_oxyrun:fillPrescriptionInfo', playerId)
    if getInputData == nil then return end
    local blankPrescription = ox_inventory:Search(playerId, 1, Config.BlankPrescription)
        for _, v in pairs(blankPrescription) do
            blankPrescription = v
            break
        end
    ox_inventory:RemoveItem(playerId, blankPrescription.name, 1)
    blankPrescription.metadata.image = 'signed_prescription'
    blankPrescription.metadata.label = 'Prescription'
    blankPrescription.metadata.description = 'Patient Name: ' ..getInputData[1].. '  \n Patient Address: ' ..getInputData[2].. '  \n Acute Pain: ' ..tostring(getInputData[4]).. '  \n Approving Doctor: ' ..getInputData[6]
    ox_inventory:AddItem(playerId, Config.SignedPerscription, 1, blankPrescription.metadata)
end)

RegisterUsableItem(Config.OxyBottleItem, function(source)
    local source = source
    local player = GetPlayer(source)
    local playerId = player.source or player.PlayerData.source
    local openedBottle = lib.callback.await('lation_oxyrun:openOxyBottle', playerId)
    if openedBottle then
        ox_inventory:RemoveItem(playerId, Config.OxyBottleItem, 1)
        ox_inventory:AddItem(playerId, Config.OxyPillItem, Config.OxyPillQuantity)
    end
end)

RegisterUsableItem(Config.OxyPillItem, function(source)
    local source = source
    local player = GetPlayer(source)
    local playerId = player.source or player.PlayerData.source
    local usedOxycontin = lib.callback.await('lation_oxyrun:useOxycontin', playerId)
    if usedOxycontin then
        ox_inventory:RemoveItem(playerId, Config.OxyPillItem, 1)
        if Config.EnableEffects.enable then
            if Config.EnableEffects.health.enable then
                TriggerClientEvent('lation_oxyrun:setPedHealth', playerId)
            end
            if Config.EnableEffects.armor.enable then
                TriggerClientEvent('lation_oxyrun:setPedArmor', playerId)
            end
            if Config.EnableEffects.speed.enable then
                TriggerClientEvent('lation_oxyrun:applySpeed', playerId)
            end
            if Config.EnableEffects.screenEffect.enable then
                TriggerClientEvent('lation_oxyrun:applyScreenEffect', playerId)
            end
        end
    end
end)