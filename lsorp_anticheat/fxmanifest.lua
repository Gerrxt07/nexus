fx_version 'cerulean'
game 'gta5'

author 'Gerrxt'
description 'Anticheat System für LSORP'
version '1.0.0'

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/*.lua'
}        

dependencies {
    'oxmysql',
    'lsorp_system'
}

lua54 'yes'
server_only 'yes'