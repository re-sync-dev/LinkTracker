---
sidebar_position: 1
---

# Invite testers
## Server
```lua
--[==[

	Copyright (C) Re-Sync - All Rights Reserved

	[init.server.lua]:
		An example of how you could go about inviting testers to your game.

	[Author(s)]:
		Vyon - https://github.com/Vyon

--]==]

-- Services:
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Modules:
local LinkTracker = require(Path.To.LinkTracker)

-- Types:
type LinkData = LinkTracker.LinkData
type CustomLinkData = LinkData & {
	AllowedUsers: { number },
}

-- Locals:
local CreateLink = Instance.new("RemoteFunction")
CreateLink.Name = "CreateLink"
CreateLink.Parent = ReplicatedStorage

-- Variables:
local RateLimit = {}

-- Functions:
local function OnPlayerAdded(Player: Player)
	LinkTracker:OnJoin(Player, {
		InvalidLink = function(Player: Player)
			if Player.UserId == game.CreatorId then
				return
			end

			Player:Kick("The link you joined from is invalid.")
		end,

		UsableLink = function(Player: Player, LinkData: CustomLinkData)
			local Index = table.find(LinkData.AllowedUsers, Player.UserId)

			if not Index then
				return false
			end

			return true
		end,

		ConsumeLink = function(Player: Player, LinkData: CustomLinkData)
			local Index = table.find(LinkData.AllowedUsers, Player.UserId)

			if not Index then
				return
			end

			table.remove(LinkData.AllowedUsers, Index)

			local Referrer = Players:GetNameFromUserIdAsync(LinkData.Referrer)
			print(`[LinkTracker]: {Player.Name} joined from {Referrer}'s link.`)
		end,
	})
end

-- Main:
for _, Player in Players:GetPlayers() do
	task.spawn(OnPlayerAdded, Player)
end

-- Connections:
Players.PlayerAdded:Connect(OnPlayerAdded)

-- Binds:
CreateLink.OnServerInvoke = function(Player: Player, UserIds: { number }): string?
	if table.find(RateLimit, Player.UserId) then
		return
	end

	table.insert(RateLimit, Player.UserId)

	task.delay(10, function()
		table.remove(RateLimit, table.find(RateLimit, Player.UserId))
	end)

	local Link = LinkTracker:GenerateLink({
		Secret = tostring(tick()),
		Referrer = Player.UserId,
		Limited = {
			Uses = #UserIds,
			Expires = 60 * 60 * 24,
		},

		Custom = {
			AllowedUsers = UserIds,
		},
	})

	return Link
end
```