-- For support, scripts & more join our Discord here: https://discord.gg/9EbY4nM5uu

fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'iamlation'
description 'A unique take on oxy runs for FiveM'
version '1.1.0'

client_scripts {
    'bridge/client.lua',
    'client/*.lua',
}

server_scripts {
    'bridge/server.lua',
    'server/*.lua',
}

shared_scripts {
    'config.lua',
    '@ox_lib/init.lua'
}