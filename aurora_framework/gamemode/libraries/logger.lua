aurora = aurora or {}
aurora.log = {}

--- Gets the current timestamp in a formatted string
-- @realm shared
-- @return string Formatted timestamp [YYYY-MM-DD HH:MM:SS]
local function getTimestamp()
    return os.date("%Y-%m-%d %H:%M:%S")
end

--- Internal function to handle log message formatting and display
-- @realm shared
-- @param color table The color for the message text
-- @param logType string The type of log message
-- @param ... any Additional arguments to be printed
local function localLog(color, logType, ...)
    local timestamp = Color(255, 255, 255)
    local bracket = Color(200, 200, 200)
    local realm = CLIENT and Color(227, 216, 115) or Color(43, 139, 207)
    local realmText = CLIENT and "CLIENT" or "SERVER"
    local messageColor = Color(255, 255, 255)
    
    MsgC(
        bracket, "[", timestamp, getTimestamp(), bracket, "] ",
        bracket, "[", realm, realmText, bracket, "] ",
        bracket, "[", color, logType, bracket, "] ",
        messageColor, table.concat({...}, " "), "\n"
    )
end

--- Logs a debug message to the console
-- @realm shared
-- @param ... any Values to log (will be concatenated with spaces)
function aurora.log.debug(...)
    localLog(Color(184, 158, 42), "DEBUG", ...)
end

--- Logs a success message to the console
-- @realm shared
-- @param... any Values to log (will be concatenated with spaces)
function aurora.log.success(...)
    localLog(Color(0, 255, 0), "SUCCESS", ...)
end

--- Logs an info message to the console
-- @realm shared
-- @param ... any Values to log (will be concatenated with spaces)
function aurora.log.info(...)
    localLog(Color(72, 175, 255), "INFO", ...)
end

--- Logs a warning message to the console
-- @realm shared
-- @param ... any Values to log (will be concatenated with spaces)
function aurora.log.warn(...)
    localLog(Color(255, 175, 0), "WARN", ...)
end

--- Logs an error message to the console and saves it to a file
-- @realm shared
-- @param ... any Values to log (will be concatenated with spaces)
-- @note This function also saves the error message to aurora/error_logs.txt
function aurora.log.error(...)
    localLog(Color(255, 0, 0), "ERROR", ...)

    -- File logging with full timestamp for errors
    local fullTimestamp = os.date("[%Y-%m-%d %H:%M:%S]")
    local logMessage = string.format("%s [ERROR] %s\n", 
        fullTimestamp, 
        table.concat({...}, " ")
    )

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