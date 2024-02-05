--[==[

	Copyright (C) Re-Sync - All Rights Reserved

	[Types.lua]:
		This file contains static types for the package.

	[Author(s)]:
		Vyon - https://github.com/Vyon

--]==]

-- Types:
-- Public:
--[=[
	@within LinkTracker
	@type GeneratorOptions {Secret: string?, PlaceId: number?,Referrer: number?, Limited: {Uses: number?,Expires: number?,}?,IsPromo: boolean?,Custom: { [string]: any }?,}

	### Options
	**Secret:** Used as a hash randomizer to prevent bruteforcing hashes using generic configs  
	**PlaceId:** Overrides `game.PlaceId` when creating the config hash   
	**Referrer:** The UserId of the person the link is associated with   
	**Limited:** If provided describes how many times the link can be used or the expiration date in seconds   
	**IsPromo:** Describes whether the link is being generated for promotional purposes or not  
	**Custom:** A dictionary of custom link data that can be used to give players certain items / rewards for using the link.
]=]
export type GeneratorOptions = {
	Secret: string?, --> If provided will create a hash of the key with sha256
	PlaceId: number?, --> If provided will replace game.PlaceId when generating a link

	-- Referral:
	Referrer: number?,

	-- Limited:
	Limited: {
		Uses: number?,
		Expires: number?,
	}?,

	-- Promo:
	IsPromo: boolean?,

	-- Custom:
	Custom: { [string]: any }?,
}

--[=[
	@within LinkTracker
	@type LinkData {Key: string,RemainingUses: number,Referrer: number?,Expires: number?,Item: string?,}
]=]
export type LinkData = {
	Key: string,
	RemainingUses: number,

	Referrer: number?,
	Expires: number?,
	Item: string?,
}

--[=[
	@within LinkTracker
	@type CallbackOptions<T> {NoLink: (Player: Player) -> ()?,InvalidLink: (Player: Player) -> ()?,UsableLink: (Player: Player, LinkData: T) -> boolean?,ConsumeLink: (Player: Player, LinkData: T) -> ()?,}
]=]
export type CallbackOptions<T> = {
	NoLink: (Player: Player) -> ()?,
	InvalidLink: (Player: Player) -> ()?,
	UsableLink: (Player: Player, LinkData: T) -> boolean?,
	ConsumeLink: (Player: Player, LinkData: T) -> ()?,
}

return {}
