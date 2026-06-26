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

-- Notifications
local function Notify(message, notificationType)
    notificationType = notificationType or 'inform'

    if Config.Notifications.System == 'ox' and lib then
        lib.notify({
            title = Config.Resource.Brand or 'Pigeon Studios Group',
            description = message,
            type = notificationType,
            position = 'center-right'
        })

        return
    end

    if Config.Notifications.System == 'qbcore' and Framework then
        Framework.Functions.Notify(message, notificationType)
        return
    end

    if Config.Notifications.System == 'esx' and Framework then
        Framework.ShowNotification(message)
        return
    end

    print(('[CLIENT NOTIFY] %s'):format(message))
end

-- Debug Helpers
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

-- Client Initialisation
local function InitialiseClient()
    if initialized then
        return
    end

    initialized = true

    LoadFramework()

    Debug('Client framework loaded.')
    Info('Client initialised successfully.')
end

CreateThread(function()
    Wait(500)
    InitialiseClient()
end)

-- Resource Lifecycle
AddEventHandler('onClientResourceStart', function(startedResource)
    if startedResource ~= resourceName then
        return
    end

    InitialiseClient()
end)

AddEventHandler('onClientResourceStop', function(stoppedResource)
    if stoppedResource ~= resourceName then
        return
    end

    Debug('Client stopped.')
end)

-- Example Event
RegisterNetEvent('pigeon-fivem-template:client:notify', function(message, notificationType)
    if type(message) ~= 'string' or message == '' then
        return
    end

    Notify(message, notificationType)
end)

-- Exports
exports('Notify', Notify)
exports('Debug', Debug)
