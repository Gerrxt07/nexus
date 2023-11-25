-- LSORP System Start
print("^2Das LSORP System wird gestartet...")

-- Funktion zum Senden von Lognachrichten an einen Discord-Webhook
function SendDiscordLogMessage(message)
    local webhookUrl = "https://discord.com/api/webhooks/1175578297099354222/K37XrZMXQ6uXS5cNu74xASLkbHmn87TfKFiMI7P_TgW9jnr3W71zc8oLJWud6Qa-RLH2"

    local headers = {
        ["Content-Type"] = "application/json"
    }

    local data = {
        username = "LSORP",  -- Benutzername, der die Nachricht sendet
        content = message  -- Inhalt der Nachricht
    }

    -- Senden des POST-Requests an den Discord-Webhook
    PerformHttpRequest(webhookUrl, function(statusCode, responseText, headers)
    end, 'POST', json.encode(data), headers)
end

-- Füge eine Warteschlange für Spieler hinzu
local playerQueue = {}

-- ABSCHNITT: Warteschlange für Spieler
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000) -- Warte 1 Sekunde

        if #playerQueue > 0 then
            local playerToJoin = table.remove(playerQueue, 1)
            if playerToJoin then
                Citizen.Wait(10000) -- Warte 10 Sekunden, bevor der nächste Spieler in der Warteschlange joinen kann
            end
        end
    end
end)

-- Event für Spielerverbindung registrieren
RegisterServerEvent('playerConnecting')

-- ...

-- Event-Handler für Spielerverbindung hinzufügen
AddEventHandler('playerConnecting', function(name, setCallback, deferrals)
    local source = source
    local player = GetPlayerIdentifiers(source)
    local playerIP = GetPlayerEndpoint(source)

    -- Whitelist-Überprüfung starten
    deferrals.defer()
    deferrals.update("VPN wird gesucht...")
    Citizen.Wait(2000)
    -- Überprüfe, ob der Spieler eine VPN verwendet
    --[[ PerformHttpRequest("http://ip-api.com/json/" .. playerIP .. "?fields=proxy,hosting,continentCode,countryCode", function(err, text, headers)
        if tonumber(err) == 200 then
            local tbl = json.decode(text)
            if (tbl["proxy"] == false and tbl['hosting'] == false and tbl['countryCode'] == 'DE' and tbl['continentCode'] == 'EU') then
            else
                deferrals.done("Wir haben eine VPN erkannt. Bitte deaktiviere diese und versuche es erneut.")
            end
        else
            deferrals.done("Aktuell gibt es Probleme mit der VPN Überprüfung. Bitte versuche es später erneut.")
            print("VPN Überprüfung fehlgeschlagen")
        end
    end) ]]--
    deferrals.update("Deine Whitelist wird überprüft...")
    Citizen.Wait(1000)

    -- Checke ob der Spieler Discord, Steam und FiveM verbunden hat
    local discordIdentifier = false
    local steamIdentifier = false
    local fivemIdentifier = false

    for _, identifier in ipairs(player) do
        if string.find(identifier, "discord:") then
            discordIdentifier = identifier
        elseif string.find(identifier, "steam:") then
            steamIdentifier = identifier
        elseif string.find(identifier, "fivem:") then
            fivemIdentifier = identifier
        end
    end

    -- Überprüfe Discord, Steam und FiveM Verbindung
    if not discordIdentifier or not steamIdentifier or not fivemIdentifier then
        deferrals.done("Du musst Discord, Steam und FiveM verbunden haben, um auf den Server zu joinen!")
        -- Logge den Kick-Versuch in Discord
        SendDiscordLogMessage(string.format("Spieler %s wurde wegen fehlender Discord, Steam oder FiveM Verbindung gekickt.", name))
    else
        -- Überprüfe, ob die Kombination in der Datenbanktabelle steht
        local combinedIdentifier = steamIdentifier .. discordIdentifier

        MySQL.Async.fetchScalar('SELECT COUNT(*) FROM whitelist WHERE steam_id = @steam_id AND discord_id = @discord_id', {
            ['@steam_id'] = steamIdentifier,
            ['@discord_id'] = discordIdentifier
        }, function(result)
            if result > 0 then
                -- Spieler ist auf der Whitelist, füge ihn zur Warteschlange hinzu
                table.insert(playerQueue, name)
                Citizen.Wait(1000)
                deferrals.update("Du bist nun in der Warteschlange...")
                Citizen.Wait(5000)
                deferrals.done()
                print(string.format("^2Spieler '%s' hat den Server betreten.", name))
                -- Überprüfe und aktualisiere den Spielernamen, FiveM ID und IP in der Datenbank
                UpdatePlayerInfoInDatabase(source, steamIdentifier, discordIdentifier, fivemIdentifier, name)
            else
                -- Spieler ist nicht auf der Whitelist, verweigere den Beitritt
                deferrals.done("Du bist nicht auf der Whitelist!")
                -- Logge den Kick-Versuch in Discord
                SendDiscordLogMessage(string.format("Spieler %s wurde wegen fehlender Whitelist gekickt.", name))
            end
        end)
    end
end)

