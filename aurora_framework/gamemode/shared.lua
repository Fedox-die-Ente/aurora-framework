--- Initializes the gamemode.
-- @module aurora
-- @realm shared
aurora = aurora or {}
aurora.util = aurora.util or {}

-- Uh, i have this because gmod is weird sometimes.
LOADED = false

-- Includes a lua file based off the prefix or parent directory.
-- @realm shared
-- @string filePath The file path to include
function aurora.util.includeFile(filePath)
    if filePath:find("sv_") or filePath:find("/server/") then
        if SERVER then return include(filePath) end
    elseif filePath:find("cl_") or filePath:find("/client/") then
        if SERVER then
            AddCSLuaFile(filePath)
        else
            return include(filePath)
        end
    else
        if SERVER then AddCSLuaFile(filePath) end
        return include(filePath)
    end
end

-- Includes all files in a directory, including subdirectories.
-- @realm shared
-- @string directory The directory to include files from
function aurora.util.includeDir(directory)
    local baseDir = "aurora_framework/gamemode/"

    local files, folders = file.Find(baseDir .. directory .. "/*", "LUA")

    for _, v in ipairs(files) do
        local fullPath = directory .. "/" .. v
        aurora.util.includeFile(baseDir .. fullPath)
    end

    for _, v in ipairs(folders) do
        local fullPath = directory .. "/" .. v
        aurora.util.includeDir(fullPath)
    end
end

--- Includes all files in a directory, including subdirectories.
-- @realm shared
-- @string directory The directory to include files from
function aurora.util.includeSchemaDir(directory)
    local baseDir = engine.ActiveGamemode().. "/" 

    local files, folders = file.Find(baseDir .. directory.. "/*", "LUA")

    for _, v in ipairs(files) do
        local fullPath = directory.. "/".. v
        aurora.util.includeFile(baseDir.. fullPath)
    end

    for _, v in ipairs(folders) do
        local fullPath = directory.. "/".. v
        aurora.util.includeSchemaDir(fullPath)
    end
end 

--- Displays the gamemode banner in the console with version and author information.
-- @realm shared
-- @param[opt] color table The color to display the banner in (defaults to color_white)
-- @return boolean True if banner was displayed successfully, false otherwise
function aurora.printBanner(color)
    local bannerFilePath = "gamemodes/aurora_framework/banner.txt"
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

    bannerContent = bannerContent:gsub("{version}", aurora.gm.version or "Unknown")
                                :gsub("{author}", aurora.gm.author or "Unknown")

    MsgC(displayColor, bannerContent)
    return true
end

--- Reloads the gamemode.
-- @realm shared
function aurora.util.refresh()
    -- This will remove any temp data stored on the aurora table
    -- package.loaded["aurora"] = nil

    -- Reload all libraries
    aurora.util.includeDir("libraries")

    -- Reload core files in correct order
    aurora.util.includeDir("core/shared")
    aurora.util.includeDir("core/server")
    aurora.util.includeDir("core/client")

    aurora.util.includeSchemaDir("libraries")
    aurora.util.includeSchemaDir("schema/shared")
    aurora.util.includeSchemaDir("schema/server")
    aurora.util.includeSchemaDir("schema/client")

    aurora.printBanner()
end

function GM:Initialize()
    aurora.util.refresh()
end

function GM:OnReloaded()
    if not LOADED then
        aurora.util.refresh()
        LOADED = true
    end
end
