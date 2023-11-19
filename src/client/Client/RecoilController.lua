if not game:IsLoaded() then
	repeat
		task.wait()
	until game.Loaded
end

local module = {}
local RunService = game:GetService("RunService")
local camera = workspace.CurrentCamera
local gunStats = require(game.ReplicatedStorage.Modules.GunsStats)["UnnamedGun"]
local preRender
local cameraAngleOffset = gunStats["RecoilCameraOffset"][1] --make it so that it changes depending on the heat
local totalOffsetAppliedUp

function module.StartRecoil()
	local alpha = 0
	local increment = 0.05
	totalOffsetAppliedUp = CFrame.Angles(0, 0, 0)

	preRender = RunService.PreRender:Connect(function()
		alpha = math.clamp(alpha + increment, 0, 1)
		local cameraCFrameNoOffset = camera.CFrame * totalOffsetAppliedUp:Inverse()
		totalOffsetAppliedUp = CFrame.Angles(0, 0, 0):Lerp(cameraAngleOffset, alpha)
		camera.CFrame = cameraCFrameNoOffset * totalOffsetAppliedUp
	end)
end

function module.EndRecoil()
	preRender:Disconnect()
	
	local alpha = 0
	local increment = 0.05
	local totalOffsetAppliedDown = CFrame.Angles(0, 0, 0)
	
	preRender = RunService.PreRender:Connect(function()
		alpha = math.clamp(alpha + increment, 0, 1)
		local cameraCFrameNoOffset = camera.CFrame * totalOffsetAppliedDown:Inverse()
		totalOffsetAppliedDown = CFrame.Angles(0, 0, 0):Lerp(totalOffsetAppliedUp:Inverse(), alpha)
		camera.CFrame = cameraCFrameNoOffset * totalOffsetAppliedDown
		
		if alpha == 1 then
			preRender:Disconnect()
			return
		end
	end)
end

return module