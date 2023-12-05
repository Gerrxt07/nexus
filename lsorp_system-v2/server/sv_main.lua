-- Project: Los Santos Online Roleplay (LSORP)
-- Author: Gerrit S. | Gerrxt (Admin of LSORP)
-- Last Date: 05.12.2023 (Created the file on 01.12.2023)
-- Version: 1.0.0 (Current version)
-- Official Documentation:
-- Official Discord:
-- Script Side: Server

AddEventHandler("onResourceStart", function()
    resourceName = "lsorp_system-v2" -- Real Resource Name, dont edit the name!
    if lsorp.check_for_updates == true and GetCurrentResourceName() == resourceName then
        local currentVersion = lsorp.version -- Get Current Version, dont edit the version!

        PerformHttpRequest("https://api.github.com/repos/Gerrxt07/lsorp/releases/latest", function(responseCode, resultData, resultHeaders) -- Request the latest version from github
            if responseCode == 200 then -- If the request was successfully
                local releaseData = json.decode(resultData)
                local latestVersion = releaseData.tag_name

                if currentVersion < latestVersion then -- Check if the current version is lower than the latest version
                    print(Locales[lsorp.language]['script_start_but_old']) -- If check is successfully, but the script is old, print the message!
                else
                    print(Locales[lsorp.language]['script_start']) -- If all checks are successfully, print the message!
                end
            else
                print(Locales[lsorp.language]['script_no_check']) -- If check was not successfully, print the message!
            end
        end, "GET", "", {})
    else
        print(Locales[lsorp.language]['script_false_name']) -- If the script name is not the same as the real, intended resource name, print the message!
    end
end)