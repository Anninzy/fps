local module = {}
local gunRaycastParams = RaycastParams.new()
gunRaycastParams.FilterType = Enum.RaycastFilterType.Exclude

function module.Raycast(player, mouseUnitRay)
	local character = player.Character

	gunRaycastParams.FilterDescendantsInstances = { character }

	return workspace:Raycast(character.Head.Position, mouseUnitRay.Direction * 1000, gunRaycastParams)
end

return module
