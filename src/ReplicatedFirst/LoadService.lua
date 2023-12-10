local RunService = game:GetService("RunService")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local sharedModulesFolder = ReplicatedStorage.Modules
local allModuleScripts = {}

local function addModules(array: { [number]: string })
	for _, moduleScript in ipairs(array) do
		if not moduleScript:IsA("ModuleScript") then
			continue
		end

		table.insert(allModuleScripts, moduleScript)
	end
end

local function runDefaultFunction(functionName: string)
	for _, module in pairs(_G) do
		if type(module) ~= "table" then
			continue
		end

		local defaultFunction = module[functionName]

		if type(defaultFunction) ~= "function" then
			continue
		end

		defaultFunction()
	end
end

if RunService:IsClient() then
	addModules(ReplicatedFirst.Client:GetDescendants())

	if not game:IsLoaded() then
		game.Loaded:Wait()
	end
else
	addModules(ServerScriptService.Server:GetDescendants())
	addModules(ServerScriptService.ServerPackages:GetChildren())
end

addModules(sharedModulesFolder:GetChildren())
addModules(sharedModulesFolder.Packages:GetChildren())

for _, moduleScript in ipairs(allModuleScripts) do
	_G[moduleScript.Name] = require(moduleScript)
end

runDefaultFunction("Initialize")
runDefaultFunction("Initiate")

return {}
