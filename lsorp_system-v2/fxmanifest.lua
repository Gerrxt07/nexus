-- Project: Los Santos Online Roleplay (LSORP)
-- Author: Gerrit S. | Gerrxt (Admin of LSORP)
-- Last Date: 01.12.2023 (Created the file on 01.12.2023)
-- Version: 1.0.0 (Current version)
-- Official Documentation:
-- Official Discord:

fx_version 'cerulean'
game 'gta5'

author 'Gerrxt'
description 'System for LSORP'
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