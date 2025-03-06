aurora = aurora or {}
aurora.util = aurora.util or {}

-- Includes a lua file based off the prefix or parent directory.
-- @realm shared
-- @string filePath The file path to include
function aurora.util.includeFile(filePath)
    if filePath:find("sh_") or filePath:find("/shared/") then
        if SERVER then AddCSLuaFile(filePath) end
        return include(filePath)
    elseif filePath:find("sv_") or filePath:find("/server/") then
        if SERVER then return include(filePath) end
    elseif filePath:find("cl_") or filePath:find("/client/") then
        if SERVER then
            AddCSLuaFile(filePath)
        else
            return include(filePath)
        end
    end
end

-- Includes all files in a directory, including subdirectories.
-- @realm shared
-- @string directory The directory to include files from
function aurora.util.includeDir(directory)
    local baseDir = "aurora/gamemode/"

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

local function loadCore()
    aurora.util.includeDir("core/server")
    aurora.util.includeDir("core/client")
    aurora.util.includeDir("core/shared")
end

loadCore()
