aurora = aurora or {}
aurora.database = aurora.database or {}

local function loadDatabaseConfig()    
    local dbConfig = aurora.toml.parse("gamemodes/aurora/framework/database.toml", "server")
    if not dbConfig then
        aurora.log.error("Failed to parse database configuration")
        return
    end

    if dbConfig then
        aurora.database.config = dbConfig
    end
end

loadDatabaseConfig()