-- SecondsPerRound should be set as 1 / (RPM / 60)
-- Insert a {} inside SprayPattern to keep looping the pattern inside it

return {
	["UnnamedGun"] = {
		["CanHoldFire"] = true,
		["SecondsPerRound"] = 1 / (585 / 60),
		["SprayPattern"] = {
			CFrame.Angles(math.rad(12.25), 0, 0),
			{
				CFrame.Angles(0, math.rad(12), 0),
				CFrame.Angles(0, math.rad(-12), 0),
			},
		},
	},
}
