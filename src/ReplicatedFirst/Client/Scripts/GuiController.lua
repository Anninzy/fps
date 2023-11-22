local module = {}
local StarterGui = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, false)
StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, true)

UserInputService.MouseIconEnabled = false

function module.Initiate()
	-- 	local react = _G.react
	-- 	local reactRoblox = _G.reactRoblox

	--     function hud()
	--         return react.createElement("ScreenGui", {
	-- 			IgnoreGuiInset = false,
	-- 		}, {
	-- 			Magazine = react.createElement("TextLabel", {
	-- 				Size = UDim2.new(0.1, 0, 0.1, 0),
	-- 				Text = "test",
	-- 			}, {
	-- 				Reserve = react.createElement("TextLabel", {
	-- 					Anchor = UDim.new(1, 0),
	-- 					Position = UDim2.new(1, 0, 0, 0),
	-- 					Size = UDim2.new(0.1, 0, 0.1, 0),
	-- 					Text = "test2",
	-- 				}),
	-- 			}),
	-- 		})
	-- 	end

	--     local PlayerGui = Players.LocalPlayer.PlayerGui
	--     local root = reactRoblox.createRoot(Instance.new("ScreenGui", PlayerGui))
	--     root:render(reactRoblox.createPortal(hud, PlayerGui))

	local React = _G.react
	local ReactRoblox = _G.reactRoblox
	local playerGui = Players.LocalPlayer.PlayerGui

	-- local function App()
	-- 	return React.createElement("ScreenGui", {
	-- 		IgnoreGuiInset = false,
	-- 		ResetOnSpawn = false,
	-- 	}, {
	-- 		Magazine = React.createElement("TextLabel", {
	-- 			AnchorPoint = Vector2.new(1, 1),
	-- 			Position = UDim2.new(0.9, 0, 1, 0),
	-- 			Size = UDim2.new(0.08, 0, 0.08, 0),
	-- 			TextXAlignment = Enum.TextXAlignment.Right,
	-- 			BackgroundTransparency = 1,
	-- 			TextColor3 = Color3.fromRGB(255, 255, 255),
    --             TextScaled = true,
	-- 			Text = "25",
	-- 		}, {
	-- 			Reserve = React.createElement("TextLabel", {
	-- 				AnchorPoint = Vector2.new(0, 1),
	-- 				Position = UDim2.new(1.1, 0, 1, 0),
	-- 				Size = UDim2.new(1, 0, 0.75, 0),
	-- 				TextXAlignment = Enum.TextXAlignment.Left,
	-- 				BackgroundTransparency = 1,
	-- 				TextColor3 = Color3.fromRGB(255, 255, 255),
    --                 TextScaled = true,
	-- 				Text = "50",
	-- 			}, {
    --                 UIStroke = React.createElement("UIStroke")
    --             }),
    --             UIStroke = React.createElement("UIStroke")
	-- 		}),
	-- 	})
	-- end

	-- local element = React.createElement(App)

	-- local root = ReactRoblox.createRoot(Instance.new("Folder"))
	-- root:render(ReactRoblox.createPortal(element, playerGui))


	local function Counter()
		local count, setCount = React.useState(0)
	
		return React.createElement("Frame", {}, {
			CurrentCount = React.createElement("TextLabel", {
				Text = count,
			}),
			IncrementButton = React.createElement("TextButton", {
				Text = "Increment",
	
				[React.Event.Activated] = function()
					setCount(count + 1)
				end
			})
		})
	end
	
	local root = ReactRoblox.createRoot(Instance.new("Folder"))
	root:render(ReactRoblox.createPortal(React.createElement(Counter), playerGui))
end

return module
