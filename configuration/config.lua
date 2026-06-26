Config = {}

-- Resource Information
Config.Resource = {
    Name = 'pigeon-fivem-template',
    Brand = 'Pigeon Studios Group',
    Debug = false
}

-- Framework Settings
Config.Framework = {
    Type = 'qbcore'
    -- Supported:
    -- 'qbcore'
    -- 'qbox'
    -- 'esx'
    -- 'standalone'
}

-- Notification Settings
Config.Notifications = {
    System = 'ox'
    -- Supported:
    -- 'ox'
    -- 'qbcore'
    -- 'esx'
    -- 'custom'
}

-- Target Settings
Config.Target = {
    System = 'ox_target'
    -- Supported:
    -- 'ox_target'
    -- 'qb-target'
    -- 'custom'
}

-- Inventory Settings
Config.Inventory = {
    System = 'ox_inventory'
    -- Supported:
    -- 'ox_inventory'
    -- 'qb-inventory'
    -- 'qs-inventory'
    -- 'custom'
}

-- Locale Settings
Config.Locale = {
    Default = 'en'
}

-- Logging Settings
Config.Logging = {
    Enabled = true,

    Webhooks = {
        Main = '',
        Errors = '',
        Security = ''
    }
}

-- Validation Settings
Config.Validation = {
    Enabled = true,
    StrictMode = true
}

-- Performance Settings
Config.Performance = {
    OptimizedLoops = true,
    CacheTimeout = 30000
}

-- Developer Settings
Config.Developer = {
    DebugPrints = false,
    VerboseLogging = false
}

-- Feature Flags
Config.Features = {
    Enabled = true
}

-- Utility Functions
Pigeon = {}

function Pigeon.Debug(message)
    if not Config.Resource.Debug then
        return
    end

    print(('[DEBUG] %s'):format(message))
end

function Pigeon.Info(message)
    print(('[INFO] [%s] %s'):format(Config.Resource.Name, message))
end

function Pigeon.Error(message)
    print(('[ERROR] [%s] %s'):format(Config.Resource.Name, message))
end
