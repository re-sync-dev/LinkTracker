-- Services:
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Modules:
local Fusion = require(ReplicatedStorage.Packages.Fusion)

-- Remotes:
local CreateLink = ReplicatedStorage:WaitForChild("CreateLink", 5) :: RemoteFunction

-- Variables:
local New = Fusion.New
local Ref = Fusion.Ref
local Value = Fusion.Value
local OnEvent = Fusion.OnEvent
local OnChange = Fusion.OnChange
local Children = Fusion.Children

return function(Parent: BasePlayerGui)
	local UserIds = {}

	local LinkOutputRef = Value()

	return New("ScreenGui")({
		Name = "InviteLinkExample",
		Parent = Parent,
		IgnoreGuiInset = true,
		ScreenInsets = Enum.ScreenInsets.DeviceSafeInsets,
		ResetOnSpawn = false,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,

		[Children] = {
			New("Frame")({
				Name = "Main",
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundColor3 = Color3.fromRGB(29, 29, 29),
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Position = UDim2.fromScale(0.91, 0.847),
				Size = UDim2.fromScale(0.148, 0.284),

				[Children] = {
					New("UICorner")({
						Name = "UICorner",
						CornerRadius = UDim.new(0, 4),
					}),

					New("TextBox")({
						[Ref] = LinkOutputRef,
						Name = "LinkOutput",
						ClearTextOnFocus = false,
						CursorPosition = -1,
						FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json"),
						PlaceholderText = "Link will be here:",
						Text = "",
						TextColor3 = Color3.fromRGB(255, 255, 255),
						TextEditable = false,
						TextSize = 14,
						TextWrapped = true,
						TextXAlignment = Enum.TextXAlignment.Left,
						TextYAlignment = Enum.TextYAlignment.Top,
						AnchorPoint = Vector2.new(0.5, 0.5),
						AutomaticSize = Enum.AutomaticSize.Y,
						BackgroundColor3 = Color3.fromRGB(39, 39, 39),
						BorderColor3 = Color3.fromRGB(0, 0, 0),
						BorderSizePixel = 0,
						Position = UDim2.fromScale(0.5, 0.317),
						Selectable = false,
						Size = UDim2.fromScale(0.9, 0.484),

						[Children] = {
							New("UICorner")({
								Name = "UICorner",
								CornerRadius = UDim.new(0, 4),
							}),

							New("UIPadding")({
								Name = "UIPadding",
								PaddingBottom = UDim.new(0, 5),
								PaddingLeft = UDim.new(0, 5),
								PaddingRight = UDim.new(0, 5),
								PaddingTop = UDim.new(0, 5),
							}),
						},
					}),

					New("UIAspectRatioConstraint")({
						Name = "UIAspectRatioConstraint",
						AspectRatio = 1.11,
					}),

					New("TextButton")({
						Name = "Generate",
						FontFace = Font.new("rbxasset://fonts/families/FredokaOne.json"),
						Text = "Invite",
						TextColor3 = Color3.fromRGB(255, 255, 255),
						TextSize = 16,
						AnchorPoint = Vector2.new(0.5, 0.9),
						BackgroundColor3 = Color3.fromRGB(20, 199, 79),
						BorderColor3 = Color3.fromRGB(0, 0, 0),
						BorderSizePixel = 0,
						Position = UDim2.fromScale(0.5, 0.9),
						Size = UDim2.fromScale(0.898, 0.13),

						[OnEvent("Activated")] = function()
							local Link = CreateLink:InvokeServer(UserIds)

							if not Link then --> This user was rate limited
								return
							end

							local Output = LinkOutputRef:get()
							Output.Text = Link
						end,

						[Children] = {
							New("UICorner")({
								Name = "UICorner",
								CornerRadius = UDim.new(0, 4),
							}),
						},
					}),

					New("TextBox")({
						Name = "UserIds",
						CursorPosition = -1,
						FontFace = Font.new("rbxasset://fonts/families/FredokaOne.json"),
						PlaceholderText = "UserIds (separated by commas)",
						Text = "",
						TextColor3 = Color3.fromRGB(255, 255, 255),
						TextScaled = true,
						TextSize = 16,
						TextWrapped = true,
						TextXAlignment = Enum.TextXAlignment.Left,
						Active = false,
						AnchorPoint = Vector2.new(0.5, 0.2),
						BackgroundColor3 = Color3.fromRGB(39, 39, 39),
						BorderColor3 = Color3.fromRGB(0, 0, 0),
						BorderSizePixel = 0,
						Position = UDim2.fromScale(0.5, 0.625),
						Selectable = false,
						Size = UDim2.fromScale(0.898, 0.141),

						[OnChange("Text")] = function(Text: string)
							local RawIds = Text
							local Ids = {}

							for _, RawId in RawIds:split(",") do
								local Id = tonumber(RawId)

								if not Id then
									continue
								end

								table.insert(Ids, Id)
							end

							UserIds = Ids
						end,

						[Children] = {
							New("UITextSizeConstraint")({
								Name = "UITextSizeConstraint",
								MaxTextSize = 16,
							}),

							New("UIPadding")({
								Name = "UIPadding",
								PaddingLeft = UDim.new(0, 10),
								PaddingRight = UDim.new(0, 10),
							}),

							New("UICorner")({
								Name = "UICorner",
								CornerRadius = UDim.new(0, 4),
							}),
						},
					}),
				},
			}),
		},
	})
end
