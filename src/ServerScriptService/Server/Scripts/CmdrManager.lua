local module = {}
local ServerScriptService = game:GetService("ServerScriptService")

function module.Initiate()
	local Cmdr = _G.Cmdr

	Cmdr.Registry:RegisterDefaultCommands()
	Cmdr.Registry:RegisterHooksIn(ServerScriptService.CmdrHooks)
end

return module
