local resource = GetCurrentResourceName()

local Config = {
    brandName = "Pigeon Studios Group",
    tagline = "Crafted with Precision. Designed for Performance.",
    website = "https://pigeonstudios.co.uk",

    -- Template defaults. Prefer overriding these in fxmanifest.lua:
    -- version '1.0.0'
    -- psg_version_slug 'my-resource'
    -- psg_name 'My Resource'
    defaultName = "pigeon-fivem-template",
    defaultSlug = "pigeon-fivem-template",
    registryBaseUrl = "https://raw.githubusercontent.com/WelshPigeon/pigeon-resource-versions/main",
    sourceName = "PSG Version Registry",

    checkDelayMs = 1500,
    timeoutMs = 10000,
    changelogLines = 8,
}

local C = {
    reset = "^7",
    brand = "^5",
    accent = "^3",
    good = "^2",
    bad = "^1",
    warn = "^3",
    link = "^4",
    muted = "^7",
    dim = "^8",
}

local function trim(value)
    return (tostring(value or ""):gsub("^%s*(.-)%s*$", "%1"))
end

local function compact(value)
    value = trim(value)
    if value == "" or value == "nil" or value == "false" then
        return nil
    end

    return value
end

local function metadata(key)
    if GetResourceMetadata then
        return compact(GetResourceMetadata(resource, key, 0))
    end

    return nil
end

local function stripVersionPrefix(version)
    version = trim(version)
    return (version:gsub("^[vV]%s*", ""))
end

local function normalizeVersion(version)
    version = stripVersionPrefix(version)
    local core = version:match("^([%d%.]+)")
    return core or version
end

