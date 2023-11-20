

return {
	["UnnamedGun"] = {
		["CanHoldFire"] = true,
		["SecondsPerRound"] = 1 / (585 / 60), --1 / (RPM / 60)
		["RecoilCameraOffset"] = {
			CFrame.Angles(math.rad(12.25), 0, 0),
			CFrame.Angles(math.rad(12.25), math.rad(3), 0),
			CFrame.Angles(math.rad(12.25), math.rad(-3), 0)
		},
		["Accuracy"] = {}
	}	
}