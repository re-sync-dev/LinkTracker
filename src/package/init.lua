--[==[

	Copyright (C) Re-Sync - All Rights Reserved

	[init.lua]:
		Create and monitor deep links to your game.

	[Author(s)]:
		Vyon - https://github.com/Vyon

--]==]

-- Services:
local RunService = game:GetService("RunService")
local DataStoreService = game:GetService("DataStoreService")
local MemoryStoreService = game:GetService("MemoryStoreService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Modules:
local HashLib = require(ReplicatedStorage.Packages.HashLib)
local T = require(ReplicatedStorage.Packages.T)
local Types = require(script.Types)

-- Types:
export type GeneratorOptions = Types.GeneratorOptions
export type LinkData = Types.LinkData
export type CallbackOptions<T> = Types.CallbackOptions<T>

-- Constants:
local DEFAULT_EXPIRY = 60 * 60 * 24 * 7 --> 1 week
local STORE_NAME = "DeepLinkData"
local IS_SERVER = RunService:IsServer()
local DEAD_FUNCTION = function(...) end

-- Variables:
local _, MemoryStore = pcall(function()
	return MemoryStoreService:GetSortedMap(STORE_NAME)
end)

local _, DataStore = pcall(function()
	return DataStoreService:GetDataStore(STORE_NAME)
end)

--[=[
	@class LinkTracker
	Create and monitor deep links to your game's servers.
]=]
local LinkTracker = {}

--[=[
	@within LinkTracker
	@function _FormatLink
	@private

	@param EncodedOptions string
	@param PlaceIdOverride number?
	@return string
]=]
function LinkTracker._FormatLink(EncodedOptions: string, PlaceIdOverride: number?): string
	assert(IS_SERVER, "[LinkTracker]: Cannot generate a link from the client.")

	local PlaceId = PlaceIdOverride or game.PlaceId

	return `https://www.roblox.com/games/start?launchData={EncodedOptions}&placeId={PlaceId}`
end

--[=[
	@within LinkTracker
	@function _StoreLinkData
	@private

	@param Key string
	@param LinkData LinkData
]=]
function LinkTracker._StoreLinkData(Key: string, LinkData: LinkData)
	if LinkData.Expires or not DataStore then
		MemoryStore:SetAsync(Key, LinkData, LinkData.Expires or DEFAULT_EXPIRY)
	else
		DataStore:SetAsync(Key, LinkData)
	end
end

--[=[
	@within LinkTracker
	@method GenerateLink
	Create a new deep link based off of the given options.

	Example usage:
	```lua
	local LinkTracker = require(Path.To.LinkTracker)

	local Link = LinkTracker:GenerateLink({
		Secret = tostring(tick()),
		Limited = {
			Uses = 5,
			Expires = 60 * 60, --> 1 hour
		},

		Custom = {
			Coins = 1000,
			AlreadyUsed = {},
		},
	})

	print(`Link: {Link}`)
	```

	@param Options GeneratorOptions
	@return string
]=]
function LinkTracker:GenerateLink(Options: GeneratorOptions)
	-- Typechecking:
	assert(
		T.interface({
			Secret = T.optional(T.string),
			PlaceId = T.optional(T.number),
			Referrer = T.optional(T.number),
			Limited = T.optional(T.interface({
				Uses = T.optional(T.number),
				Expires = T.optional(T.number),
			})),
			Promo = T.optional(T.boolean),
			Custom = T.optional(T.table),
		})(Options),
		"[LinkTracker]: Provided options do not match the expected type."
	)

	-- Variables:
	local Secret = Options.Secret
	local Referrer = Options.Referrer
	local Limited = Options.Limited
	local Uses = Limited and Limited.Uses or -1
	local Expires = Limited and Limited.Expires
	local IsPromo = Options.IsPromo or false

	-- Create a unique config hash to serve as the key for the link.
	local LinkKey: string = HashLib.sha1(table.concat({
		Secret or "",
		Referrer and tostring(Referrer) or "",
		Uses and tostring(Uses) or "",
		Expires and tostring(Expires) or "",
		IsPromo and "true" or "false",
	}, ":"))

	local LinkData = {
		Referrer = Referrer,
		RemainingUses = Uses,
		Expires = Expires,
		Item = IsPromo,
	}

	local CustomData = Options.Custom or {} :: { [string]: any }

	for Key, Value in CustomData do
		LinkData[Key] = Value
	end

	self._StoreLinkData(LinkKey, LinkData)

	return self._FormatLink(LinkKey)
end

--[=[
	@within LinkTracker
	@method DeleteLink
	Delete the deep link associated with the given key.

	@param Options GeneratorOptions
	@return string
]=]
function LinkTracker:DeleteLink(LinkKey: string)
	MemoryStore:RemoveAsync(LinkKey)

	if DataStore then
		-- As far as I know all DataStore requests need to be wrapped
		-- in a pcall to prevent random errors from occuring.
		pcall(function()
			DataStore:RemoveAsync(LinkKey)
		end)
	end
end

--[=[
	@within LinkTracker
	@method GetLinkData
	Get the deep link data associated with the given key.

	@param LinkKey string
	@return LinkData?
]=]
function LinkTracker:GetLinkData(LinkKey: string): LinkData?
	-- NOTE: MemoryStore:GetAsync will not work within specific game contexts.
	-- When generating a link in studio, MemoryStoreService will put the saved value
	-- into what I believe to be a 'Studio' context.

	-- BUG: Remove usage of MemoryStoreService in favor of DataStoreService
	-- to prevent the above issue from occuring.
	local _, LinkData: LinkData? = pcall(function()
		return MemoryStore and MemoryStore:GetAsync(LinkKey) or (DataStore and DataStore:GetAsync(LinkKey))
	end)

	return LinkData
end

--[=[
	@within LinkTracker
	@method SetLinkData
	Used to update link data, uses a generic key (generated or custom) to 

	@param LinkKey string
	@param LinkData LinkData
]=]
function LinkTracker:SetLinkData(LinkKey: string, LinkData: LinkData)
	self._StoreLinkData(LinkKey, LinkData)
end

--[=[
	@within LinkTracker
	@method OnJoin
	Removes the need to manually update old / expired links. This method
	is used to run tasks within the module.

	@param Player Player
	@param CallbackOptions CallbackOptions?
]=]
function LinkTracker:OnJoin<T>(Player: Player, CallbackOptions: CallbackOptions<T>?)
	local Callbacks = (CallbackOptions or {}) :: CallbackOptions<T>

	local JoinData = Player:GetJoinData()
	local LaunchData: string? = JoinData.LaunchData

	local NoLink = Callbacks.NoLink or DEAD_FUNCTION
	local InvalidLink = Callbacks.InvalidLink or DEAD_FUNCTION
	local UsableLink = Callbacks.UsableLink
	local ConsumeLink = Callbacks.ConsumeLink or DEAD_FUNCTION

	if not LaunchData then
		NoLink(Player)
		return
	end

	local LinkData: LinkData = self:GetLinkData(LaunchData)

	if not LinkData then
		InvalidLink(Player)
		return
	end

	local Success = pcall(UsableLink or function()
		return true
	end, Player, LinkData)

	if not Success then
		warn("[LinkTracker]: An error occured while running the 'UsableLink' callback.")
	end

	if not Success then
		return
	end

	-- Consume link data:
	ConsumeLink(Player, LinkData)

	-- Run after consumption process:
	LinkData.RemainingUses -= 1

	if LinkData.RemainingUses == 0 then
		LinkTracker:DeleteLink(LaunchData)
	else
		LinkTracker:SetLinkData(LaunchData, LinkData)
	end
end

-- Main:
assert(MemoryStore, "[LinkTracker]: In order for LinkTracker to work, the current place must be published.")

if not DataStore then
	warn("[LinkTracker]: DataStoreService is not available, link data will be stored in memory only.")
end

return LinkTracker