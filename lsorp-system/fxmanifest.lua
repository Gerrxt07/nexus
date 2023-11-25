fx_version 'cerulean'
game 'gta5'

author 'Gerrxt'
description 'System für LSORP'
version '1.0.0'

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/*.lua'
}        

-- Füge hier deine anderen Ressourcen-Abhängigkeiten hinzu
dependencies {
    'oxmysql'
}

lua54 'yes'
server_only 'yes'