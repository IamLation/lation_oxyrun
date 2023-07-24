-- Get framework
if GetResourceState('es_extended') == 'started' then
    ESX = exports['es_extended']:getSharedObject()
    Framework = 'esx'
elseif GetResourceState('qb-core') == 'started' then
    QBCore = exports['qb-core']:GetCoreObject()
    Framework = 'qb'
else
    -- Add support for a custom framework here
    return
end

-- Get player from source
GetPlayer = function(source)
    if Framework == 'esx' then
        return ESX.GetPlayerFromId(source)
    elseif Framework == 'qb' then
        return QBCore.Functions.GetPlayer(source)
    else
        -- Add support for a custom framework here
    end
end

-- Get player's name from source
GetName = function(source)
    local player = GetPlayer(source)
    if player then
        if Framework == 'esx' then
            return player.getName()
        elseif Framework == 'qb' then
            return player.PlayerData.charinfo.firstname..' '..player.PlayerData.charinfo.lastname
        end
    end
end

-- Get a players identifier
GetIdentifier = function(source)
    local player = GetPlayer(source)
    if player then
        if Framework == 'esx' then
            return player.identifier
        elseif Framework == 'qb' then
            return player.PlayerData.citizenid
        end
    end
end

-- Function to register a usable item
RegisterUsableItem = function(item, ...)
    if Framework == 'esx' then
        ESX.RegisterUsableItem(item, ...)
    elseif Framework == 'qb' then
        QBCore.Functions.CreateUseableItem(item, ...)
    else
        -- Add support for a custom framework here
    end
end

RemoveMoney = function(source, moneyType, amount)
    local player = GetPlayer(source)
    moneyType = ConvertMoneyType(moneyType)
    if player then
        if Framework == 'esx' then
            player.removeAccountMoney(moneyType, amount)
        elseif Framework == 'qb' then
            player.Functions.RemoveMoney(moneyType, amount)
        end
    end
end

ConvertMoneyType = function(moneyType)
    if moneyType == 'money' and Framework == 'qb' then
        moneyType = 'cash'
    elseif moneyType == 'cash' and Framework == 'esx' then
        moneyType = 'money'
    end
    return moneyType
end

GetPlayerAccountFunds = function(source, moneyType)
    local player = GetPlayer(source)
    moneyType = ConvertMoneyType(moneyType)
    if Framework == 'qb' then
        return player.PlayerData.money[moneyType]
    elseif Framework == 'esx' then
        return player.getAccount(moneyType).money
    end
end