GM.Name = "The Aurora Framework"
GM.Author = "Aurora Studios"
GM.Version = "1.0.0"

AddCSLuaFile("shared.lua")
include("shared.lua")

DeriveGamemode("sandbox")
DEFINE_BASECLASS("gamemode_sandbox")