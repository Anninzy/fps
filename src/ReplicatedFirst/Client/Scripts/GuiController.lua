local StarterGui = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local react = _G.react

StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, false)
StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, true)

UserInputService.MouseIconEnabled = false

local hud = react.Component:extend("HUD")

function hud:Init()
    self:setState({
        magazine = "25",
        reserve = "50"
    })
end

function hud:render()
    local state = self.state

    return react.createElement("ScreenGui", {
        IgnoreGuiInset = false
    }, {
        Magazine = react.createElement("TextLabel", {
          Size = UDim2.new(0.1, 0, 0.1, 0),
          Text = state.magazine
        }, {
            Reserve = react.createElement("TextLabel", {
                Anchor = UDim.new(1, 0),
                Position = UDim2.new(1, 0, 0, 0),
                Size = UDim2.new(0.1, 0, 0.1, 0),
                Text = state.reserve
            })
        })
    })
end

function hud:didMount()
    --on ammo change, update
    --[[
    self:setState(function(state)
        return {
            magazine = "",
            reserve = ""
        }
    end)
    ]]
end

react.mount(react.createElement(hud), Players.LocalPlayer.PlayerGui, "HUD")

return {}