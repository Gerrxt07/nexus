-- Author: Gerrit S. | Gerrxt
-- Last Date: 02.01.2024 (Created the file on 01.12.2023)
-- Version: 1.0.0 (Current version)
-- Official Documentation:
-- Official Discord:
-- Script Side: Server

local resourceName = "nexus"

AddEventHandler("onResourceStart", function()
    if nexus.check_for_updates == true and GetCurrentResourceName() == resourceName then
        local currentVersion = nexus.version

        PerformHttpRequest("https://api.github.com/repos/Gerrxt07/nexus/releases/latest", function(responseCode, resultData, resultHeaders)
            if responseCode == 200 then
                local releaseData = json.decode(resultData)
                local latestVersion = releaseData.tag_name

                if currentVersion < latestVersion then
                    print(Locales[nexus.language]['script_start_but_old'])
                else
                    print(Locales[nexus.language]['script_start'])
                end
            else
                print(Locales[nexus.language]['script_no_check'])
            end
        end, "GET", "", {})
    else
        print(Locales[nexus.language]['script_false_name'])
    end
end)

AddEventHandler("playerConnecting", function(name, setKickReason, deferrals)
    local source = source
    local identifiers = GetPlayerIdentifiers(source)

    if not identifiers or #identifiers == 0 then
        setKickReason(Locales[nexus.language]['user_whitelist_noidentifier'])
        CancelEvent()
        return
    end

    local steamIdentifier = nil
    local discordIdentifier = nil

    for _, identifier in ipairs(identifiers) do
        if string.find(identifier, "discord:") then
            discordIdentifier = identifier
        elseif string.find(identifier, "steam:") then
            steamIdentifier = identifier
        end
    end

    if not discordIdentifier or not steamIdentifier then
        setKickReason(Locales[nexus.language]['user_whitelist_noidentifier'])
        CancelEvent()
        return
    end

    deferrals.defer()

    if nexus.whitelist == true then
        deferrals.update(Locales[nexus.language]['user_whitelist_checking'])

        MySQL.Async.fetchScalar('SELECT COUNT(*) FROM ' .. nexus.whtelist_table .. ' WHERE steam_id = @steam_id AND discord_id = @discord_id', {
            ['@steam_id'] = steamIdentifier,
            ['@discord_id'] = discordIdentifier
        }, function(result)
            if result > 0 then
                Citizen.Wait(1000)
                deferrals.update(Locales[nexus.language]['user_whitelist_canjoin'])
                Citizen.Wait(5000)
                deferrals.done()
            else
                deferrals.done(Locales[nexus.language]['user_whitelist_nowhitelist'])
            end
        end)
    else
        deferrals.done()
    end

    Wait(0)
end)
