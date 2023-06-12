local ox_target = exports.ox_target
local startOxyRun = lib.points.new(Config.StartOxyRunLocation, Config.StartOxyRunPedRadius)
local missionActive = false
local getPharmacies = math.random(1, #Config.PharmacyLocations)
local selectPharmacy = Config.PharmacyLocations[getPharmacies]
local doctorList = {}
local startOxyRunOptions = {
    {
        name = 'startOxyRun',
        icon = Target.startOxyRunIcon,
        label = Target.startOxyRunLabel,
        distance = 2,
        onSelect = function()
            if Config.RequireItem then
                local hasItem = lib.callback.await('lation_oxyrun:hasItem', source, Config.RequireItemName)
                if hasItem >= Config.RequireItemAmount then
                    startOxyRunDialog()
                else
                    lib.notify({ title = Notifications.startOxyRunPedName, description = Notifications.startOxyRunDidntHaveItemDescription, type = 'error', icon = Notifications.icon, position = Notifications.position })
                end
            else
                startOxyRunDialog()
            end
        end
    }
}

AddEventHandler('onResourceRestart', function(resource)
	if resource == GetCurrentResourceName() then
        missionActive = false
	end
end)

-- Spawns the mission start ped when player enters the defined area
function startOxyRun:onEnter()
    spawnStartOxyRunPed()
    ox_target:addLocalEntity(startOxyRunPed, startOxyRunOptions)
end

-- Deletes the mission start ped when player exits the defined area
function startOxyRun:onExit()
    DeleteEntity(startOxyRunPed)
    ox_target:removeLocalEntity(startOxyRunPed, nil)
end

-- Function that handles the actual spawning of the ped, etc
function spawnStartOxyRunPed()
    lib.RequestModel(Config.startOxyRunPedModel)
    startOxyRunPed = CreatePed(0, Config.startOxyRunPedModel, Config.StartOxyRunLocation, Config.StartOxyRunPedHeading, false, true)
    FreezeEntityPosition(startOxyRunPed, true)
    SetBlockingOfNonTemporaryEvents(startOxyRunPed, true)
    SetEntityInvincible(startOxyRunPed, true)
    Entity(startOxyRunPed).state:set("sellDrugs", true, true) -- disables sell drugs option on peds
end

-- The initial dialog that is encountered when starting the mission
function startOxyRunDialog()
    if missionActive then return lib.notify({ title = Notifications.startOxyRunPedName, description = Notifications.startOxyRunAlreadyStarted, type = 'error', icon = Notifications.icon, position = Notifications.position }) end
    local startOxyRunAlert = lib.alertDialog({
        header = AlertDialog.startOxyRunHeader,
        content = AlertDialog.startOxyRunContent,
        centered = true,
        cancel = true,
        labels = {
            confirm = AlertDialog.startOxyRunConfirm,
            cancel = AlertDialog.startOxyRunCancel
        }
    })
    if startOxyRunAlert == 'confirm' then
        if Config.RandomBlankPrescriptionPricing then
            local blankPrescriptionPrice = math.random(Config.MinBlankPrescriptionPrice, Config.MaxBlankPrescriptionPrice)
            local confirmStartOxyRun = lib.alertDialog({
                header = AlertDialog.startOxyRunPart2Header,
                content = AlertDialog.startOxyRunPart2Content .. blankPrescriptionPrice ..' sound?',
                centered = true,
                cancel = true,
                labels = {
                    confirm = AlertDialog.startOxyRunPart2Confirm,
                    cancel = AlertDialog.startOxyRunPart2Cancel
                }
            })
            if confirmStartOxyRun == 'confirm' then
                lib.callback.await('lation_oxyrun:startOxyRun', source, blankPrescriptionPrice)
                missionActive = true
            else
                lib.notify({ title = Notifications.startOxyRunPedName, description = Notifications.startOxyRunPart2CancelDescription, type = 'error', icon = Notifications.icon, position = Notifications.position })
            end
        else
            local confirmStartOxyRunNotRandom = lib.alertDialog({
                header = AlertDialog.startOxyRunPart2Header,
                content = AlertDialog.startOxyRunPart2Content .. Config.BlankPrescriptionPrice ..' sound?',
                centered = true,
                cancel = true,
                labels = {
                    confirm = AlertDialog.startOxyRunPart2Confirm,
                    cancel = AlertDialog.startOxyRunPart2Cancel
                }
            })
            if confirmStartOxyRunNotRandom == 'confirm' then
                lib.callback.await('lation_oxyrun:startOxyRun', source, Config.BlankPrescriptionPrice)
                missionActive = true
            else
                lib.notify({ title = Notifications.startOxyRunPedName, description = Notifications.startOxyRunPart2CancelDescription, type = 'error', icon = Notifications.icon, position = Notifications.position })
            end
        end
    else
        lib.notify({ title = Notifications.startOxyRunPedName, description = Notifications.startOxyRunCancelDescription, type = 'error', icon = Notifications.icon, position = Notifications.position })
    end
end

-- The callback that displays an input dialog for the player to input information and returns it to the server
lib.callback.register('lation_oxyrun:fillPrescriptionInfo', function(source)
    local inputData = lib.inputDialog(InputDialog.header, {
        {type = 'input', label = InputDialog.nameLabel, description = InputDialog.nameDescription, icon = InputDialog.nameIcon, required = true, min = 5, max = 25},
        {type = 'input', label = InputDialog.addressLabel, description = InputDialog.addressDescription, placeholder = InputDialog.addressPlaceholder, icon = InputDialog.addressIcon, required = true, min = 10, max = 40},
        {type = 'checkbox', label = InputDialog.firstCheckboxLabel},
        {type = 'checkbox', label = InputDialog.secondCheckboxLabel},
        {type = 'date', label = InputDialog.dobLabel, icon = InputDialog.dobIcon, default = true, format = InputDialog.dobFormat, required = true},
        {type = 'input', label = InputDialog.doctorLabel, description = InputDialog.doctorDescription, icon = InputDialog.doctorIcon, required = true, min = 5, max = 25}
    })
    return inputData
end)

-- Alerts the player the script they are handing in is a fake
lib.callback.register('lation_oxyrun:fakeScript', function(source)
    lib.alertDialog({
        header = AlertDialog.fakeScriptHeader,
        content = AlertDialog.fakeScriptContent,
        centered = true,
        cancel = false
    })
end)

-- Creates the target option at a randomly selected Pharymacy from the Config
ox_target:addSphereZone({
    coords = selectPharmacy,
    radius = 1,
    debug = false,
    options = {
        {
            name = 'randomPharmacy',
            icon = Target.fillScriptIcon,
            label = Target.fillScriptLabel,
            canInteract = function()
                if missionActive then
                    return true
                else
                    return false
                end
            end,
            onSelect = function()
                local hasItem = lib.callback.await('lation_oxyrun:hasItem', source, Config.SignedPerscription)
                if hasItem >= 1 then
                    if lib.progressCircle({
                        label = ProgressCircle.checkingScriptLabel,
                        duration = ProgressCircle.checkingScriptDuration,
                        position = ProgressCircle.checkingScriptPosition,
                        useWhileDead = false,
                        canCancel = true,
                        disable = {
                            car = true,
                            move = true,
                            combat = true,
                        }
                    }) then
                        lib.callback.await('lation_oxyrun:getItemMetadata', source, item)
                        missionActive = false
                    else
                        lib.notify({ title = Notifications.pharmacyTitle, description = Notifications.pharmacyDescription, icon = Notifications.icon, type = 'error', position = Notifications.position })
                    end
                else
                    lib.notify({ title = Notifications.pharmacyTitle, description = Notifications.pharmacyItemNotFound, icon = Notifications.icon, type = 'error', position = Notifications.position })
                end
            end
        }
    }
})

-- Loops the available Doctor Names from the Config to display neatly in a menu
for k, v in pairs(Config.DoctorNames) do
    doctorList[k] = {
        title = v,
        icon = ContextMenu.availableDoctorsIcon
    }
end

-- Target zone for opening and viewing the available Doctor Names
ox_target:addSphereZone({
    coords = Config.AvailableDoctorListLocation,
    radius = 1,
    debug = false,
    options = {
        {
            name = 'availableDoctors',
            icon = Target.availableDoctorsIcon,
            label = Target.availableDoctors,
            onSelect = function()
                lib.registerContext({
                    id = 'availableDoctorsMenu',
                    title = ContextMenu.availableDoctorsMenuTitle,
                    options = doctorList
                    })
                lib.showContext('availableDoctorsMenu')
            end
        }
    }
})

-- The event for opening the Oxy Bottle, returns if opened or not
lib.callback.register('lation_oxyrun:openOxyBottle', function(source, result)
    local result = nil
    if lib.progressCircle({
        label = ProgressCircle.openOxyBottleLabel,
        duration = ProgressCircle.openOxyBottleDuration,
        position = ProgressCircle.position,
        useWhileDead = false,
        canCancel = true,
        anim = { dict = 'missheistfbisetup1', clip = 'hassle_intro_loop_f', flag = 3 },
    }) then
        result = true
        return result
    else
        result = false
        return result
    end
end)

-- The event for using/consuming an oxycontin, returns if opened or not
lib.callback.register('lation_oxyrun:useOxycontin', function(source, result)
    local result = nil
    if lib.progressCircle({
        label = ProgressCircle.poppingOxyLabel,
        duration = ProgressCircle.poppingOxyDuration,
        position = ProgressCircle.position,
        useWhileDead = false,
        canCancel = true,
        anim = { dict = 'mp_suicide', clip = 'pill' },
    }) then
        result = true
        return result
    else
        result = false
        return result
    end
end)

-- The event if effects are enabled, this one is for setting health
lib.callback.register('lation_oxyrun:setPedHealth', function(source)
    SetEntityHealth(cache.ped, Config.EnableEffects.health.amount or 0)
end)

-- The event if effects are enabled, this one is for setting armor
lib.callback.register('lation_oxyrun:setPedArmor', function(source)
    SetPedArmour(cache.ped, Config.EnableEffects.armor.amount or 0)
end)