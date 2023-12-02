local module = {}
local StarterGui = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, false)
StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, true)

UserInputService.MouseIconEnabled = false

function module.Initiate()
	local React = _G.react
	local ReactRoblox = _G.reactRoblox

	local function createComponent(uiType, props, defaultProps)
		for key, value in pairs(props) do
			if key == "children" then
				continue
			end

			defaultProps[key] = value
		end

		return React.createElement(uiType, defaultProps, props.children)
	end

	local function HUD()
		local function crosshair(size, position)
			return React.createElement("Frame", {
				Size = size,
				Position = position,
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			}, {
				React.createElement("UIStroke"),
			})
		end

		local function TextLabel(props)
			return createComponent("TextLabel", props, {
				BackgroundTransparency = 1,
				TextColor3 = Color3.fromRGB(255, 255, 255),
				TextScaled = true,
				Font = Enum.Font.JosefinSans,
			})
		end

		local function ImageLabel(props)
			return createComponent("ImageLabel", props, {
				BackgroundTransparency = 1,
				ScaleType = Enum.ScaleType.Fit,
			})
		end

		return React.createElement("ScreenGui", {
			IgnoreGuiInset = true,
			ResetOnSpawn = false,
		}, {
			Health = React.createElement(TextLabel, {
				AnchorPoint = Vector2.new(0.5, 1),
				AutomaticSize = Enum.AutomaticSize.X,
				Position = UDim2.new(0.35, 0, 1, 0),
				Size = UDim2.new(0, 0, 0.08, 0),
				Text = "100",
			}, {
				Shield = React.createElement(ImageLabel, {
					AnchorPoint = Vector2.new(1, 0),
					Size = UDim2.new(1, 0, 1, 0),
					Position = UDim2.new(0, 0, 0, -5),
					Image = "rbxassetid://15269254897",
					ImageRectOffset = Vector2.new(0, 257),
					ImageRectSize = Vector2.new(256, 256),
				}, {
					UIAspectRatioConstraint = React.createElement("UIAspectRatioConstraint"),
					ShieldHealth = React.createElement(TextLabel, {
						AnchorPoint = Vector2.new(0.5, 0.5),
						Position = UDim2.new(0.5, 1, 0.5, 2),
						Size = UDim2.new(0.5, 0, 0.5, 0),
						Text = "50",
					}),
				}),
			}),
			Magazine = React.createElement(TextLabel, {
				AnchorPoint = Vector2.new(0.5, 1),
				Position = UDim2.new(0.65, 0, 1, 0),
				Size = UDim2.new(1, 0, 0.08, 0),
				Text = "25",
			}, {
				UIAspectRatioConstraint = React.createElement("UIAspectRatioConstraint"),
				AmmoIcon = React.createElement(ImageLabel, {
					AnchorPoint = Vector2.new(0, 0.5),
					Position = UDim2.new(1, 0, 0.5, 0),
					Size = UDim2.new(1, 0, 0.5, 0),
					Image = "http://www.roblox.com/asset/?id=6011908706",
				}, {
					UIAspectRatioConstraint = React.createElement("UIAspectRatioConstraint"),
					Reserve = React.createElement(TextLabel, {
						Position = UDim2.new(1.2, 0, 0, 0),
						Size = UDim2.new(1, 0, 1, 0),
						Text = "50",
						FontFace = Font.new(tostring(Enum.Font.JosefinSans), Enum.FontWeight.Light),
					}),
				}),
			}),
			Crosshair = React.createElement("Frame", {
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundTransparency = 1,
			}, {
				Up = crosshair(UDim2.new(0, 2, 0, 8), UDim2.new(0.5, 0, 0.5, -8)),
				Left = crosshair(UDim2.new(0, 8, 0, 2), UDim2.new(0.5, -8, 0.5, 0)),
				Down = crosshair(UDim2.new(0, 2, 0, 8), UDim2.new(0.5, 0, 0.5, 8)),
				Right = crosshair(UDim2.new(0, 8, 0, 2), UDim2.new(0.5, 8, 0.5, 0)),
			}),
			-- local count, setCount = React.useState(0)
			-- CurrentCount = React.createElement("TextLabel", {
			-- 	Text = count,
			-- }),
			-- IncrementButton = React.createElement("TextButton", {
			-- 	Text = "Increment",

			-- 	[React.Event.Activated] = function()
			-- 		setCount(count + 1)
			-- 	end
			-- })
		})
	end

	local root = ReactRoblox.createRoot(Instance.new("Folder"))
	root:render(ReactRoblox.createPortal(React.createElement(HUD), Players.LocalPlayer.PlayerGui))
end

return module
