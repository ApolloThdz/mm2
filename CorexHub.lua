local OrionLib = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Orion/main/source'))()
local Window = OrionLib:MakeWindow({Name = "Key System", HidePremium = false, SaveConfig = true, ConfigFolder = "OrionTest", IntroText = "Corex Hub", IntroIcon = "rbxassetid://7733777166"})
local SavedKey = loadstring(game:HttpGet(''))()

------ MENU SCRIPT ------
OrionLib:MakeNotification({
	Name = "Key System!",
	Content = "Get Your Key In Discord",
	Image = "rbxassetid://7733965118",
	Time = 3
})
Tab:AddButton({
	Name = "Copy Discord!",
	Callback = function()
        setclipboard
  	end    
})

fuction CorexHubInitializater()
local CorexM = Window:MakeTab({
	Name = "Main",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})
local Section = CorexM:AddSection({
	Name = "Murder <--> Esp"
})

local Section = CorexM:AddSection({
	Name = "Sheriff <--> Esp"
})
end
