local ReplicatedStorage = game:GetService("ReplicatedStorage")
local remotesFolder = ReplicatedStorage.Remotes
local gunFiredTime = {}

local function raycastBullet(player, mouseUnitRayDirection)
	local gunStats = _G.GunStats["Vandal"]

	if gunFiredTime[player] then
		if os.clock() - gunFiredTime[player] < gunStats["SecondsPerRound"] then
			return
		end
	end

	gunFiredTime[player] = os.clock()

	return _G.RaycastBullet(player, mouseUnitRayDirection)
end

remotesFolder.BulletHitSurface.OnServerEvent:Connect(function(player, mouseUnitRayDirection)
	local raycastResult = raycastBullet(player, mouseUnitRayDirection)
	if raycastResult then
		remotesFolder.CreateBulletHole:FireAllClients(player, raycastResult.Instance, raycastResult.Position)
	end
end)

return {}
