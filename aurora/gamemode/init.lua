GM.Name = "The Aurora Framework"
GM.Author = "Aurora Studios"
GM.Version = "1.0.0"

AddCSLuaFile("libraries/sh_loader.lua")
AddCSLuaFile("shared.lua")

include("libraries/sh_loader.lua")
include("shared.lua")

DeriveGamemode("sandbox")
DEFINE_BASECLASS("gamemode_sandbox")

--- Displays the gamemode banner in the console with version and author information
-- @realm shared
-- @param[opt] color table The color to display the banner in (defaults to color_white)
-- @return boolean True if banner was displayed successfully, false otherwise
function aurora.printBanner(color)
    local bannerFilePath = "gamemodes/aurora/banner.txt"
    local displayColor = color or color_white

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

    MsgC(displayColor, bannerContent)
    return true
end

aurora.printBanner()