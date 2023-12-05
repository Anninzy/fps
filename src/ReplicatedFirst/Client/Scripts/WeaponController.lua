local module = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")

module.CurrentWeapon = ReplicatedStorage.Remotes.RequestWeaponChange:InvokeServer("Vandal")

return module
