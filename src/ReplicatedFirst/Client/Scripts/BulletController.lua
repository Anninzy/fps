local module = {}
local ContextActionService = game:GetService("ContextActionService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local localPlayer = Players.LocalPlayer
local remotesFolder = ReplicatedStorage.Remotes
local firstShot = true
local isFiring = false
local BulletService
local GuiController
local RecoilController
local WeaponController
local WeaponStatsService

function module.Initiate()
	BulletService = _G.BulletService
	GuiController = _G.GuiController
	RecoilController = _G.RecoilController
	WeaponController = _G.WeaponController
	WeaponStatsService = _G.WeaponStatsService
end

local function raycastBullet()
	local character = localPlayer.Character
	local mouseLocation = UserInputService:GetMouseLocation()
	local mouseUnitRayDirection = workspace.CurrentCamera:ViewportPointToRay(mouseLocation.X, mouseLocation.Y).Direction
	local spread = Vector3.new(math.random(-100, 100), math.random(-100, 100), math.random(-100, 100))
	local magnitude = character.HumanoidRootPart.AssemblyLinearVelocity.Magnitude

	if magnitude < 2 then
		if firstShot then
			firstShot = false
			spread = Vector3.new(0, 0, 0)
		else
			spread /= 10
		end
	end

	local raycastResult = BulletService(character, character.Head.Position, mouseUnitRayDirection, spread)

	if raycastResult then
		local instance = raycastResult.Instance

		if instance.Parent:FindFirstChildWhichIsA("Humanoid") then
			remotesFolder.HitCharacter:FireServer(mouseUnitRayDirection, spread)
		else
			GuiController.CreateBulletHole(instance, raycastResult.Position)
			remotesFolder.HitSurface:FireServer(mouseUnitRayDirection, spread)
		end
	end
end

local function handleFiringBullet(_actionName, userInputState, _inputObject)
	if userInputState == Enum.UserInputState.Begin then
		local weaponStats = WeaponStatsService[WeaponController.CurrentWeapon]

		if weaponStats["CanSpray"] then
			firstShot = true
			isFiring = true
			RecoilController.StartRecoil()

			repeat
				raycastBullet()
				task.wait(weaponStats["SecondsPerRound"])
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

ContextActionService:BindAction("FiringBullet", handleFiringBullet, false, Enum.UserInputType.MouseButton1)

return module
