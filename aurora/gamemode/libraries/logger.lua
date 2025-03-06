aurora = aurora or {}
aurora.log = {}

local function getTimestamp()
    return os.date("[%Y-%m-%d %H:%M:%S]")
end

local function localLog(color, ...)
    local args = {}

    if CLIENT then
        args[1] = Color(227, 216, 115)
        args[2] = "[CLIENT] "
    else
        args[1] = Color(0, 150, 255)
        args[2] = "[SERVER] "
    end

    MsgC(Color(0, 255, 255), "", args[1], args[2], color, getTimestamp(), " ", ...)
end

function aurora.log.Debug(...)
    localLog(Color(184, 158, 42), "[DEBUG] ", ..., "\n")
end

function aurora.log.Info(...)
    localLog(Color(0, 255, 255), "[INFO] ", Color(255,255,255), ..., "\n")
end

function aurora.log.Warn(...)
    localLog(Color(255, 255, 0), "[WARN] ", ..., "\n")
end

function aurora.log.Error(...)
    localLog(Color(255, 0, 0), "[ERROR] ", ..., "\n")

    local logMessage = getTimestamp() .. " [ERROR] " .. table.concat({...}, " ") .. "\n"

    local directory = "aurora"
    if not file.Exists(directory, "DATA") then
        file.CreateDir(directory)
    end

    local filePath = directory .. "/error_logs.txt"
    if not file.Exists(filePath, "DATA") then
        file.Write(filePath, "")
    end

    file.Append(filePath, logMessage)
end