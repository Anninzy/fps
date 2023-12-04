local PhysicsService = game:GetService("PhysicsService")
local Players = game:GetService("Players")

PhysicsService:RegisterCollisionGroup("Players")
PhysicsService:CollisionGroupSetCollidable("Players", "Players", false)

Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function(character)
		for _, part in ipairs(character:GetDescendants()) do
			if not part:IsA("BasePart") then
				continue
			end

			part.CollisionGroup = "Players"
		end
	end)
end)

return {}
