aurora = aurora or {}
aurora.log = {}

--- Gets the current timestamp in a formatted string
-- @realm shared
-- @return string Formatted timestamp [YYYY-MM-DD HH:MM:SS]
local function getTimestamp()
    return os.date("[%Y-%m-%d %H:%M:%S]")
end

--- Internal function to handle log message formatting and display
-- @realm shared
-- @param color table The color for the message text
-- @param ... any Additional arguments to be printed
local function localLog(color, ...)
    local args = {}

    if CLIENT then
        args[1] = Color(227, 216, 115)
        args[2] = "[CLIENT] "
    else
        args[1] = Color(0, 150, 255)
        args[2] = "[SERVER] "
    end

    MsgC(Color(0, 255, 255), "", args[1], args[2], color, " ", ...)
end

--- Logs a debug message to the console
-- @realm shared
-- @param ... any Values to log (will be concatenated with spaces)
function aurora.log.debug(...)
    localLog(Color(184, 158, 42), "[DEBUG] ", ..., "\n")
end

--- Logs an info message to the console
-- @realm shared
-- @param ... any Values to log (will be concatenated with spaces)
function aurora.log.info(...)
    localLog(Color(0, 255, 255), "[INFO] ", Color(255,255,255), ..., "\n")
end

--- Logs a warning message to the console
-- @realm shared
-- @param ... any Values to log (will be concatenated with spaces)
function aurora.log.warn(...)
    localLog(Color(255, 255, 0), "[WARN] ", ..., "\n")
end

--- Logs an error message to the console and saves it to a file
-- @realm shared
-- @param ... any Values to log (will be concatenated with spaces)
-- @note This function also saves the error message to aurora/error_logs.txt
function aurora.log.error(...)
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