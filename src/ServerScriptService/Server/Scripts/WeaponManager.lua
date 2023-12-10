local module = {}
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local remotesFolder = ReplicatedStorage.Remotes
local healthChangedEvent = remotesFolder.HealthChanged
local shieldChangedEvent = remotesFolder.ShieldChanged
local equippedWeapon = {}

local function createBulletHoleForOthers(playerWhoFired: Player, raycastResult: RaycastResult)
	for _, player in ipairs(Players:GetPlayers()) do
		if player == playerWhoFired then
			continue
		end

		remotesFolder.CreateBulletHole:FireClient(player, raycastResult.Instance, raycastResult.Position)
	end
end

function module.Initiate()
	local BulletService = _G.BulletService
	local WeaponStatsService = _G.WeaponStatsService
	local weaponFiredTime = {}

	local function dealDamage(playerWhoFired: Player, raycastResult: RaycastResult)
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
				createBulletHoleForOthers(playerWhoFired, raycastResult)
			end
		end
	end

	remotesFolder.HitSurface.OnServerEvent:Connect(
		function(playerWhoFired: Player, mouseUnitRayDirection: Vector3, spread: Vector3)
			local characterWhoFired = playerWhoFired.Character
			local raycastResult =
				BulletService({ characterWhoFired }, characterWhoFired.Head.Position, mouseUnitRayDirection, spread)

			if raycastResult then
				local instancePenetration = raycastResult.Instance:GetAttribute("Penetration")

				createBulletHoleForOthers(playerWhoFired, raycastResult)

				if not instancePenetration then
					return
				end

				if WeaponStatsService[equippedWeapon[playerWhoFired]]["Penetration"] < instancePenetration then
					return
				end

				local allCharacters = {}

				for _, player in ipairs(Players:GetPlayers()) do
					table.insert(allCharacters, player.Character)
				end

				local ignorePlayersRaycastResult = BulletService(
					{ allCharacters },
					raycastResult.Position + mouseUnitRayDirection * 10,
					-mouseUnitRayDirection,
					Vector3.new(0, 0, 0)
				)

				if ignorePlayersRaycastResult then
					remotesFolder.CreateBulletHole:FireAllClients(
						ignorePlayersRaycastResult.Instance,
						ignorePlayersRaycastResult.Position
					)

					local wallbangRaycastResult = BulletService(
						{ characterWhoFired },
						ignorePlayersRaycastResult.Position,
						-mouseUnitRayDirection,
						Vector3.new(0, 0, 0)
					)

					local TEST_PART = Instance.new("Part")
					TEST_PART.Position = wallbangRaycastResult.Position
					TEST_PART.Size = Vector3.new(1, 1, 1)
					TEST_PART.Anchored = true
					TEST_PART.CanCollide = false
					TEST_PART.Color = Color3.fromRGB(255, 0, 0)
					TEST_PART.Parent = workspace

					dealDamage(playerWhoFired, wallbangRaycastResult)
				end
			end
		end
	)

	remotesFolder.HitCharacter.OnServerEvent:Connect(
		function(playerWhoFired: Player, mouseUnitRayDirection: Vector3, spread: Vector3)
			if weaponFiredTime[playerWhoFired] then
				if
					os.clock() - weaponFiredTime[playerWhoFired]
					< WeaponStatsService[equippedWeapon[playerWhoFired]]["SecondsPerRound"]
				then
					return
				end

				weaponFiredTime[playerWhoFired] = os.clock()
			end

			local characterWhoFired = playerWhoFired.Character

			dealDamage(
				playerWhoFired,
				BulletService({ characterWhoFired }, characterWhoFired.Head.Position, mouseUnitRayDirection, spread)
			)
		end
	)
end

Players.PlayerAdded:Connect(function(playerWhoFired)
	equippedWeapon[playerWhoFired] = "Vandal"

	playerWhoFired.CharacterAdded:Connect(function()
		healthChangedEvent:FireClient(playerWhoFired, 100)
		shieldChangedEvent:FireClient(playerWhoFired, 0)
	end)
end)

Players.PlayerRemoving:Connect(function(playerWhoFired)
	equippedWeapon[playerWhoFired] = nil
end)

remotesFolder.RequestWeaponChange.OnServerInvoke = function(playerWhoFired)
	return equippedWeapon[playerWhoFired]
end

return module
