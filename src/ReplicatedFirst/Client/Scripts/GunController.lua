local module = {}
local ContextActionService = game:GetService("ContextActionService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local localPlayer = Players.LocalPlayer
local remotesFolder = ReplicatedStorage.Remotes
local firstShot = true
local isFiring = false
local GuiController
local GunsStats
local RaycastBullet
local RecoilController
module.CurrentGun = ""

remotesFolder.ChangeGun.OnClientEvent:Connect(function(gunName: string)
	module.CurrentGun = gunName
end)

function module.Initiate()
	GuiController = _G.GuiController
	GunsStats = _G.GunsStats
	RaycastBullet = _G.RaycastBullet
	RecoilController = _G.RecoilController
end

local function raycastBullet()
	local mouseLocation = UserInputService:GetMouseLocation()
	local mouseUnitRayDirection = workspace.CurrentCamera:ViewportPointToRay(mouseLocation.X, mouseLocation.Y).Direction
	local spread = Vector3.new(math.random(-100, 100), math.random(-100, 100), math.random(-100, 100))
	local velocity = localPlayer.Character.HumanoidRootPart.AssemblyLinearVelocity
	velocity = Vector3.new(math.round(velocity.X), math.round(velocity.Y), math.round(velocity.Z))

	if velocity == Vector3.new(0, 0, 0) then
		if firstShot then
			firstShot = false
			spread = Vector3.new(0, 0, 0)
		else
			spread /= 10
		end
	end

	local raycastResult = RaycastBullet(localPlayer, mouseUnitRayDirection, spread)

	if raycastResult then
		local instance = raycastResult.Instance

		if instance.Parent:FindFirstChildWhichIsA("Humanoid") then
			remotesFolder.BulletHitCharacter:FireServer(mouseUnitRayDirection, spread)
		else
			GuiController.CreateBulletHole(instance, raycastResult.Position)
			remotesFolder.BulletHitSurface:FireServer(mouseUnitRayDirection, spread)
		end
	end
end

local function handleFiringGun(_actionName, userInputState, _inputObject)
	if userInputState == Enum.UserInputState.Begin then
		local currentGunStats = GunsStats[module.CurrentGun]

		if currentGunStats["CanSpray"] then
			firstShot = true
			isFiring = true
			RecoilController.StartRecoil()

			repeat
				raycastBullet()
				task.wait(currentGunStats["SecondsPerRound"])
			until not isFiring

			RecoilController.EndRecoil()
		else
			RecoilController.Recoil()
			raycastBullet()
		end
	elseif userInputState == Enum.UserInputState.End then
		isFiring = false
	end
end

ContextActionService:BindAction("FiringGun", handleFiringGun, false, Enum.UserInputType.MouseButton1)

return module
