aurora = aurora or {}

-- Includes a lua file based off the prefix or parent directory.
-- @realm shared
-- @string filePath The file path to include
function aurora.includeFile(filePath)
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
function aurora.includeDir(directory)
    local baseDir = "aurora/gamemode/"

    local files, folders = file.Find(baseDir .. directory .. "/*", "LUA")

    for _, v in ipairs(files) do
        local fullPath = directory .. "/" .. v
        aurora.includeFile(baseDir .. fullPath)
    end

    for _, v in ipairs(folders) do
        local fullPath = directory .. "/" .. v
        aurora.includeDir(fullPath)
    end

end

local function loadCore()
    aurora.includeDir("core/server")
    aurora.includeDir("core/client")
    aurora.includeDir("core/shared")
end

loadCore()
