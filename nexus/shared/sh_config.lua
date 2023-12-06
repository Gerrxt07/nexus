-- Author: Gerrit S. | Gerrxt
-- Last Date: 06.12.2023 (Created the file on 01.12.2023)
-- Version: 1.0.0 (Current version)
-- Official Documentation:
-- Official Discord:
-- Script Side: Shared

-- Main Config | Please follow the documentation to configurate your script
nexus = {} -- Main config table

nexus.version = "1.0.0" -- Current Script version | Please do not change this
nexus.check_for_updates = true -- Check for updates on startup (true/false) | Recommend leaving it on
nexus.language = "EN" -- Available languages: EN, DE | More in the future

nexus.admins = { -- Admins table | Please add your steam hex
    'STEAM_HEX_HERE', -- Example: 'steam:110000143f15cde' | Use https://steamid.pro/ and take the "FiveM, HEX"
}



-- Whitelist Config | Please follow the documentation to configurate the whitelist

nexus.whitelist = {} -- Whitelist config table

nexus.whitelist.status = "ON" -- Options: OFF, ON, MAINTENANCE (Only Admins can join) | Look in the Documentation for more informations 



-- MySQL Config | Please follow the documentation to install the MySQL database
nexus.mysql = {} -- MySQL config table

nexus.mysql.whitelisttable = "nexus_whitelist" -- Table name for the whitelist
nexus.mysql.bantable = "nexus_bans" -- Table name for the bans