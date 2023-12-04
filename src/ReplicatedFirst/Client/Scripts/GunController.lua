local module = {}
local ContextActionService = game:GetService("ContextActionService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local remotesFolder = ReplicatedStorage.Remotes
local isFiring = false
local recoilController
local guiController
module.CurrentGun = "Vandal"

function module.Initiate()
	recoilController = _G.RecoilController
	guiController = _G.GuiController
end

local function raycastBullet()
	local mouseLocation = UserInputService:GetMouseLocation()
	local mouseUnitRayDirection = workspace.CurrentCamera:ViewportPointToRay(mouseLocation.X, mouseLocation.Y).Direction

	local raycastResult = _G.RaycastBullet(Players.LocalPlayer, mouseUnitRayDirection)
	if raycastResult then
		local instance = raycastResult.Instance

		if instance.Parent:FindFirstChildWhichIsA("Humanoid") then
			remotesFolder.BulletHitCharacter:FireServer(mouseUnitRayDirection)
		else
			guiController.CreateBulletHole(instance, raycastResult.Position)
			remotesFolder.BulletHitSurface:FireServer(mouseUnitRayDirection)
		end
	end
end

local function handleFiringGun(_actionName, userInputState, _inputObject)
	if userInputState == Enum.UserInputState.Begin then
		local gunStats = _G.GunStats[module.CurrentGun]

		if gunStats["CanSpray"] then
			isFiring = true
			recoilController.StartRecoil()

			repeat
				raycastBullet()
				task.wait(gunStats["SecondsPerRound"])
			until not isFiring

			recoilController.EndRecoil()
		else
			recoilController.Recoil()
			raycastBullet()
		end
	elseif userInputState == Enum.UserInputState.End then
		isFiring = false
	end
end

ContextActionService:BindAction("FiringGun", handleFiringGun, false, Enum.UserInputType.MouseButton1)

return module
