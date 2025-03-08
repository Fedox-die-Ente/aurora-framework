aurora = aurora or {}
aurora.toml = aurora.toml or {}
aurora.toml.config = aurora.toml.config or {}

function aurora.toml.init()
    local tomlPath = "gamemodes/aurora/config.toml"

    if file.Exists(tomlPath, "GAME") then
        local fileContent = file.Read(tomlPath, "GAME")
        local tomlContent = aurora.toml.parse(fileContent)

        aurora.toml.config = tomlContent
    else
        aurora.log.error("Unable to laod required server-config file: " .. tomlPath)
    end
end

function aurora.toml.get(key)
    PrintTable(aurora.toml.config)
end 
