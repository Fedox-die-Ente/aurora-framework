--- Initializes the gamemode.
-- @module aurora
-- @realm shared
aurora = aurora or {}

-- Uh, i have this because gmod is weird sometimes.
LOADED = false

function GM:Initialize()
    aurora.util.refresh()
end

function GM:OnReloaded()
    if not LOADED then
        -- aurora.util.includeDir("libraries")
        aurora.util.refresh()
        LOADED = true
    end
end 
