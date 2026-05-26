local resource = GetCurrentResourceName()

local C = {
    reset = '^7',
    brand = '^5',
    accent = '^3',
    good = '^2',
    bad = '^1',
    warn = '^3',
    link = '^4',
    muted = '^8'
}

local Brand = {
    Name = 'Pigeon Studios',
    Tag = 'Crafted with Precision • Designed for Performance',
    Website = 'https://pigeonstudios.co.uk'
}

local Settings = {
    Enabled = Config.VersionChecker and Config.VersionChecker.Enabled == true,
    ResourceName = Config.Resource and Config.Resource.Name or resource,
    RepositoryOwner = 'WelshPigeon',
    VersionsRepository = 'pigeon-resource-versions',
    Branch = 'main',
    Delay = 1500,
    ChangelogLimit = 6
}

local RepositoryUrl = ('https://github.com/%s/%s'):format(
    Settings.RepositoryOwner,
    Settings.ResourceName
)

local BaseRawUrl = ('https://raw.githubusercontent.com/%s/%s/%s/%s'):format(
    Settings.RepositoryOwner,
    Settings.VersionsRepository,
    Settings.Branch,
    Settings.ResourceName
)

local VersionUrl = BaseRawUrl .. '/version'
local ChangelogUrl = BaseRawUrl .. '/changelog.txt'

-- Utility
local function trim(value)
    return tostring(value or ''):gsub('^%s*(.-)%s*$', '%1')
end

local function printLine(message)
    print(message)
end

local function hr()
    printLine(C.muted .. '────────────────────────────────────────────' .. C.reset)
end

local function isValidVersion(version)
    return tostring(version or ''):match('^%d+%.%d+%.%d+$') ~= nil
end

local function parseVersion(version)
    local major, minor, patch = trim(version):match('^(%d+)%.(%d+)%.(%d+)$')

    return {
        major = tonumber(major) or 0,
        minor = tonumber(minor) or 0,
        patch = tonumber(patch) or 0
    }
end

local function compareVersions(left, right)
    local leftVersion = parseVersion(left)
    local rightVersion = parseVersion(right)

    if leftVersion.major ~= rightVersion.major then
        return leftVersion.major > rightVersion.major and 1 or -1
    end

    if leftVersion.minor ~= rightVersion.minor then
        return leftVersion.minor > rightVersion.minor and 1 or -1
    end

    if leftVersion.patch ~= rightVersion.patch then
        return leftVersion.patch > rightVersion.patch and 1 or -1
    end

    return 0
end

local function readLocalVersion()
    local versionFile = LoadResourceFile(resource, 'version')

    if versionFile and trim(versionFile) ~= '' then
        return trim(versionFile)
    end

    local manifestVersion = GetResourceMetadata(resource, 'version', 0)

    return trim(manifestVersion or '0.0.0')
end

