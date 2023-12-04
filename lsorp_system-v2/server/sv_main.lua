-- Project: Los Santos Online Roleplay (LSORP)
-- Author: Gerrit S. | Gerrxt (Admin of LSORP)
-- Last Date: 02.12.2023 (Created the file on 01.12.2023)
-- Version: 1.0.0 (Current version)
-- Official Documentation:
-- Official Discord:
-- Script Side: Server

AddEventHandler("onResourceStart", function(resourceName)
    if GetCurrentResourceName() == resourceName and lsorp.check_for_updates == true then
        local currentVersion = lsorp.version  -- Nehme die Version aus der Konfigurationsdatei

        PerformHttpRequest("https://api.github.com/repos/Gerrxt07/lsorp/releases/latest", function(responseCode, resultData, resultHeaders)
            if responseCode == 200 then
                local releaseData = json.decode(resultData)
                local latestVersion = releaseData.tag_name

                if currentVersion < latestVersion then
                    print(Locales[lsorp.language]['script_start_but_old'])
                else
                    print(Locales[lsorp.language]['script_start'])
                end
            else
                print(Locales[lsorp.language]['script_no_check'])
            end
        end, "GET", "", {})
    end
end)
