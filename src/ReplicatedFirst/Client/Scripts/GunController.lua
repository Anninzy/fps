local module = {}
local ContextActionService = game:GetService("ContextActionService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local remotesFolder = ReplicatedStorage.Remotes
local isFiring = false
local RecoilController
local GuiController
local GunsStats
local RaycastBullet
module.CurrentGun = "Vandal"

function module.Initiate()
	RecoilController = _G.RecoilController
	GuiController = _G.GuiController
	GunsStats = _G.GunsStats
	RaycastBullet = _G.RaycastBullet
end

local function raycastBullet()
	local mouseLocation = UserInputService:GetMouseLocation()
	local mouseUnitRayDirection = workspace.CurrentCamera:ViewportPointToRay(mouseLocation.X, mouseLocation.Y).Direction
	local raycastResult = RaycastBullet(Players.LocalPlayer, mouseUnitRayDirection)

	if raycastResult then
		local instance = raycastResult.Instance

		if instance.Parent:FindFirstChildWhichIsA("Humanoid") then
			remotesFolder.BulletHitCharacter:FireServer(mouseUnitRayDirection)
		else
			GuiController.CreateBulletHole(instance, raycastResult.Position)
			remotesFolder.BulletHitSurface:FireServer(mouseUnitRayDirection)
		end
	end
end

local function handleFiringGun(_actionName, userInputState, _inputObject)
	if userInputState == Enum.UserInputState.Begin then
		local currentGunStats = GunsStats[module.CurrentGun]

		if currentGunStats["CanSpray"] then
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