local function splitLines(text)
    local lines = {}

    for line in tostring(text or ''):gmatch('[^\r\n]+') do
        line = trim(line)

        if line ~= '' then
            lines[#lines + 1] = line
        end
    end

    return lines
end

local function httpGet(url, callback)
    PerformHttpRequest(url, function(status, body)
        if status == 200 and body and trim(body) ~= '' then
            callback(true, trim(body), status)
            return
        end

        callback(false, nil, status)
    end, 'GET')
end

-- Console Output
local function header()
    hr()

    printLine(('%s%s%s  %s%s%s'):format(
        C.brand,
        Brand.Name,
        C.reset,
        C.muted,
        Brand.Tag,
        C.reset
    ))

    printLine(('%sWebsite:%s %s%s%s'):format(
        C.muted,
        C.reset,
        C.link,
        Brand.Website,
        C.reset
    ))

    printLine(('%sResource:%s %s%s%s'):format(
        C.muted,
        C.reset,
        C.accent,
        Settings.ResourceName,
        C.reset
    ))

    hr()
end

local function boxLine(label, value)
    printLine(('%s•%s %s%s%s %s'):format(
        C.muted,
        C.reset,
        C.muted,
        label,
        C.reset,
        value
    ))
end

local function boxSection(title)
    printLine(('%s%s%s'):format(
        C.muted,
        title,
        C.reset
    ))
end

local function printUpToDate(localVersion)
    header()

    boxLine('Status:', C.good .. 'UP TO DATE' .. C.reset)
    boxLine('Version:', C.good .. 'v' .. localVersion .. C.reset)
    boxLine('Repository:', C.link .. RepositoryUrl .. C.reset)

    hr()
end

local function printOutdated(localVersion, remoteVersion, changelogLines)
    header()

    boxLine('Status:', C.bad .. 'OUTDATED' .. C.reset)

    boxLine(
        'Version:',
        (C.bad .. 'v' .. localVersion .. C.reset)
        .. (C.muted .. ' → ' .. C.reset)
        .. (C.good .. 'v' .. remoteVersion .. C.reset)
    )

    if changelogLines and #changelogLines > 0 then
        boxSection(C.muted .. 'What\'s New:' .. C.reset)

        local limit = math.min(#changelogLines, Settings.ChangelogLimit)

        for i = 1, limit do
            printLine(('  %s-%s %s'):format(
                C.good,
                C.reset,
                changelogLines[i]
            ))
        end

        if #changelogLines > limit then
            printLine(('  %s… (+%d more)%s'):format(
                C.muted,
                #changelogLines - limit,
                C.reset
            ))
        end
    else
        boxLine('What\'s New:', C.muted .. 'Unavailable' .. C.reset)
    end

    boxLine('Repository:', C.link .. RepositoryUrl .. C.reset)

    hr()
end

local function printDevelopmentBuild(localVersion, remoteVersion)
    header()

    boxLine('Status:', C.accent .. 'DEVELOPMENT BUILD' .. C.reset)

    boxLine(
        'Version:',
        (C.accent .. 'v' .. localVersion .. C.reset)
        .. (C.muted .. ' > ' .. C.reset)
        .. (C.muted .. 'v' .. remoteVersion .. C.reset)
    )

    boxLine('Repository:', C.link .. RepositoryUrl .. C.reset)

    hr()
end

local function printCheckFailed(localVersion, status)
    header()

    boxLine(
        'Status:',
        C.bad .. 'VERSION CHECK FAILED' .. C.reset
        .. (' %s(HTTP %s)%s'):format(
            C.muted,
            tostring(status or 'unknown'),
            C.reset
        )
    )

    boxLine('Installed:', C.accent .. 'v' .. localVersion .. C.reset)
    boxLine('Repository:', C.link .. RepositoryUrl .. C.reset)

    hr()
end

local function printInvalidRemote(localVersion, remoteVersion)
    header()

    boxLine('Status:', C.warn .. 'INVALID REMOTE VERSION' .. C.reset)
    boxLine('Installed:', C.accent .. 'v' .. localVersion .. C.reset)
    boxLine('Remote:', C.bad .. tostring(remoteVersion or 'unknown') .. C.reset)
    boxLine('Expected:', C.muted .. 'Semantic version format, example: 1.0.0' .. C.reset)
    boxLine('Repository:', C.link .. RepositoryUrl .. C.reset)

    hr()
end

-- Version Check
local function checkVersion()
    if not Settings.Enabled then
        return
    end

    local localVersion = readLocalVersion()

    if not isValidVersion(localVersion) then
        localVersion = '0.0.0'
    end

    httpGet(VersionUrl, function(versionOk, remoteVersion, versionStatus)
        if not versionOk then
            printCheckFailed(localVersion, versionStatus)
            return
        end

        if not isValidVersion(remoteVersion) then
            printInvalidRemote(localVersion, remoteVersion)
            return
        end

        local comparison = compareVersions(localVersion, remoteVersion)

        if comparison == 0 then
            printUpToDate(localVersion)
            return
        end

        if comparison > 0 then
            printDevelopmentBuild(localVersion, remoteVersion)
            return
        end

        httpGet(ChangelogUrl, function(changelogOk, changelogText)
            local changelogLines = changelogOk and splitLines(changelogText) or nil

            printOutdated(
                localVersion,
                remoteVersion,
                changelogLines
            )
        end)
    end)
end

-- Resource Lifecycle
AddEventHandler('onResourceStart', function(startedResource)
    if startedResource ~= resource then
        return
    end

    SetTimeout(Settings.Delay, checkVersion)
end)