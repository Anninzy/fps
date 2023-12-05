local module = {}
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService")
local remotesFolder = ReplicatedStorage.Remotes

StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, false)
StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, true)
UserInputService.MouseIconEnabled = false

function module.Initiate()
	local React = _G.React
	local ReactRoblox = _G.ReactRoblox
	local createElement = React.createElement
	local useState = React.useState
	local createPortal = ReactRoblox.createPortal
	local createRoot = ReactRoblox.createRoot
	local playerGui = Players.LocalPlayer.PlayerGui

	local function createComponent(uiType, props, defaultProps)
		for key, value in pairs(props) do
			if key == "children" then
				continue
			end

			defaultProps[key] = value
		end

		return createElement(uiType, defaultProps, props.children)
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

	local function HUD()
		local health, setHealth = useState(100)
		local shield, setShield = useState(0)

		remotesFolder.HealthChanged.OnClientEvent:Connect(function(newHealth: number)
			setHealth(newHealth)
		end)

		remotesFolder.ShieldChanged.OnClientEvent:Connect(function(newShield: number)
			setShield(newShield)
		end)

		local function crosshair(size, position)
			return createElement("Frame", {
				Size = size,
				Position = position,
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			}, {
				createElement("UIStroke"),
			})
		end

		return createElement("ScreenGui", {
			IgnoreGuiInset = true,
			ResetOnSpawn = false,
		}, {
			Health = createElement(TextLabel, {
				AnchorPoint = Vector2.new(0.5, 1),
				Position = UDim2.new(0.35, 0, 1, 0),
				Size = UDim2.new(0.06, 0, 0.08, 0),
				Text = health,
			}, {
				Shield = createElement(ImageLabel, {
					AnchorPoint = Vector2.new(1, 0.5),
					Size = UDim2.new(0.5, 0, 1, 0),
					Position = UDim2.new(0, 0, 0.5, -5),
					Image = "rbxassetid://15269254897",
					ImageRectOffset = Vector2.new(0, 257),
					ImageRectSize = Vector2.new(256, 256),
				}, {
					UIAspectRatioConstraint = createElement("UIAspectRatioConstraint"),
					ShieldHealth = createElement(TextLabel, {
						AnchorPoint = Vector2.new(0.5, 0.5),
						Position = UDim2.new(0.5, 1, 0.5, 2),
						Size = UDim2.new(0.5, 0, 0.5, 0),
						Text = shield,
					}),
				}),
			}),
			Magazine = createElement(TextLabel, {
				AnchorPoint = Vector2.new(0.5, 1),
				Position = UDim2.new(0.65, 0, 1, 0),
				Size = UDim2.new(1, 0, 0.08, 0),
				Text = "25",
			}, {
				UIAspectRatioConstraint = createElement("UIAspectRatioConstraint"),
				AmmoIcon = createElement(ImageLabel, {
					AnchorPoint = Vector2.new(0, 0.5),
					Position = UDim2.new(1, 0, 0.5, 0),
					Size = UDim2.new(1, 0, 0.5, 0),
					Image = "http://www.roblox.com/asset/?id=6011908706",
				}, {
					UIAspectRatioConstraint = createElement("UIAspectRatioConstraint"),
					Reserve = createElement(TextLabel, {
						Position = UDim2.new(1.2, 0, 0, 0),
						Size = UDim2.new(1, 0, 1, 0),
						Text = "50",
						FontFace = Font.new(tostring(Enum.Font.JosefinSans), Enum.FontWeight.Light),
					}),
				}),
			}),
			Crosshair = createElement("Frame", {
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundTransparency = 1,
			}, {
				Up = crosshair(UDim2.new(0, 2, 0, 8), UDim2.new(0.5, 0, 0.5, -8)),
				Left = crosshair(UDim2.new(0, 8, 0, 2), UDim2.new(0.5, -8, 0.5, 0)),
				Down = crosshair(UDim2.new(0, 2, 0, 8), UDim2.new(0.5, 0, 0.5, 8)),
				Right = crosshair(UDim2.new(0, 8, 0, 2), UDim2.new(0.5, 8, 0.5, 0)),
			}),
		})
	end

	local root = createRoot(Instance.new("Folder"))
	root:render(createPortal(createElement(HUD), playerGui, "HUD"))

	function module.CreateBulletHole(instance: Instance, position: Vector3)
		local DECAL_SIZE = 1
		local SCALE = 128
		local SurfaceFace, Width, Height, RelativeX, RelativeY =
			_G.WorldToGui:WorldPositionToGuiPosition(instance, position)

		local function BulletHoleGui()
			return createElement("SurfaceGui", {
				CanvasSize = Vector2.new(SCALE * Width, SCALE * Height),
				LightInfluence = 1,
				Face = SurfaceFace,
				Adornee = instance,
			}, {
				Clip = createElement("Frame", {
					Size = UDim2.new(1, 0, 1, 0),
					BackgroundTransparency = 1,
					ClipsDescendants = true,
				}, {
					Hole = createElement(ImageLabel, {
						Size = UDim2.new(0, SCALE * DECAL_SIZE, 0, SCALE * DECAL_SIZE),
						AnchorPoint = Vector2.new(0.5, 0.5),
						Position = UDim2.new(RelativeX, 0, RelativeY, 0),
						Image = "http://www.roblox.com/asset/?id=11543553259",
						ImageTransparency = 0.25,
					}),
				}),
			})
		end

		local surfaceGuiRoot = createRoot(Instance.new("Folder"))
		surfaceGuiRoot:render(createPortal(createElement(BulletHoleGui), playerGui, "BulletHole"))

		coroutine.wrap(function()
			task.wait(5)
			surfaceGuiRoot:unmount()
		end)()
	end

	remotesFolder.CreateBulletHole.OnClientEvent:Connect(function(instance: Instance, position: Vector3)
		module.CreateBulletHole(instance, position)
	end)
end

return module
