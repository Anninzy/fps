local module = {}
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local remotesFolder = ReplicatedStorage.Remotes
local healthChangedEvent = remotesFolder.HealthChanged
local shieldChangedEvent = remotesFolder.ShieldChanged
local equippedWeapon = {}
local weaponFiredTime = {}
local BulletService
local WeaponStatsService

function module.Initiate()
	BulletService = _G.BulletService
	WeaponStatsService = _G.WeaponStatsService
end

local function createBulletHole(playerWhoFired: any, raycastResult: RaycastResult)
	for _, player in ipairs(Players:GetPlayers()) do
		if player == playerWhoFired then
			continue
		end

		remotesFolder.CreateBulletHole:FireClient(player, raycastResult.Instance, raycastResult.Position)
	end
end

local function raycastDamage(playerWhoFired: Player, origin: Vector3, direction: Vector3, spread: Vector3)
	if weaponFiredTime[playerWhoFired] then
		if
			os.clock() - weaponFiredTime[playerWhoFired]
			< WeaponStatsService[equippedWeapon[playerWhoFired]]["SecondsPerRound"]
		then
			return
		end
	end

	weaponFiredTime[playerWhoFired] = os.clock()

	local raycastResult = BulletService(playerWhoFired.Character, origin, direction, spread)

	if raycastResult then
		local instance = raycastResult.Instance
		local character = instance.Parent
		local humanoid = character:FindFirstChildWhichIsA("Humanoid")

		if humanoid then
			local instanceName = instance.Name
			local weaponStats = WeaponStatsService[equippedWeapon[playerWhoFired]]
			local damage

			if string.find(instanceName, "Leg") then
				damage = weaponStats["LegDamage"]
			elseif instanceName == "Head" then
				damage = weaponStats["HeadDamage"]
			else
				damage = weaponStats["BodyDamage"]
			end

			humanoid:TakeDamage(damage)

			local player = Players:GetPlayerFromCharacter(character)

			if player then
				healthChangedEvent:FireClient(player, math.round(humanoid.Health))
			end
		else
			createBulletHole(playerWhoFired, raycastResult)
		end
	end
end

Players.PlayerAdded:Connect(function(player: Player)
	equippedWeapon[player] = "Vandal"

	player.CharacterAdded:Connect(function()
		healthChangedEvent:FireClient(player, 100)
		shieldChangedEvent:FireClient(player, 0)
	end)
end)

Players.PlayerRemoving:Connect(function(player: Player)
	equippedWeapon[player] = nil
end)

remotesFolder.RequestWeaponChange.OnServerInvoke = function(player: Player)
	return equippedWeapon[player]
end

remotesFolder.HitSurface.OnServerEvent:Connect(
	function(playerWhoFired: Player, mouseUnitRayDirection: Vector3, spread: Vector3)
		local playerWhoFiredCharacter = playerWhoFired.Character
		local raycastResult =
			raycastDamage(playerWhoFired, playerWhoFiredCharacter.Head.Position, mouseUnitRayDirection, spread)

		if raycastResult then
			local instance = raycastResult.Instance
			local position = raycastResult.Position
			local instancePenetration = instance:GetAttribute("Penetration")

			createBulletHole(playerWhoFired, raycastResult)

			if not instance:GetAttribute("Penetration") then
				return
			end

			if equippedWeapon[playerWhoFired]["Penetration"] < instancePenetration then
				return
			end

			BulletService(
				playerWhoFiredCharacter,
				position + mouseUnitRayDirection * 10,
				-mouseUnitRayDirection,
				Vector3.new(0, 0, 0)
			)
		end
	end
)

remotesFolder.HitCharacter.OnServerEvent:Connect(
	function(playerWhoFired: Player, mouseUnitRayDirection: Vector3, spread: Vector3)
		raycastDamage(playerWhoFired, playerWhoFired.Character.Head.Position, mouseUnitRayDirection, spread)
	end
)

return module
