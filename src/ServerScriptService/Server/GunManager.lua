local ReplicatedStorage = game:GetService("ReplicatedStorage")
local remotesFolder = ReplicatedStorage.Remotes

local gunFiredTime = {}

local gunRaycastParams = RaycastParams.new()
gunRaycastParams.FilterType = Enum.RaycastFilterType.Exclude

remotesFolder.FiringGun.OnServerEvent:Connect(function(player, mouseUnitRay)
	if not mouseUnitRay then
		return
	end
	
	local gunStats = require(ReplicatedStorage.Modules.GunsStats)["UnnamedGun"]
	
	if gunFiredTime[player] then
		if os.clock() - gunFiredTime[player] < gunStats["SecondsPerRound"] then
			return
		end
	end
	
	local character = player.Character

	gunRaycastParams.FilterDescendantsInstances = {character}

	local gunRaycastResult = workspace:Raycast(character.Head.Position, mouseUnitRay.Direction * 1000, gunRaycastParams)
	if gunRaycastResult then
		print(gunRaycastResult.Instance)
	end
	
	gunFiredTime[player] = os.clock()
end)

return {}