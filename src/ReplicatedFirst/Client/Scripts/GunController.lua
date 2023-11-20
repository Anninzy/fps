local module = {}
local ContextActionService = game:GetService("ContextActionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local isFiring = false

local function handleFiringGun(_actionName, userInputState, inputObject)
	if userInputState == Enum.UserInputState.Begin then
		local recoilController = _G.RecoilController
		local gunStats = require(ReplicatedStorage.Modules.GunsStats)["UnnamedGun"]

		local function sendMousePosition()
			local inputPosition = inputObject.Position
			ReplicatedStorage.Remotes.FiringGun:FireServer(workspace.CurrentCamera:ScreenPointToRay(inputPosition.X, inputPosition.Y))
		end
		
		sendMousePosition()
		recoilController.StartRecoil()
		
		if gunStats["CanHoldFire"] then
			isFiring = true
			
			repeat task.wait()
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