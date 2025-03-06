GM.Name = "The Aurora Framework"
GM.Author = "Aurora Studios"
GM.Version = "1.0.0"

AddCSLuaFile("libraries/loader.lua")
AddCSLuaFile("shared.lua")

include("libraries/loader.lua")
include("shared.lua")

DeriveGamemode("sandbox")
DEFINE_BASECLASS("gamemode_sandbox")

--- Displays the gamemode banner in the console with version and author information.
-- @realm shared
-- @param[opt] color table The color to display the banner in (defaults to color_white)
-- @return boolean True if banner was displayed successfully, false otherwise
function aurora.printBanner(color)
    local bannerFilePath = "gamemodes/aurora/banner.txt"

    if not file.Exists(bannerFilePath, "GAME") then
        ErrorNoHaltWithStack(string.format("Could not find banner file at %s", bannerFilePath))
        return false
    end

    local bannerContent = file.Read(bannerFilePath, "GAME")
    if not bannerContent then
        ErrorNoHaltWithStack(string.format("Could not read banner file at %s", bannerFilePath))
        return false
    end

    bannerContent = bannerContent:gsub("{version}", GM.Version or "Unknown")
                                :gsub("{author}", GM.Author or "Unknown")

    MsgC(color, bannerContent)
    return true
end

aurora.printBanner()
