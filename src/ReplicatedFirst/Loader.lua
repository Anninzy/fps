local RunService = game:GetService("RunService")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local ServerScriptService = game:GetService("ServerScriptService")

local scriptPath = RunService:IsClient() and ReplicatedFirst.Client or ServerScriptService.Server

if RunService:IsClient() then
	if not game:IsLoaded() then
		game.Loaded:Wait()
	end
end

return function()
	local allModuleScripts = scriptPath:GetDescendants()
	
	for _, moduleScript in ipairs(allModuleScripts) do
		if not moduleScript:IsA("ModuleScript") then
			continue
		end

		_G[moduleScript.Name] = require(moduleScript)
	end
	
	for _, moduleScript in ipairs(allModuleScripts) do
		if type(moduleScript) ~= "table" then
			continue
		end

		if type(moduleScript["Initialize"]) ~= "function" then
			continue
		end

		moduleScript.Initialize()
	end

	for _, moduleScript in ipairs(allModuleScripts) do
		if type(moduleScript) ~= "table" then
			continue
		end

		if type(moduleScript["Initiate"]) ~= "function" then
			continue
		end

		moduleScript.Initiate()
	end
end