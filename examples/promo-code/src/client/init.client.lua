--[==[

	Copyright (C) Re-Sync - All Rights Reserved

	[init.client.lua]:
		Example client description

	[Author(s)]:
		Vyon - https://github.com/Vyon

--]==]

-- Services:
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TextChatService = game:GetService("TextChatService")

-- Modules:
local Interface = require(script.Interface)

-- Locals:
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local SendChat: RemoteEvent = ReplicatedStorage:WaitForChild("SendChat")

-- Main:
Interface(PlayerGui) --> Create example interface

SendChat.OnClientEvent:Connect(function(Message: string)
	local TextChannels = TextChatService:WaitForChild("TextChannels")
	local General: TextChannel = TextChannels:WaitForChild("RBXGeneral")

	General:DisplaySystemMessage(Message)
end)