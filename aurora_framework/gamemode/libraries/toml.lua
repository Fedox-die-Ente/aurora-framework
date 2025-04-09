aurora = aurora or {}
aurora.toml = aurora.toml or {}

--- Parses a toml configuration file format
-- @realm shared
-- @param path string The file path to parse
-- @param realm string The realm that can access this file ("shared" or "server")
-- @return table|nil The parsed data or nil if failed
function aurora.toml.parse(path, realm)
    if realm == "server" and CLIENT then
        aurora.log.debug("Skipping server-only toml file on client: " .. path)
        return
    end

    if not file.Exists(path, "GAME") then
        aurora.log.error("Could not find toml file at: " .. path)
        return
    end

    local content = file.Read(path, "GAME")
    if not content then
        aurora.log.error("Could not read toml file: " .. path)
        return
    end

    local data = {}
    local currentSection = nil

    for line in content:gmatch("[^\r\n]+") do
        line = line:gsub("//.*$", ""):gsub("^%s*(.-)%s*$", "%1")
        
        if line ~= "" then
            local sectionName = line:match("^%[([%w_%.]+)%]$")
            if sectionName then
                currentSection = {}
                data[sectionName] = currentSection
            else
                local key, value = line:match("^([%w_%.]+)%s*=%s*(.+)$")
                if key and value then
                    if value:match('^"(.-)"$') then
                        value = value:match('^"(.-)"$')
                    elseif value == "true" then
                        value = true
                    elseif value == "false" then
                        value = false
                    elseif tonumber(value) then
                        value = tonumber(value)
                    end
                    
                    if currentSection then
                        currentSection[key] = value
                    else
                        data[key] = value
                    end
                end
            end
        end
    end

    return data
end

if SERVER then
    local gamemodeInfo = aurora.toml.parse("gamemodes/aurora_framework/framework/aurora.toml", "shared")
    if gamemodeInfo then
        aurora.gm = gamemodeInfo
    end
end