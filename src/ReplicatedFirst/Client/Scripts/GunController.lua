local module = {}
local ContextActionService = game:GetService("ContextActionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local isFiring = false

local function handleFiringGun(_actionName, userInputState, inputObject)
	if userInputState == Enum.UserInputState.Begin then
		local recoilController = _G.RecoilController
		local gunStats = require(ReplicatedStorage.Modules.GunsStats)["UnnamedGun"]

		local function getMouseUnityRay()
			local inputPosition = inputObject.Position
			return workspace.CurrentCamera:ScreenPointToRay(inputPosition.X, inputPosition.Y)
		end

		local function sendMousePosition()
			local gunRaycastResult =
				require(ReplicatedStorage.Modules.RaycastBullet).Raycast(Players.LocalPlayer, getMouseUnityRay())
			_G.GuiController.CreateBulletHole(gunRaycastResult.Instance, gunRaycastResult.Position)
			ReplicatedStorage.Remotes.FiringGun:FireServer(getMouseUnityRay())
		end

		sendMousePosition()
		recoilController.StartRecoil()

		if gunStats["CanHoldFire"] then
			isFiring = true

			repeat
				task.wait(gunStats["SecondsPerRound"])
				sendMousePosition()
			until not isFiring
		end

		recoilController.EndRecoil()
	elseif userInputState == Enum.UserInputState.End then
		isFiring = false
	end
end

ContextActionService:BindAction("FiringGun", handleFiringGun, false, Enum.UserInputType.MouseButton1)

return module
