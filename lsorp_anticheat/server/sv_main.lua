-- LSORP Anticheat System by Gerrxt

print("^2Das Anticheat System wird gestartet...")

-- Allowed Player IDs
local allowedPlayers = {
    "steam:110000143f15cde" -- Gerrxt
}

function IsPlayerAllowed(playerId)
    for _, id in ipairs(allowedPlayers) do
        if playerId == id then
            return true
        end
    end
    return false
end