-- Funktion zum Überprüfen und Aktualisieren des Spielernamens, FiveM ID und IP in der Datenbank
function UpdatePlayerInfoInDatabase(source, steamIdentifier, discordIdentifier, fivemIdentifier, playerName)
    local playerIP = GetPlayerEndpoint(source)

    MySQL.Async.fetchScalar('SELECT player_name, fivem_id, player_ip FROM whitelist WHERE steam_id = @steam_id AND discord_id = @discord_id', {
        ['@steam_id'] = steamIdentifier,
        ['@discord_id'] = discordIdentifier
    }, function(dbPlayerName, dbFiveMID, dbPlayerIP)
        if dbPlayerName and dbPlayerName ~= playerName or dbFiveMID ~= fivemIdentifier or dbPlayerIP ~= playerIP then
            -- Der in der Datenbank gespeicherte Spielername, FiveM ID oder IP unterscheidet sich vom aktuellen Ingame-Namen, FiveM ID oder IP
            MySQL.Async.execute('UPDATE whitelist SET player_name = @player_name, fivem_id = @fivem_id, player_ip = @player_ip WHERE steam_id = @steam_id AND discord_id = @discord_id', {
                ['@player_name'] = playerName,
                ['@fivem_id'] = fivemIdentifier,
                ['@player_ip'] = playerIP,
                ['@steam_id'] = steamIdentifier,
                ['@discord_id'] = discordIdentifier
            }, function(rowsChanged)
                if rowsChanged > 0 then
                    print(string.format("^2Spieler '%s' in der Datenbank aktualisiert.", playerName))
                else
                    print("^8Fehler beim Aktualisieren des Spielernamens, FiveM ID oder IP in der Datenbank.")
                end
            end)
        end
    end)
end

-- ABSCHNITT: Automatisches "Bannen" von Spielern die nicht auf der Whitelist sind.

-- Füge einen Timer hinzu, um alle 5 Minuten die Spieler zu überprüfen
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(300000) -- Warte 5 Minuten (300.000 Millisekunden)
        CheckWhitelistForAllPlayers() -- Führe die Funktion aus
    end
end)

-- Funktion zum Überprüfen der Whitelist für alle Spieler auf der Map
function CheckWhitelistForAllPlayers()
    local players = GetPlayers()

    for _, player in ipairs(players) do
        local source = tonumber(player)
        local identifiers = GetPlayerIdentifiers(source)

        local discordIdentifier = false
        local steamIdentifier = false
        local fivemIdentifier = false

        for _, identifier in ipairs(identifiers) do
            if string.find(identifier, "discord:") then
                discordIdentifier = identifier
            elseif string.find(identifier, "steam:") then
                steamIdentifier = identifier
            elseif string.find(identifier, "fivem:") then
                fivemIdentifier = identifier
            end
        end

        if discordIdentifier and steamIdentifier and fivemIdentifier then
            local combinedIdentifier = steamIdentifier .. discordIdentifier

            MySQL.Async.fetchScalar('SELECT COUNT(*) FROM whitelist WHERE steam_id = @steam_id AND discord_id = @discord_id AND fivem_id = @fivem_id', {
                ['@steam_id'] = steamIdentifier,
                ['@discord_id'] = discordIdentifier,
                ['@fivem_id'] = fivemIdentifier
            }, function(result)
                if result == 0 then
                    -- Spieler ist nicht mehr auf der Whitelist, kicke den Spieler
                    DropPlayer(source, "Du kannst auf dem Server aktuell nicht Spielen! Gründe dafür können z.B. sein dass du nicht Gewhitelistet bist, gebannt wurdest oder dass der Server sich im Wartungsmodus befindet.")
                end
            end)
        end
    end
end