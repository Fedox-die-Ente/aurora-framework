--- Hotloader module for dynamically loading and caching external resources.
-- @module aurora.hotloader
-- @realm client

aurora.hotloader = aurora.hotloader or {}
aurora.hotloader.toLoad = aurora.hotloader.toLoad or {}
aurora.hotloader.quickAccess = aurora.hotloader.quickAccess or {}

--- Queues an external resource for loading and creates a material placeholder.
-- @string path URL of the resource to load
-- @string uniqueName Unique identifier for the resource
-- @string[opt] extDir Optional subdirectory for organization
-- @usage aurora.hotloader.load("http://example.com/image.png", "example_image", "textures")
function aurora.hotloader.load(path, uniqueName, extDir)
    local imgType = string.Explode(".", path)
    imgType = imgType[#imgType]

    table.insert(aurora.hotloader.toLoad, {
        name = uniqueName,
        url = path,
        mat = Material("data/aurora/" .. (extDir and extDir.."/" or "") .. uniqueName .. "." .. imgType),
        format = imgType,
        extDir = extDir
    })

    aurora.hotloader.quickAccess[uniqueName] = Material("data/aurora/".. (extDir and extDir.."/" or "").. uniqueName.. ".".. imgType)
end

--- Retrieves a loaded material by its unique name.
-- @string uniqueName Unique identifier of the resource
-- @treturn Material The loaded material or nil if not found
function aurora.hotloader.get(uniqueName)
    return aurora.hotloader.quickAccess[uniqueName]
end

--- Flag indicating if this is the first load operation.
-- @field firstLoad
aurora.hotloader.firstLoad = aurora.hotloader.firstLoad or true

--- Internal hook that processes the load queue.
-- Downloads resources, creates materials, and manages local cache.
-- @hook HUDPaint
-- @local
hook.Add("HUDPaint", "aurora.hotloader", function()
    aurora.log.info("Loading images from queued list...")

    if not file.Exists("aurora", "DATA") then
        aurora.log.info("Creating aurora folder...")
        file.CreateDir("aurora")
    end

    for k, v in pairs(aurora.hotloader.toLoad) do
        if file.Exists("aurora/" .. v.name .. "." .. v.format, "DATA") then continue end

        if v.extDir and not file.Exists("aurora/".. v.extDir, "DATA") then 
            file.CreateDir("aurora/".. v.extDir)
        end

        http.Fetch(v.url, 
        function(body, len, headers, code)
            file.Write("aurora/" .. (v.extDir and v.extDir .. "/" or "") .. v.name .. "." .. v.format, body)
            v.mat = Material("data/aurora/".. (v.extDir and v.extDir.."/" or "").. v.name.. ".".. v.format, "noclamp smooth")
            aurora.hotloader.quickAccess[v.name] = v.mat
            aurora.log.success("Successfully loaded ".. v.name.. ".".. v.format)
        end,
        function(error)
            aurora.log.error("Failed to load ".. v.name.. ".".. v.format)
        end)
    end

    hook.Remove("HUDPaint", "aurora.hotloader")

    timer.Simple(2, function()
        aurora.hotloader.firstLoad = false
    end)
end)

