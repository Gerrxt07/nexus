-- Author: Gerrit S. | Gerrxt
-- Last Date: 27.12.2023 (Created the file on 01.12.2023)
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