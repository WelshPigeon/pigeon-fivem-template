PigeonShared = {}

-- Resource Information
PigeonShared.Resource = {
    Name = GetCurrentResourceName(),
    Author = 'Pigeon Studios'
}

-- Framework Detection
PigeonShared.Framework = {}

function PigeonShared.Framework.Get()
    if GetResourceState('qbx_core') == 'started' then
        return 'qbox'
    end

    if GetResourceState('qb-core') == 'started' then
        return 'qbcore'
    end

    if GetResourceState('es_extended') == 'started' then
        return 'esx'
    end

    return 'standalone'
end

-- Notification Helper
function PigeonShared.Notify(source, message, notificationType)
    notificationType = notificationType or 'inform'

    local system = Config.Notifications.System

    if system == 'ox' then
        if source then
            TriggerClientEvent('ox_lib:notify', source, {
                description = message,
                type = notificationType
            })

            return
        end

        lib.notify({
            description = message,
            type = notificationType
        })

        return
    end

    if system == 'qbcore' then
        if source then
            TriggerClientEvent('QBCore:Notify', source, message, notificationType)
            return
        end

        return
    end

    if system == 'esx' then
        if source then
            TriggerClientEvent('esx:showNotification', source, message)
            return
        end

        return
    end

    print(('[NOTIFY] %s'):format(message))
end

-- String Helpers
function PigeonShared.Trim(value)
    return tostring(value or '')
        :gsub('^%s*(.-)%s*$', '%1')
end

function PigeonShared.StartsWith(value, start)
    return value:sub(1, #start) == start
end

function PigeonShared.EndsWith(value, ending)
    return ending == ''
        or value:sub(-#ending) == ending
end

-- Table Helpers
function PigeonShared.TableCount(tableData)
    local count = 0

    for _ in pairs(tableData) do
        count += 1
    end

    return count
end

function PigeonShared.TableContains(tableData, value)
    for _, entry in pairs(tableData) do
        if entry == value then
            return true
        end
    end

    return false
end

-- Validation Helpers
function PigeonShared.IsValidString(value)
    return type(value) == 'string'
        and value ~= ''
end

function PigeonShared.IsValidNumber(value)
    return type(value) == 'number'
end

function PigeonShared.IsValidTable(value)
    return type(value) == 'table'
end

-- Debug Helpers
function PigeonShared.Debug(message)
    if not Config.Resource.Debug then
        return
    end

    print(('[DEBUG] [%s] %s'):format(
        PigeonShared.Resource.Name,
        tostring(message)
    ))
end

function PigeonShared.Error(message)
    print(('[ERROR] [%s] %s'):format(
        PigeonShared.Resource.Name,
        tostring(message)
    ))
end

function PigeonShared.Info(message)
    print(('[INFO] [%s] %s'):format(
        PigeonShared.Resource.Name,
        tostring(message)
    ))
end

-- Export Shared Object
exports('GetSharedObject', function()
    return PigeonShared
end)