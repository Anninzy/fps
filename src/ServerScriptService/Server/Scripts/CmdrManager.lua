local module = {}

function module.Initiate()
	local ServerScriptService = game:GetService("ServerScriptService")
	local Cmdr = _G.Cmdr

	Cmdr.Registry:RegisterDefaultCommands()
	Cmdr.Registry:RegisterHooksIn(ServerScriptService.CmdrHooks)
end

return module
