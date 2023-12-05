local RunService = game:GetService("RunService")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local allModuleScripts = {}

local function addModules(array: table)
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

		local functionToRun = module[functionName]

		if type(functionToRun) ~= "function" then
			continue
		end

		functionToRun()
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

local sharedModulesFolder = ReplicatedStorage.Modules

addModules(sharedModulesFolder:GetChildren())
addModules(sharedModulesFolder.Packages:GetChildren())

for _, moduleScript in ipairs(allModuleScripts) do
	_G[moduleScript.Name] = require(moduleScript)
end

runDefaultFunction("Initialize")
runDefaultFunction("Initiate")

return {}
