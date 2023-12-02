local ReplicatedStorage = game:GetService("ReplicatedStorage")
local remotesFolder = ReplicatedStorage.Remotes

local gunFiredTime = {}

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

	local gunRaycastResult = require(ReplicatedStorage.Modules.RaycastBullet).Raycast(player, mouseUnitRay)
	if gunRaycastResult then
		remotesFolder.CreateBulletHole:FireAllClients(player, gunRaycastResult.Instance, gunRaycastResult.Position)
	end

	gunFiredTime[player] = os.clock()
end)

return {}
