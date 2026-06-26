fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'pigeon-fivem-template'
author 'Pigeon Studios Group'
description 'Enterprise-grade FiveM resource template developed by Pigeon Studios Group.'
version '1.0.0'
repository 'https://github.com/WelshPigeon/pigeon-fivem-template'

-- Pigeon Studios Group metadata.
-- The version checker reads these values automatically.
psg_name 'pigeon-fivem-template'
psg_brand 'Pigeon Studios Group'
psg_website 'https://pigeonstudios.co.uk'

escrow_ignore {
    'configuration/*.lua',
    'shared/*.lua',
    'locales/*.json'
}

-- Dependencies
dependencies {
    'ox_lib'
}

-- Shared Scripts
shared_scripts {
    '@ox_lib/init.lua',
    'configuration/*.lua',
    'shared/*.lua'
}

-- Client Scripts
client_scripts {
    'client/*.lua'
}

-- Server Scripts
server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/version_check.lua',
    'server/server.lua'
}

files {
    'web/img/banner.png',
    'locales/*.json'
}

-- UI / NUI Files
-- Uncomment these when the resource has a web UI.
-- ui_page 'web/index.html'
--
-- files {
--     'web/index.html',
--     'web/style.css',
--     'web/script.js',
--     'web/img/banner.png',
--     'locales/*.json'
-- }

-- Resource Tags
provide 'pigeon-fivem-template'

-- Optional Resource Features
use_experimental_fxv2_oal 'yes'