local function parseVersion(version)
    local core = normalizeVersion(version)
    local parts = {}

    for part in core:gmatch("%d+") do
        parts[#parts + 1] = tonumber(part) or 0
    end

    return {
        major = parts[1] or 0,
        minor = parts[2] or 0,
        patch = parts[3] or 0,
        build = parts[4] or 0,
    }
end

local function compareVersions(left, right)
    local a = parseVersion(left)
    local b = parseVersion(right)
    local keys = { "major", "minor", "patch", "build" }

    for i = 1, #keys do
        local key = keys[i]
        if a[key] > b[key] then return 1 end
        if a[key] < b[key] then return -1 end
    end

    return 0
end

local function readLocalVersion()
    local legacyFile
    if LoadResourceFile then
        legacyFile = compact(LoadResourceFile(resource, "version"))
    end

    return metadata("version") or metadata("psg_version") or legacyFile or "0.0.0"
end

local function readDisplayName()
    return metadata("psg_name") or metadata("name") or Config.defaultName or resource
end

local function readBrandName()
    return metadata("psg_brand") or Config.brandName
end

local function readWebsite()
    return metadata("psg_website") or metadata("website") or Config.website
end

local function normalizeSlug(slug)
    slug = compact(slug)
    if not slug then return nil end
    slug = slug:lower()
    slug = slug:gsub("[^%w%-_]", "-")
    slug = slug:gsub("%-+", "-")
    slug = slug:gsub("^%-", ""):gsub("%-$", "")
    return compact(slug)
end

local function readVersionSlug()
    return normalizeSlug(metadata("psg_version_slug"))
        or normalizeSlug(metadata("version_slug"))
        or normalizeSlug(metadata("psg_slug"))
        or normalizeSlug(Config.defaultSlug)
        or normalizeSlug(resource)
end

local function readRegistryBaseUrl()
    local baseUrl = metadata("psg_version_registry") or Config.registryBaseUrl
    return trim(baseUrl):gsub("/+$", "")
end

local function latestUrl(slug)
    return readRegistryBaseUrl() .. "/" .. slug .. "/latest.json"
end

local function decodeJson(body)
    if not json or not json.decode then
        return nil, "FiveM json decoder unavailable"
    end

    local ok, result = pcall(json.decode, body)
    if not ok or type(result) ~= "table" then
        return nil, "Invalid GitHub response"
    end

    return result, nil
end

local function httpGet(url, callback)
    PerformHttpRequest(url, function(status, body)
        callback(tonumber(status) or 0, body or "")
    end, "GET", "", {
        ["Accept"] = "application/vnd.github+json",
        ["User-Agent"] = "Pigeon-Studios-Version-Checker/" .. resource,
    }, {
        timeout = Config.timeoutMs,
    })
end

local function splitReleaseNotes(text)
    text = trim(text)
    if text == "" then return nil end

    local lines = {}

    for line in text:gmatch("[^\r\n]+") do
        line = trim(line)
        line = line:gsub("^#+%s*", "")
        line = line:gsub("^[-*]%s+", "")

        if line ~= "" and not line:match("^<!%-%-") then
            lines[#lines + 1] = line
        end
    end

    return (#lines > 0) and lines or nil
end

local function p(message)
    print(message)
end

local function plain(value)
    return C.reset .. tostring(value or "") .. C.reset
end

local function line(label, value)
    p(("  %s%-8s%s %s"):format(C.dim, label, C.reset, value))
end

local function startBlock(displayName)
    p(("%s[%s]%s %s%s%s %s(%s)%s"):format(
        C.brand,
        readBrandName(),
        C.reset,
        C.accent,
        displayName,
        C.reset,
        C.dim,
        resource,
        C.reset
    ))
    p(("  %s%s%s"):format(C.dim, Config.tagline, C.reset))
    line("Site", C.link .. readWebsite() .. C.reset)
end

local function endBlock()
end

local function printNotes(notes)
    if not notes or #notes == 0 then
        line("Notes", C.dim .. "No release notes published" .. C.reset)
        return
    end

    line("Notes", C.reset .. "Latest release changes" .. C.reset)

    local cap = math.min(#notes, Config.changelogLines)
    for i = 1, cap do
        p(("    %s-%s %s"):format(C.good, C.reset, notes[i]))
    end

    if #notes > cap then
        p(("    %s... plus %d more line(s)%s"):format(C.dim, #notes - cap, C.reset))
    end
end

local function releaseNotes(release)
    if type(release.notes) == "table" then
        local notes = {}
        for i = 1, #release.notes do
            if compact(release.notes[i]) then
                notes[#notes + 1] = trim(release.notes[i])
            end
        end

        return (#notes > 0) and notes or nil
    end

    return splitReleaseNotes(release.body)
end

local function printUnavailable(displayName, localVersion, slug, reason)
    startBlock(displayName)
    line("Version", C.accent .. "v" .. stripVersionPrefix(localVersion) .. C.reset)
    line("Updates", C.bad .. "Check unavailable" .. C.reset)
    line("Reason", C.dim .. reason .. C.reset)

    if slug then
        line("Registry", C.link .. latestUrl(slug) .. C.reset)
    else
        line("Setup", C.dim .. "Add psg_version_slug 'resource-name' to fxmanifest.lua" .. C.reset)
    end

    endBlock()
end

local function printNoRegistryEntry(displayName, localVersion, slug)
    startBlock(displayName)
    line("Version", C.accent .. "v" .. stripVersionPrefix(localVersion) .. C.reset)
    line("Updates", C.warn .. "No registry entry found" .. C.reset)
    line("Next", plain("Add ") .. C.good .. slug .. "/latest.json" .. C.reset)
    line("Registry", C.link .. latestUrl(slug) .. C.reset)
    endBlock()
end

local function printUpToDate(displayName, localVersion, slug)
    startBlock(displayName)
    line("Version", C.good .. "v" .. stripVersionPrefix(localVersion) .. C.reset)
    line("Updates", C.good .. "Up to date" .. C.reset)
    line("Registry", C.link .. latestUrl(slug) .. C.reset)
    endBlock()
end

local function printOutdated(displayName, localVersion, latestVersion, slug, notes)
    startBlock(displayName)
    line(
        "Version",
        C.bad .. "v" .. stripVersionPrefix(localVersion) .. C.reset ..
        C.dim .. " -> " .. C.reset ..
        C.good .. "v" .. stripVersionPrefix(latestVersion) .. C.reset
    )
    line("Updates", C.warn .. "Update available" .. C.reset)
    printNotes(notes)
    line("Registry", C.link .. latestUrl(slug) .. C.reset)
    endBlock()
end

local function printDevBuild(displayName, localVersion, latestVersion, slug)
    startBlock(displayName)
    line(
        "Version",
        C.accent .. "v" .. stripVersionPrefix(localVersion) .. C.reset ..
        C.dim .. " > " .. C.reset ..
        C.dim .. "v" .. stripVersionPrefix(latestVersion) .. C.reset
    )
    line("Updates", C.accent .. "Development build" .. C.reset)
    line("Registry", C.link .. latestUrl(slug) .. C.reset)
    endBlock()
end

local function handleLatestRelease(displayName, localVersion, slug, status, body)
    if status == 404 then
        printNoRegistryEntry(displayName, localVersion, slug)
        return
    end

    if status ~= 200 then
        printUnavailable(displayName, localVersion, slug, "Registry returned HTTP " .. tostring(status))
        return
    end

    local release, decodeError = decodeJson(body)
    if not release then
        printUnavailable(displayName, localVersion, slug, decodeError)
        return
    end

    local latestVersion = compact(release.version) or compact(release.tag) or compact(release.tag_name)
    if not latestVersion then
        printUnavailable(displayName, localVersion, slug, "Registry entry has no version")
        return
    end

    local comparison = compareVersions(localVersion, latestVersion)
    if comparison == 0 then
        printUpToDate(displayName, localVersion, slug)
    elseif comparison > 0 then
        printDevBuild(displayName, localVersion, latestVersion, slug)
    else
        printOutdated(displayName, localVersion, latestVersion, slug, releaseNotes(release))
    end
end

local function checkVersion()
    local displayName = readDisplayName()
    local localVersion = readLocalVersion()
    local slug = readVersionSlug()

    if not slug then
        printUnavailable(displayName, localVersion, nil, "Missing version registry slug")
        return
    end

    httpGet(latestUrl(slug), function(status, body)
        handleLatestRelease(displayName, localVersion, slug, status, body)
    end)
end

AddEventHandler("onResourceStart", function(startedResource)
    if startedResource ~= resource then return end
    SetTimeout(Config.checkDelayMs, checkVersion)
end)
