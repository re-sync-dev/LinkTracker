--[==[

	Copyright (C) Re-Sync - All Rights Reserved

	[init.client.lua]:
		Example client description

	[Author(s)]:
		Vyon - https://github.com/Vyon

--]==]

-- Services:
local Players = game:GetService("Players")

-- Modules:
local Interface = require(script.Interface)

-- Locals:
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- Main:
Interface(PlayerGui) --> Create example interface
