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

	local function checkLastFiredTime(playerWhoFired: Player)
		if weaponFiredTime[playerWhoFired] then
			if
				os.clock() - weaponFiredTime[playerWhoFired]
				< WeaponStatsService[equippedWeapon[playerWhoFired]]["SecondsPerRound"]
			then
				return
			end

			weaponFiredTime[playerWhoFired] = os.clock()
		end
	end

	local function dealDamage(playerWhoFired: Player, raycastResult: RaycastResult, wallbang: boolean)
		if raycastResult then
			local bodyPart = raycastResult.Instance
			local character = bodyPart.Parent
			local humanoid = character:FindFirstChildWhichIsA("Humanoid")

			if humanoid then
				local bodyPartName = bodyPart.Name
				local weaponStats = WeaponStatsService[equippedWeapon[playerWhoFired]]
				local damage

				if string.find(bodyPartName, "Leg") then
					damage = weaponStats["LegDamage"]
				elseif bodyPartName == "Head" then
					damage = weaponStats["HeadDamage"]
				else
					damage = weaponStats["BodyDamage"]
				end

				if wallbang then
					damage /= 3
				end

				humanoid:TakeDamage(damage) --TEMPORARY

				local player = Players:GetPlayerFromCharacter(character)

				if player then
					healthChangedEvent:FireClient(player, math.round(humanoid.Health))
				end
			else
				remotesFolder.CreateBulletHole:FireAllClients(raycastResult.Instance, raycastResult.Position)
			end
		end
	end

	remotesFolder.HitSurface.OnServerEvent:Connect(function(playerWhoFired: Player, direction: Vector3, spread: Vector3)
		checkLastFiredTime(playerWhoFired)

		local characterWhoFired = playerWhoFired.Character
		local raycastResult = BulletService({ characterWhoFired }, characterWhoFired.Head.Position, direction, spread)

		if raycastResult then
			createBulletHoleForOthers(playerWhoFired, raycastResult)

			local instancePenetration = raycastResult.Instance:GetAttribute("Penetration")

			if not instancePenetration then
				return
			end

			if WeaponStatsService[equippedWeapon[playerWhoFired]]["Penetration"] < instancePenetration then
				return
			end

			local allCharacters = {}
			local dummiesFolder = workspace.Dummies

			for _, player in ipairs(Players:GetPlayers()) do
				table.insert(allCharacters, player.Character)
			end

			for _, dummy in ipairs(dummiesFolder.NoHighlight:GetChildren()) do
				table.insert(allCharacters, dummy)
			end

			for _, dummy in ipairs(dummiesFolder.Highlight:GetChildren()) do
				table.insert(allCharacters, dummy)
			end

			local ignoreCharactersRaycastResult = BulletService(
				{ allCharacters },
				raycastResult.Position + direction * 10,
				-direction,
				Vector3.new(0, 0, 0)
			)

			if ignoreCharactersRaycastResult then
				remotesFolder.CreateBulletHole:FireAllClients(
					ignoreCharactersRaycastResult.Instance,
					ignoreCharactersRaycastResult.Position
				)

				local wallbangRaycastResult = BulletService(
					{ characterWhoFired },
					ignoreCharactersRaycastResult.Position,
					direction,
					Vector3.new(0, 0, 0)
				)

				dealDamage(playerWhoFired, wallbangRaycastResult, true)
			end
		end
	end)

	remotesFolder.HitCharacter.OnServerEvent:Connect(
		function(playerWhoFired: Player, direction: Vector3, spread: Vector3)
			checkLastFiredTime(playerWhoFired)

			local characterWhoFired = playerWhoFired.Character

			dealDamage(
				playerWhoFired,
				BulletService({ characterWhoFired }, characterWhoFired.Head.Position, direction, spread),
				false
			)
		end
	)
end

Players.PlayerAdded:Connect(function(playerWhoFired: Player) --TEMPORARY
	equippedWeapon[playerWhoFired] = "Vandal"

	playerWhoFired.CharacterAdded:Connect(function()
		healthChangedEvent:FireClient(playerWhoFired, 100)
		shieldChangedEvent:FireClient(playerWhoFired, 0)
	end)
end)

Players.PlayerRemoving:Connect(function(playerWhoFired: Player)
	equippedWeapon[playerWhoFired] = nil
end)

remotesFolder.RequestWeaponChange.OnServerInvoke = function(playerWhoFired: Player)
	return equippedWeapon[playerWhoFired]
end

return module
