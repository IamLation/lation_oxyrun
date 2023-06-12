local ox_inventory = exports.ox_inventory
local discordWebhook = Config.WebhookLink
local discordName = Config.WebhookName
local discordImage = Config.WebhookAvatarIcon
local pickADoctor = math.random(1, #Config.DoctorNames)
local selectADoctor = Config.DoctorNames[pickADoctor]
local getInputData

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
    local ped = ESX.GetPlayerFromId(source)
    ox_inventory:AddItem(ped.source, Config.BlankPrescription, Config.BlankPrescriptionRewardAmount)
    ox_inventory:RemoveItem(ped.source, Config.Money, price)
    if Config.EnableWebhook then
        sendToDiscord('Blank Prescription', '**'..ped.getName().. '** (*ID: ' ..ped.source.. '*) has purchased a blank prescription for $' ..price.. '  \n **Identifier:** ||*' ..ped.getIdentifier()..'*||', 16776960)
    end
end)

-- Makes the blank_prescription item usable, prompts player to input the information then applies the metadata
ESX.RegisterUsableItem('blank_prescription', function(source)
    local source = source
    local ped = ESX.GetPlayerFromId(source)
    getInputData = lib.callback.await('lation_oxyrun:fillPrescriptionInfo', ped.source)
    if getInputData == nil then return end
    local blankPrescription = ox_inventory:Search(ped.source, 1, Config.BlankPrescription)
        for k, v in pairs(blankPrescription) do
                blankPrescription = v
            break
        end
    ox_inventory:RemoveItem(ped.source, blankPrescription.name, 1)
    blankPrescription.metadata.image = 'signed_prescription'
    blankPrescription.metadata.label = 'Prescription'
    blankPrescription.metadata.description = 'Patient Name: ' ..getInputData[1].. '  \n Patient Address: ' ..getInputData[2].. '  \n Acute Pain: ' ..tostring(getInputData[4]).. '  \n Approving Doctor: ' ..getInputData[6]
    ox_inventory:AddItem(ped.source, Config.SignedPerscription, 1, blankPrescription.metadata)
end)

-- Checks the players manually filled in script with the necessary information and proceeds accordingly
lib.callback.register('lation_oxyrun:getItemMetadata', function(source, item)
    local source = source
    local ped = ESX.GetPlayerFromId(source)
    local playerName = ped.getName()
    if string.lower(playerName) ~= string.lower(getInputData[1]) or string.lower(selectADoctor) ~= string.lower(getInputData[6]) or getInputData[4] ~= true then
        lib.callback.await('lation_oxyrun:fakeScript', source)
        ox_inventory:RemoveItem(ped.source, Config.SignedPerscription, 1)
        if Config.EnableWebhook then
            sendToDiscord('Fraudulent Prescription', '**' ..playerName.. '** (*ID: ' ..ped.source.. '*) has attempted to get a prescription filled but was found to be fraudulent.   \n **Identifier:** ||*' ..ped.getIdentifier()..'*||', 15548997)
        end
    else
        ox_inventory:RemoveItem(ped.source, Config.SignedPerscription, 1)
        ox_inventory:AddItem(ped.source, Config.OxyBottleItem, Config.OxyBottleQuantity)
        if Config.EnableWebhook then
            sendToDiscord('Successful Prescription', '**' ..playerName.. '** (*ID: ' ..ped.source.. '*) has successfully filled their prescription.   \n **Identifier:** ||*' ..ped.getIdentifier()..'*||', 65280)
        end
    end
end)

-- Makes the oxy_bottle item usable and rewards you with individual oxycontin
ESX.RegisterUsableItem('oxy_bottle', function(source)
    local source = source
    local ped = ESX.GetPlayerFromId(source)
    local openedBottle = lib.callback.await('lation_oxyrun:openOxyBottle', source, result)
    if openedBottle then 
        ox_inventory:RemoveItem(ped.source, Config.OxyBottleItem, 1)
        ox_inventory:AddItem(ped.source, Config.OxyPillItem, Config.OxyPillQuantity)
    else
        TriggerClientEvent('ox_lib:notify', ped.source, { title = Notifications.oxyBottleTitle, description = Notifications.oxyBottleDescription, type = 'error', icon = Notifications.icon, position = Notifications.position })
    end
end)

-- Makes the oxycontin itself usable, for features such as health, etc
ESX.RegisterUsableItem('oxycontin', function(source)
    local source = source
    local ped = ESX.GetPlayerFromId(source)
    local usedOxycontin = lib.callback.await('lation_oxyrun:useOxycontin', source, result)
    if usedOxycontin then
        ox_inventory:RemoveItem(ped.source, Config.OxyPillItem, 1)
        if Config.EnableEffects.enable then
            if Config.EnableEffects.health.enable then
                lib.callback.await('lation_oxyrun:setPedHealth', source)
                if Config.EnableEffects.armor.enable then
                    lib.callback.await('lation_oxyrun:setPedArmor', source)
                end
            end
        end
    else
        TriggerClientEvent('ox_lib:notify', ped.source, { title = Notifications.oxycontinTitle, description = Notifications.oxycontinDescription, type = 'error', icon = Notifications.icon, position = Notifications.position })
    end
end)