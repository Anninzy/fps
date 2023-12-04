local RunService = game:GetService("RunService")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local allModuleScripts

if RunService:IsClient() then
	allModuleScripts = ReplicatedFirst.Client:GetDescendants()

	if not game:IsLoaded() then
		game.Loaded:Wait()
	end
else
	allModuleScripts = ServerScriptService.Server:GetDescendants()

	for _, moduleScript in ipairs(ServerScriptService.ServerPackages:GetChildren()) do
		table.insert(allModuleScripts, moduleScript)
	end
end

return function()
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
