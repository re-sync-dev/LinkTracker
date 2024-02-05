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
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Modules:
local LinkTracker = require(ReplicatedStorage.Packages.LinkTracker)

-- Types:
type LinkData = LinkTracker.LinkData
type CustomLinkData = LinkData & {
	Coins: number,
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

local SendChat = Instance.new("RemoteEvent")
SendChat.Name = "SendChat"
SendChat.Parent = ReplicatedStorage

-- Variables:
local ExampleDataStore = DataStoreService:GetDataStore("ExampleDataStore")
local RateLimit = {}

-- Functions:
local function SetupLeaderstats(Player: Player)
	local Leaderstats = Instance.new("Folder")
	Leaderstats.Name = "leaderstats"
	Leaderstats.Parent = Player

	local Coins = Instance.new("IntValue")
	Coins.Name = "Coins"
	Coins.Parent = Leaderstats
	Coins.Value = 0

	pcall(function(...)
		Coins.Value = ExampleDataStore:GetAsync(tostring(Player.UserId))
	end)
end

local function OnPlayerAdded(Player: Player)
	SetupLeaderstats(Player)

	LinkTracker:OnJoin(Player, {
		UsableLink = function(Player: Player, LinkData: CustomLinkData)
			if table.find(LinkData.AlreadyUsed, Player.UserId) then --> Player has already used this link.
				return false
			end

			return true
		end,

		ConsumeLink = function(Player: Player, LinkData: CustomLinkData)
			local Referrer = Players:GetNameFromUserIdAsync(LinkData.Referrer)

			print(`[LinkTracker]: {Player.Name} joined from {Referrer}'s link.`)
			table.insert(LinkData.AlreadyUsed, Player.UserId)

			-- Grant the player their rewards:
			local Leaderstats = Player:FindFirstChild("leaderstats")
			local Coins = Leaderstats and Leaderstats:FindFirstChild("Coins")

			Coins.Value += LinkData.Coins

			SendChat:FireAllClients(`{Player.Name} earned {LinkData.Coins} by using {Referrer}'s code!`)

			-- NOTE: Make sure that when using a custom server that you have a
			-- secure connection (https) that has TLS enabled. CloudFlare provides free
			-- certificates and you can enable TLS without a problem.

			-- Make a request to an external server to update how many users the creator has invited.

			local Endpoint = `https://example.com/creator/{LinkData.Referrer}` --> Change this to whatever your endpoint is

			HttpService:PostAsync(Endpoint, Player.UserId)
		end,
	})
end

local function OnPlayerRemoving(Player: Player)
	local Leaderstats = Player:FindFirstChild("leaderstats")
	local Coins = Leaderstats and Leaderstats:FindFirstChild("Coins")

	if not Coins then
		return
	end

	ExampleDataStore:SetAsync(tostring(Player.UserId), Coins.Value)
end

-- Main:
for _, Player in Players:GetPlayers() do
	task.spawn(OnPlayerAdded, Player)
end

-- Connections:
Players.PlayerAdded:Connect(OnPlayerAdded)
Players.PlayerRemoving:Connect(OnPlayerRemoving)

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
			Uses = 500,
			Expires = 60 * 60 * 24 * 7 * 4, --> 1 Month
		},

		Custom = {
			Coins = 1000,
			AlreadyUsed = {},
		},
	})

	return Link
end
