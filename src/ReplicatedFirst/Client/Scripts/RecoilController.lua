local module = {}
local RunService = game:GetService("RunService")
local camera = workspace.CurrentCamera
local preRender
local GunController
local GunsStats

function module.Initiate()
	GunController = _G.GunController
	GunsStats = _G.GunsStats
end

function module.StartRecoil()
	local alpha = 0
	local framesRan = 0
	local increment = 0.1
	local offset = CFrame.Angles(0, 0, 0)
	local sprayPattern = GunsStats[GunController.CurrentGun]["SprayPattern"]
	local sprayPatternIndex = 1
	local sprayStageStartTime = os.clock()
	local crosshairPosition = sprayPattern[sprayPatternIndex]
	local noOffsetCameraCFrame

	preRender = RunService.PreRender:Connect(function()
		if framesRan % 3 == 0 then
			noOffsetCameraCFrame = camera.CFrame * offset:Inverse()

			if os.clock() - sprayStageStartTime >= 2 then
				if sprayPatternIndex + 1 > #sprayPattern then
					sprayPatternIndex = 1
				else
					sprayPatternIndex += 1
				end

				if typeof(sprayPattern[sprayPatternIndex]) == "table" then
					increment *= 2
					sprayPattern = sprayPattern[sprayPatternIndex]
					sprayPatternIndex = 1
				end

				crosshairPosition = sprayPattern[sprayPatternIndex]
				noOffsetCameraCFrame = camera.CFrame
				alpha = 0
				sprayStageStartTime = os.clock()
			end

			alpha = math.clamp(alpha + increment, 0, 1)
			offset = CFrame.Angles(0, 0, 0):Lerp(crosshairPosition, alpha)
			camera.CFrame = noOffsetCameraCFrame * offset
		elseif framesRan % 3 == 1 then
			camera.CFrame *= CFrame.Angles(math.rad(-1), 0, 0)
		elseif framesRan % 3 == 2 then
			camera.CFrame *= CFrame.Angles(math.rad(1), 0, 0)
		end

		framesRan += 1
	end)
end

function module.EndRecoil()
	preRender:Disconnect()
end

function module.Recoil() end

return module
