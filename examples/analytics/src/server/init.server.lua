--[==[

	Copyright (C) Re-Sync - All Rights Reserved

	[init.server.lua]:
		Example server description

	[Author(s)]:
		Vyon - https://github.com/Vyon

--]==]

-- Services:
local Players = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Modules:
local LinkTracker = require(ReplicatedStorage.Packages.LinkTracker)

-- Types:
type LinkData = LinkTracker.LinkData
type CustomLinkData = LinkData & {
	AlreadyUsed: { number },
}

-- Constants:
local USERS_ALLOWED_TO_CREATE_LINKS = {
	2394560147, --> VyonEXE (Me)
}

-- Locals:
local CreateLink = Instance.new("RemoteFunction")
CreateLink.Name = "CreateLink"
CreateLink.Parent = ReplicatedStorage

-- Variables:
local ExampleDataStore = DataStoreService:GetDataStore("ExampleDataStore")
local RateLimit = {}

-- Functions:
local function OnPlayerAdded(Player: Player)
	LinkTracker:OnJoin(Player, {
		UsableLink = function(Player: Player, LinkData: CustomLinkData)
			if table.find(LinkData.AlreadyUsed, Player.UserId) then --> Player has already used this link.
				return false
			end

			return true
		end,

		ConsumeLink = function(Player: Player, LinkData: CustomLinkData)
			local ReferrerId = LinkData.Referrer
			local Referrer = Players:GetNameFromUserIdAsync(LinkData.Referrer)

			print(`[LinkTracker]: {Player.Name} joined from {Referrer}'s link.`)
			table.insert(LinkData.AlreadyUsed, Player.UserId)

			local Key = `{ReferrerId}Referrals`

			local Success, Referrals = ExampleDataStore:GetAsync(Key)

			if not Success then
				error(`Failed to update referrals for referrer '{Referrer}' ({ReferrerId})`)
			end

			if table.find(Referrals, Player.UserId) then
				return
			end

			table.insert(Referrals, Player.UserId)

			ExampleDataStore:SetAsync(Key, Referrals)

			print(`Referrer '{Referrer}' ({ReferrerId}) now has {#Referrals} referrals!`)
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
CreateLink.OnServerInvoke = function(Player: Player, UserId: string): string?
	-- Sanity check to make sure exploiters / people who shouldn't be creating links can't.
	if not table.find(USERS_ALLOWED_TO_CREATE_LINKS, Player.UserId) then
		return
	end

	if table.find(RateLimit, Player.UserId) then
		return
	end

	table.insert(RateLimit, Player.UserId)

	task.delay(10, function()
		table.remove(RateLimit, table.find(RateLimit, Player.UserId))
	end)

	local Link = LinkTracker:GenerateLink({
		Secret = tostring(tick()),
		Referrer = UserId,
		Limited = {
			Expires = 60 * 60 * 24 * 7, --> 1 week
		},

		Custom = {
			AlreadyUsed = {},
		},
	})

	return Link
end
