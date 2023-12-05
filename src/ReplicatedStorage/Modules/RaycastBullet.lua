local raycastParams = RaycastParams.new()
raycastParams.FilterType = Enum.RaycastFilterType.Exclude

return function(character: Model, origin: Vector3, direction: Vector3, spread: Vector3)
	raycastParams.FilterDescendantsInstances = { character }
	return workspace:Raycast(origin, direction * 1000 + spread, raycastParams)
end
