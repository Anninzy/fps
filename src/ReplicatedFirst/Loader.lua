local RunService = game:GetService("RunService")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local ServerScriptService = game:GetService("ServerScriptService")

local scriptPath = RunService:IsClient() and ReplicatedFirst.Client or ServerScriptService.Server

return function()
	local allModuleScripts = scriptPath:GetDescendants()
	
	for _, moduleScript in ipairs(allModuleScripts) do
		_G[moduleScript.Name] = require(moduleScript)
	end
	
	for _, moduleScript in ipairs(allModuleScripts) do
		if type(moduleScript) ~= "table" then
			continue
		end

		if type(moduleScript["Init"]) ~= "function" then
			continue
		end

		moduleScript.Init()
	end
end