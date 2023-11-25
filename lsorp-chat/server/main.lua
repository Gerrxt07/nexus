local svConfig = {}

-- Configuration
 svConfig.versionChecker = false -- Version Checker
 svConfig.supportChecker = true -- Support Checker (If you use exports, it is recommended that you leave this on)

-- Script
AddEventHandler('onResourceStart', function(resourceName)
    if svConfig.versionChecker == true then
        PerformHttpRequest('https://api.github.com/repos/Concept-Collective/cc-chat/releases/latest', function (err, data, headers)
            if data == nil then
                print('An error occurred while checking the version. Your firewall may be blocking access to "github.com". Please check your firewall settings and ensure that "github.com" is allowed to establish connections.')
                return
            end

            local data = json.decode(data)
            if data.tag_name ~= 'v'..GetResourceMetadata(GetCurrentResourceName(), 'version', 0) then
                print('\n^1Bitte Update die Chat Ressource!')
            end
        end, 'GET', '')
    end
end)