-- Project: Los Santos Online Roleplay (LSORP)
-- Author: Gerrit S. | Gerrxt (Admin of LSORP)
-- Last Date: 02.12.2023 (Created the file on 01.12.2023)
-- Version: 1.0.0 (Current version)
-- Official Documentation:
-- Official Discord:
-- Script Side: Shared

lsorp = {} -- Main config table

lsorp.version = "1.0.0" -- Current Script version | Please do not change this
lsorp.check_for_updates = true -- Check for updates on startup (true/false) | Recommend leaving it on
lsorp.language = "EN" -- Available languages: EN, DE | More in the future

-- MySQL Config | Please follow the documentation to install the MySQL database
lsorp.mysql = {} -- MySQL config table
lsorp.mysql.whitelisttable = "lsorp_whitelist" -- Table name for the whitelist
lsorp.mysql.bantable = "lsorp_bans" -- Table name for the bans