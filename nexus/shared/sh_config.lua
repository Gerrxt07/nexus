-- Author: Gerrit S. | Gerrxt
-- Last Date: 02.01.2024 (Created the file on 01.12.2023)
-- Version: 1.0.0 (Current version)
-- Official Documentation:
-- Official Discord:
-- Script Side: Shared

-- Main Config | Please follow the documentation to configurate your script
nexus = {} -- Main config table

nexus.version = "1.0.0" -- Current Script version | Please do not change this
nexus.check_for_updates = true -- Check for updates on startup (true/false) | Recommend leaving it on
nexus.language = "DE" -- Available languages: EN, DE | More in the future

nexus.admins = { -- Admins table | Please add your steam hex
    'STEAM_HEX_HERE', -- Example: 'steam:110000143f15cde' | Use https://steamid.pro/ and take the "FiveM, HEX"
}

nexus.whitelist = true -- Enable/Disable the whitelist (true/false) | Recommend leaving it on
nexus.whtelist_table = "whitelist" -- Whitelist database table name | Please do not change this

nexus.logging = true -- Enable/Disable logging (true/false) | Recommend leaving it on
nexus.logging_webhook = "https://discord.com/api/webhooks/1191536134061310043/Os0wrryKMmHlPR5euvL56jItkPg6wfnjp_aXEU6Q1ZAK_sP-eZLb6e5iqH21DaZb4c_I" -- Logging webhook | Please change this to your webhook (Discord)