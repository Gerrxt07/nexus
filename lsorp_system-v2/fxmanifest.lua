fx_version 'cerulean'
game 'gta5'

author 'Gerrxt'
description 'System für LSORP'
version '1.0.0'

server_scripts {
    'server/sv_*.lua'
}

client_scripts {
    'client/cl_*.lua'
}

shared_scripts {
    '@oxmysql/lib/MySQL.lua',
    'shared/sh_*.lua'
}

dependencies {
    'oxmysql'
}

lua54 'yes'