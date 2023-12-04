local raycastParams = RaycastParams.new()
raycastParams.FilterType = Enum.RaycastFilterType.Exclude

return function(player, direction)
	local character = player.Character
	raycastParams.FilterDescendantsInstances = { character }
	return workspace:Raycast(character.Head.Position, direction * 1000, raycastParams)
end
