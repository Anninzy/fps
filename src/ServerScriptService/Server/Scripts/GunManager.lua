local module = {}
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local remotesFolder = ReplicatedStorage.Remotes
local gunFiredTime = {}
local playersCurrentGun = {}
local GunsStats

function module.Initiate()
	GunsStats = _G.GunsStats
end

local function raycastBullet(player: Player, mouseUnitRayDirection: Vector3)
	if gunFiredTime[player] then
		if os.clock() - gunFiredTime[player] < GunsStats[playersCurrentGun[player]]["SecondsPerRound"] then
			return
		end
	end

	gunFiredTime[player] = os.clock()

	return _G.RaycastBullet(player, mouseUnitRayDirection)
end

Players.PlayerAdded:Connect(function(player)
	playersCurrentGun[player] = "Vandal"
end)

remotesFolder.BulletHitSurface.OnServerEvent:Connect(function(playerWhoFired: Player, mouseUnitRayDirection: Vector3)
	local raycastResult = raycastBullet(playerWhoFired, mouseUnitRayDirection)

	if raycastResult then
		for _, player in ipairs(Players:GetPlayers()) do
			if player == playerWhoFired then
				continue
			end

			remotesFolder.CreateBulletHole:FireClient(player, raycastResult.Instance, raycastResult.Position)
		end
	end
end)

remotesFolder.BulletHitCharacter.OnServerEvent:Connect(function(playerWhoFired: Player, mouseUnitRayDirection: Vector3)
	local raycastResult = raycastBullet(playerWhoFired, mouseUnitRayDirection)

	if raycastResult then
		local instance = raycastResult.Instance
		local instanceName = instance.Name
		local character = instance.Parent
		local currentGunStats = GunsStats[playersCurrentGun[playerWhoFired]]
		local damage

		if string.find(instanceName, "Leg") then
			damage = currentGunStats["LegDamage"]
		elseif instanceName == "Head" then
			damage = currentGunStats["HeadDamage"]
		else
			damage = currentGunStats["BodyDamage"]
		end

		character.Humanoid:TakeDamage(damage) --Might want to swap out for custom character, who knows.

		for _, player in ipairs(Players:GetPlayers()) do
			if character == player.Character then
				remotesFolder.HealthChanged:FireClient(player, character.Humanoid.Health)
				break
			end
		end
	end
end)

return module
