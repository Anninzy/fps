if not game:IsLoaded() then
	repeat
		task.wait()
	until game.Loaded
end

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local camera = workspace.CurrentCamera
local localPlayer = Players.LocalPlayer

local viewModel = ReplicatedStorage:WaitForChild("Models").ViewModel:Clone()
local preRender

localPlayer.CharacterAdded:Connect(function()
	viewModel.Parent = camera
	
	preRender = RunService.PreRender:Connect(function()
		viewModel:PivotTo(camera.CFrame)
	end)
end)

localPlayer.CharacterRemoving:Connect(function()
	preRender:Disconnect()
	viewModel.Parent = nil
end)

return {}