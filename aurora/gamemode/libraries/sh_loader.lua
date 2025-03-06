aurora = aurora or {}

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

local function loadCore()
    local coreFolder = "aurora/gamemode/core/"
    local realms = { "server", "client", "shared" }

    for _, realm in ipairs(realms) do
        local realmDir = coreFolder .. realm .. "/"
        local files, _ = file.Find(realmDir .. "*", "LUA")

        if files then
            for _, fileName in SortedPairs(files) do
                local filePath = realmDir .. fileName
                aurora.includeFile(filePath)
                print(string.format("Loaded %s", filePath))
            end
        end
    end
end

loadCore()
