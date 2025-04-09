--- MongoDB module for Aurora Framework.
-- Provides MongoDB database connectivity and operations.
-- @module aurora.mongo
-- @realm server

aurora = aurora or {}
aurora.mongo = aurora.mongo or {}

local mongoConnection
local mongoClient
local mongoDatabase

--- Connects to a MongoDB database.
-- @string url MongoDB connection URL
-- @string database Name of the database to connect to
-- @usage aurora.mongo.connect("mongodb://localhost:27017", "my_database")
function aurora.mongo.connect(url, database)
    require("mongo")

    mongoClient = MongoDB.Client(url)

    if not mongoClient then
        aurora.log.error("Failed to connect to MongoDB.")
    end

    mongoDatabase = mongoClient:Database(database)
end

--- Gets a collection from the connected database.
-- @string name Name of the collection
-- @treturn table MongoDB collection object
function aurora.mongo.collection(name)
    return mongoDatabase:Collection(name)
end

--- Creates a new collection in the connected database.
-- @string name Name of the collection to create
-- @treturn table New MongoDB collection object
function aurora.mongo.createCollection(name)
    return mongoDatabase:CreateCollection(name)
end

--- Constructs a MongoDB connection URL.
-- @bool isSrv Whether to use SRV connection format
-- @string host MongoDB server host
-- @number port MongoDB server port
-- @string[opt] username Authentication username
-- @string[opt] password Authentication password
-- @treturn string Constructed MongoDB connection URL
-- @usage local url = aurora.mongo.url(false, "localhost", 27017, "user", "pass")
function aurora.mongo.url(isSrv, host, port, username, password)
    local url = ""

    if isSrv then
        url = "mongodb+srv://"
    else
        url = "mongodb://"
    end

    if username and password then
        url = url .. username .. ":" .. password .. "@"
    end

    url = url .. host .. ":" .. port .. "/"

    return url
end

--- Gets the current MongoDB client instance.
-- @treturn table MongoDB client object
function aurora.mongo.client()
    return mongoClient
end