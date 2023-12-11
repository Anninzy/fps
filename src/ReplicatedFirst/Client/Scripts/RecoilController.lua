local module = {}
local preRender

function module.Initiate()
	local RunService = game:GetService("RunService")
	local camera = workspace.CurrentCamera
	local WeaponController = _G.WeaponController
	local WeaponStatsService = _G.WeaponStatsService

	function module.StartRecoil()
		local alpha = 0
		local framesRan = 0
		local increment = 0.1
		local offset = CFrame.Angles(0, 0, 0)
		local sprayPattern = WeaponStatsService[WeaponController.CurrentWeapon]["SprayPattern"]
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

					alpha = 0
					crosshairPosition = sprayPattern[sprayPatternIndex]
					noOffsetCameraCFrame = camera.CFrame
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

	function module.SingleRecoil() --TEMPORARY
		local alpha = 0
		local increment = 0.25
		local offset = CFrame.Angles(0, 0, 0)
		local sprayPattern = WeaponStatsService[WeaponController.CurrentWeapon]["SprayPattern"]
		local sprayPatternIndex = 1
		local crosshairPosition = sprayPattern[sprayPatternIndex]
		local noOffsetCameraCFrame

		preRender = RunService.PreRender:Connect(function()
			noOffsetCameraCFrame = camera.CFrame * offset:Inverse()
			alpha = math.clamp(alpha + increment, 0, 1)
			offset = CFrame.Angles(0, 0, 0):Lerp(crosshairPosition, alpha)
			camera.CFrame = noOffsetCameraCFrame * offset

			if alpha == 1 then
				preRender:Disconnect()
			end
		end)
	end
end

function module.EndRecoil()
	preRender:Disconnect()
end

return module
