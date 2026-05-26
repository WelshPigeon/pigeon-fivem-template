local resourceName = GetCurrentResourceName()
local initialized = false

-- Framework Cache
local Framework = nil

local function LoadFramework()
    local frameworkType = Config.Framework.Type

    if frameworkType == 'qbox' and GetResourceState('qbx_core') == 'started' then
        Framework = exports.qbx_core
        return
    end

    if frameworkType == 'qbcore' and GetResourceState('qb-core') == 'started' then
        Framework = exports['qb-core']:GetCoreObject()
        return
    end

    if frameworkType == 'esx' and GetResourceState('es_extended') == 'started' then
        Framework = exports.es_extended:getSharedObject()
        return
    end

    Framework = nil
end

-- Logging Helpers
local function Debug(message)
    if not Config.Resource.Debug then
        return
    end

    print(('[DEBUG] [%s] %s'):format(resourceName, tostring(message)))
end

local function Info(message)
    print(('[INFO] [%s] %s'):format(resourceName, tostring(message)))
end

local function Error(message)
    print(('[ERROR] [%s] %s'):format(resourceName, tostring(message)))
end

-- Validation Helpers
local function IsValidSource(source)
    return source
        and type(source) == 'number'
        and source > 0
        and GetPlayerName(source) ~= nil
end

local function IsValidString(value)
    return type(value) == 'string'
        and value ~= ''
end

-- Notification Helper
local function Notify(source, message, notificationType)
    if not IsValidSource(source) then
        return
    end

    if not IsValidString(message) then
        return
    end

    notificationType = notificationType or 'inform'

    if Config.Notifications.System == 'ox' then
        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Pigeon Studios',
            description = message,
            type = notificationType,
            position = 'center-right'
        })

        return
    end

    if Config.Notifications.System == 'qbcore' then
        TriggerClientEvent('QBCore:Notify', source, message, notificationType)
        return
    end

    if Config.Notifications.System == 'esx' then
        TriggerClientEvent('esx:showNotification', source, message)
        return
    end

    TriggerClientEvent('pigeon-fivem-template:client:notify', source, message, notificationType)
end

-- Server Initialisation
local function InitialiseServer()
    if initialized then
        return
    end

    initialized = true

    LoadFramework()

    Debug('Server framework loaded.')
    Info('Server initialised successfully.')
end

CreateThread(function()
    Wait(500)
    InitialiseServer()
end)

-- Resource Lifecycle
AddEventHandler('onResourceStart', function(startedResource)
    if startedResource ~= resourceName then
        return
    end

    InitialiseServer()
end)

AddEventHandler('onResourceStop', function(stoppedResource)
    if stoppedResource ~= resourceName then
        return
    end

    Debug('Server stopped.')
end)

-- Example Secure Server Event
RegisterNetEvent('pigeon-fivem-template:server:ping', function()
    local source = source

    if not IsValidSource(source) then
        return
    end

    Notify(source, 'Server connection validated.', 'success')
end)

-- Exports
exports('Notify', Notify)
exports('Debug', Debug)
exports('Info', Info)
exports('Error', Error)