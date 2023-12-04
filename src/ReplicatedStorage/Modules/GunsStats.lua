--[[
	 SecondsPerRound: 1 / (RPM / 60)
	 SprayPattern: {} = Loop pattern inside the table forever
	 Penetration: 1 = Low, 2 = Medium, 3 = High
]]

return {
	["Vandal"] = {
		["Cost"] = 2900,
		["Penetration"] = 2,
		["CanSpray"] = true,
		["SecondsPerRound"] = 1 / (585 / 60),
		["RunSpeed"] = 5.4,
		["EquipSpeed"] = 1,
		["ReloadSpeed"] = 2.5,
		["Magazine"] = 25,
		["Reserve"] = 50,
		["SprayPattern"] = {
			CFrame.Angles(math.rad(12.25), 0, 0),
			{
				CFrame.Angles(0, math.rad(12), 0),
				CFrame.Angles(0, math.rad(-12), 0),
			},
		},
		["Zoom"] = 1.25,
		["ADSFireRate"] = 0.9,
		["ADSRunSpeed"] = 0.76,
		["HeadDamage"] = 160,
		["BodyDamage"] = 40,
		["LegDamage"] = 34,
	},
}
