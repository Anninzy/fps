local StarterGui = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService")

StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, false)
StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, true)
StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, true)

UserInputService.MouseIconEnabled = false

return {}