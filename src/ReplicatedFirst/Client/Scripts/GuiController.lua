local StarterGui = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local react = _G.react

StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, false)
StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, true)

UserInputService.MouseIconEnabled = false

local app = react.createElement("ScreenGui", {
    IgnoreGuiInset = false
}, {
    Magazine = react.createElement("TextLabel", {
      Size = UDim2.new(0.1, 0, 0.1, 0),
      Text = "25"
    }, {
        Reserve = react.createElement("TextLabel", {
            Anchor = UDim.new(1, 0),
            Position = UDim2.new(1, 0, 0, 0),
            Size = UDim2.new(0.1, 0, 0.1, 0),
            Text = "50"
        })
    })
})

react.mount(app, Players.LocalPlayer.PlayerGyu)

return {}