fx_version 'cerulean'
game 'gta5'

lua54 'yes'

name 'pigeon-fivem-template'
author 'Pigeon Studios'
description 'Enterprise-grade FiveM resource template developed by Pigeon Studios.'
version '1.0.0'
repository 'https://github.com/WelshPigeon/pigeon-fivem-template'

-- Resource Metadata
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
    'server/*.lua'
}

-- UI / NUI Files
ui_page 'web/index.html'

files {
    'web/index.html',
    'web/style.css',
    'web/script.js',

    'locales/*.json'
}

-- Resource Tags
provide 'pigeon-fivem-template'

-- Optional Resource Features
use_experimental_fxv2_oal 'yes'