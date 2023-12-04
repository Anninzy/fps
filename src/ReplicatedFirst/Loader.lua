local RunService = game:GetService("RunService")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local scriptPath

if RunService:IsClient() then
	scriptPath = ReplicatedFirst.Client

	if not game:IsLoaded() then
		game.Loaded:Wait()
	end
else
	scriptPath = ServerScriptService.Server
end

return function()
	local allModuleScripts = scriptPath:GetDescendants()
	local modulesFolder = ReplicatedStorage.Modules

	for _, moduleScript in ipairs(modulesFolder:GetChildren()) do
		table.insert(allModuleScripts, moduleScript)
	end

	for _, moduleScript in ipairs(modulesFolder.Packages:GetChildren()) do
		table.insert(allModuleScripts, moduleScript)
	end

	for _, moduleScript in ipairs(allModuleScripts) do
		if not moduleScript:IsA("ModuleScript") then
			continue
		end

		_G[moduleScript.Name] = require(moduleScript)
	end

	for _, moduleScript in pairs(_G) do
		if type(moduleScript) ~= "table" then
			continue
		end

		if type(moduleScript["Initialize"]) ~= "function" then
			continue
		end

		moduleScript.Initialize()
	end

	for _, moduleScript in pairs(_G) do
		if type(moduleScript) ~= "table" then
			continue
		end

		if type(moduleScript["Initiate"]) ~= "function" then
			continue
		end

		moduleScript.Initiate()
	end
end
