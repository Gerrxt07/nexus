-- ABSCHNITT: Nachricht, wenn ein Spieler den Server Verlässt.
AddEventHandler('playerDropped', function(reason)
    local player = GetPlayerName(source)
    print(string.format("^2Spieler '%s' hat den Server verlassen.", player))
end)