-- ABSCHNITT: Command zum Hinzufügen von Spielern zur Whitelist
RegisterCommand('addwhitelist', function(source, args, rawCommand)
    if source == 0 then
        local playerName = args[1]
        local steamID = args[2]
        local discordID = args[3]

        if playerName and steamID and discordID then
            -- Füge den Spieler zur Whitelist hinzu
            MySQL.Async.execute('INSERT INTO whitelist (player_name, steam_id, discord_id) VALUES (@player_name, @steam_id, @discord_id)', {
                ['@player_name'] = playerName,
                ['@steam_id'] = steamID,
                ['@discord_id'] = discordID
            }, function(rowsChanged)
                if rowsChanged > 0 then
                    print(string.format("^2Spieler '%s' erfolgreich zur Whitelist hinzugefügt.", playerName))
                    SendDiscordLogMessage(string.format("Spieler %s zur Whitelist hinzugefügt.", playerName))
                    CheckWhitelistForAllPlayers() -- Führe die Funktion aus
                else
                    print("^8Fehler beim Hinzufügen des Spielers zur Whitelist.")
                end
            end)
        else
            print("^1Ungültige Verwendung des Befehls. Verwende /addwhitelist [Spielernamen] [Steam-ID] [Discord-ID]")
        end
    else
        print("^8Dieser Befehl kann nur von der Serverkonsole ausgeführt werden.")
    end
end, false) -- Setze den dritten Parameter auf false, damit der Befehl nicht aufgerufen werden kann, während der Server läuft

-- ABSCHNITT: Command zum Entfernen von Spielern aus der Whitelist
RegisterCommand('removewhitelist', function(source, args, rawCommand)
    if source == 0 then
        local playerName = args[1]

        if playerName then
            -- Entferne den Spieler aus der Whitelist
            MySQL.Async.execute('DELETE FROM whitelist WHERE player_name = @player_name', {
                ['@player_name'] = playerName
            }, function(rowsChanged)
                if rowsChanged > 0 then
                    print(string.format("^2Spieler '%s' erfolgreich aus der Whitelist entfernt.", playerName))
                    SendDiscordLogMessage(string.format("Spieler %s aus der Whitelist entfernt.", playerName))
                    CheckWhitelistForAllPlayers() -- Führe die Funktion aus
                else
                    print(string.format("^8Spieler '%s' nicht in der Whitelist gefunden.", playerName))
                end
            end)
        else
            print("^1Ungültige Verwendung des Befehls. Verwende /removewhitelist [Spielernamen]")
        end
    else
        print("^8Dieser Befehl kann nur von der Serverkonsole ausgeführt werden.")
    end
end, false) -- Setze den dritten Parameter auf false, damit der Befehl nicht aufgerufen werden kann, während der Server läuft

-- ABSCHNITT: Command zum Bannen von Spielern
RegisterCommand('ban', function(source, args, rawCommand)
    if source == 0 then
        local playerName = args[1]

        if playerName then
            -- Entferne den Spieler aus der Whitelist
            MySQL.Async.execute('DELETE FROM whitelist WHERE player_name = @player_name', {
                ['@player_name'] = playerName
            }, function(rowsChanged)
                if rowsChanged > 0 then
                    print(string.format("^2Spieler '%s' wurde erfolgreich gebannt!", playerName))
                    SendDiscordLogMessage(string.format("Spieler %s wurde gebannt!", playerName))
                    CheckWhitelistForAllPlayers() -- Führe die Funktion aus
                else
                    print(string.format("^8Spieler '%s' nicht gefunden!", playerName))
                end
            end)
        else
            print("^1Ungültige Verwendung des Befehls. Verwende /ban [Spielernamen]")
        end
    else
        print("^8Dieser Befehl kann nur von der Serverkonsole ausgeführt werden.")
    end
end, false) -- Setze den dritten Parameter auf false, damit der Befehl nicht aufgerufen werden kann, während der Server läuft

-- ABSCHNITT: Command zum Manuellen Überprüfen der Whitelist
RegisterCommand('reloadwhitelist', function(source, args, rawCommand)
    if source == 0 then
        CheckWhitelistForAllPlayers() -- Führe die Funktion aus
        print("^2Whitelist wurde neugeladen.")
    else
        print("^8Dieser Befehl kann nur von der Serverkonsole ausgeführt werden.")
    end
end, false) -- Setze den dritten Parameter auf false, damit der Befehl nicht aufgerufen werden kann, während der Server läuft