local raycastParams = RaycastParams.new()
raycastParams.FilterType = Enum.RaycastFilterType.Exclude

return function(player, direction, spread)
	local character = player.Character

	raycastParams.FilterDescendantsInstances = { character }

	return workspace:Raycast(character.Head.Position, direction * 1000 + spread, raycastParams)
end
