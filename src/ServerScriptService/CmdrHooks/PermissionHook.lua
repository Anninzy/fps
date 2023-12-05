local RunService = game:GetService("RunService")

return function(registry)
	registry:RegisterHook("BeforeRun", function(context)
		if not RunService:IsStudio() then
			if context.Group == "DefaultAdmin" and context.Executor.UserId ~= game.CreatorId then
				return "LEVEL 5 SECURITY CLEARANCE REQUIRED."
			end
		end
	end)
end
