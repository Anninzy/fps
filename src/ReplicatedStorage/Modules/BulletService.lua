local raycastParams = RaycastParams.new()
raycastParams.FilterType = Enum.RaycastFilterType.Exclude

return function(
	filter: any --[[Type check doesn't exist for tables]],
	origin: Vector3,
	direction: Vector3,
	spread: Vector3
)
	raycastParams.FilterDescendantsInstances = filter
	return workspace:Raycast(origin, direction * 1000 + spread, raycastParams)
end
