local module = {}
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local remotesFolder = ReplicatedStorage.Remotes
local healthChangedEvent = remotesFolder.HealthChanged
local shieldChangedEvent = remotesFolder.ShieldChanged
local gunFiredTime = {}
local playersCurrentGun = {}
local GunsStats

function module.Initiate()
	GunsStats = _G.GunsStats
end

local function raycastBullet(player: Player, mouseUnitRayDirection: Vector3, spread: Vector3)
	if gunFiredTime[player] then
		if os.clock() - gunFiredTime[player] < GunsStats[playersCurrentGun[player]]["SecondsPerRound"] then
			return
		end
	end

	local character = player.Character
	gunFiredTime[player] = os.clock()

	return _G.RaycastBullet(character, character.Head.Position, mouseUnitRayDirection, spread)
end

local function createBulletHole(playerWhoFired: Player, raycastResult: RaycastResult)
	for _, player in ipairs(Players:GetPlayers()) do
		if player == playerWhoFired then
			continue
		end

		remotesFolder.CreateBulletHole:FireClient(player, raycastResult.Instance, raycastResult.Position)
	end
end

local function raycastDamage(playerWhoFired: Player, mouseUnitRayDirection: Vector3, spread: Vector3)
	local character = playerWhoFired.Character
	local raycastResult = raycastBullet(playerWhoFired, mouseUnitRayDirection, spread)

		if raycastResult then
			local instance = raycastResult.Instance
			local character = instance.Parent
			local humanoid = character:FindFirstChildWhichIsA("Humanoid")

			if humanoid then
				local instanceName = instance.Name

				local currentGunStats = GunsStats[playersCurrentGun[playerWhoFired]]
				local damage

				if string.find(instanceName, "Leg") then
					damage = currentGunStats["LegDamage"]
				elseif instanceName == "Head" then
					damage = currentGunStats["HeadDamage"]
				else
					damage = currentGunStats["BodyDamage"]
				end

				humanoid:TakeDamage(damage)

				for _, player in ipairs(Players:GetPlayers()) do
					if character == player.Character then
						healthChangedEvent:FireClient(player, math.round(humanoid.Health))
						break
					end
				end
			else
				createBulletHole(playerWhoFired, raycastResult)
			end
		end
end

Players.PlayerAdded:Connect(function(player: Player)
	playersCurrentGun[player] = "Vandal"
	remotesFolder.ChangeGun:FireClient(player, "Vandal")

	player.CharacterAdded:Connect(function()
		healthChangedEvent:FireClient(player, 100)
		shieldChangedEvent:FireClient(player, 0)
	end)
end)

Players.PlayerRemoving:Connect(function(player: Player)
	playersCurrentGun[player] = nil
end)

remotesFolder.BulletHitSurface.OnServerEvent:Connect(
	function(playerWhoFired: Player, mouseUnitRayDirection: Vector3, spread: Vector3)
		local raycastResult = raycastBullet(playerWhoFired, mouseUnitRayDirection, spread)

		if raycastResult then
			local instance = raycastResult.Instance
			local position = raycastResult.Position
			local instancePenetration = instance:GetAttribute("Penetration")

			createBulletHole(playerWhoFired, raycastResult, false)

			if not instance:GetAttribute("Penetration") then
				return
			end

			if playersCurrentGun[playerWhoFired]["Penetration"] < instancePenetration then
				return
			end

			local wallbangRaycastResult = _G.RaycastBullet(playerWhoFired.Character, position + mouseUnitRayDirection * 10, -mouseUnitRayDirection, Vector3.new(0, 0, 0))
			--wall bang
		end
	end
)

remotesFolder.BulletHitCharacter.OnServerEvent:Connect(
	function(playerWhoFired: Player, mouseUnitRayDirection: Vector3, spread: Vector3)
		raycastDamage(playerWhoFired, mouseUnitRayDirection, spread)
	end
)

return module
