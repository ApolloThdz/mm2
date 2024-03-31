local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()
local Window = OrionLib:MakeWindow({Name = "Dexins", HidePremium = false, SaveConfig = true, ConfigFolder = "OrionTest", IntroText = "Dexins Hub Loading...", IntroIcon = "rbxassetid://16924654288", Icon = "rbxassetid://16924654288"})
local Tab = Window:MakeTab({
	Name = "Main",
	Icon = "rbxassetid://16924656716",
	PremiumOnly = false
})
local Section = Tab:AddSection({
	Name = "Esp and Tracers"
})

local espEnabled = false -- Variável para controlar se o ESP está ativado ou desativado

local function criarESP(player, isMurderer, isSheriff)
    local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end

    local name = player.Name
    local position = humanoid.RootPart.Position
    local distance = (position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude

    local espBox = Instance.new("BoxHandleAdornment")
    espBox.Name = "ESP"
    espBox.Size = player.Character:GetExtentsSize() * 1.2
    espBox.AlwaysOnTop = true
    espBox.Transparency = 0.5
    espBox.Adornee = player.Character
    espBox.Color3 = isMurderer and Color3.new(1, 0, 0) or isSheriff and Color3.new(0, 0, 0.5) or Color3.new(1, 1, 1)
    espBox.ZIndex = 1
    espBox.Parent = player.Character

    local espName = Instance.new("BillboardGui")
    espName.Name = "ESPName"
    espName.Size = UDim2.new(0, 100, 0, 40)
    espName.AlwaysOnTop = true
    espName.StudsOffset = Vector3.new(0, 3, 0)
    espName.Parent = player.Character.Head

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, 0, 1, 0)
    nameLabel.Position = UDim2.new(0, 0, 0, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = name
    nameLabel.TextColor3 = espBox.Color3
    nameLabel.Font = Enum.Font.SourceSans
    nameLabel.TextSize = 18
    nameLabel.Parent = espName

    local roleLabel = Instance.new("TextLabel")
    roleLabel.Size = UDim2.new(1, 0, 1, 0)
    roleLabel.Position = UDim2.new(0, 0, 1, 0)
    roleLabel.BackgroundTransparency = 1
    roleLabel.Text = isMurderer and "Murderer" or isSheriff and "Sheriff" or ""
    roleLabel.TextColor3 = espBox.Color3
    roleLabel.Font = Enum.Font.SourceSans
    roleLabel.TextSize = 14
    roleLabel.Parent = espName

    local distanceLabel = Instance.new("TextLabel")
    distanceLabel.Size = UDim2.new(1, 0, 1, 0)
    distanceLabel.Position = UDim2.new(0, 0, 2, 0)
    distanceLabel.BackgroundTransparency = 1
    distanceLabel.Text = string.format("%.1f meters", distance)
    distanceLabel.TextColor3 = espBox.Color3
    distanceLabel.Font = Enum.Font.SourceSans
    distanceLabel.TextSize = 14
    distanceLabel.Parent = espName

    return espBox, espName
end

local function identificarPapeis()
    for _, player in ipairs(game.Players:GetPlayers()) do
        if player ~= game.Players.LocalPlayer then
            local isMurderer = player.Backpack:FindFirstChild("Knife") or player.Character:FindFirstChild("Knife")
            local isSheriff = player.Backpack:FindFirstChild("Gun") or player.Character:FindFirstChild("Gun")
            if isMurderer or isSheriff then
                criarESP(player, isMurderer, isSheriff)
            end
        end
    end
end

local function atualizarESP()
    for _, player in ipairs(game.Players:GetPlayers()) do
        local espBox = player.Character:FindFirstChild("ESP")
        if espEnabled then
            if not espBox then
                local isMurderer = player.Backpack:FindFirstChild("Knife") or player.Character:FindFirstChild("Knife")
                local isSheriff = player.Backpack:FindFirstChild("Gun") or player.Character:FindFirstChild("Gun")
                if isMurderer or isSheriff then
                    criarESP(player, isMurderer, isSheriff)
                end
            end
        elseif espBox then
            espBox:Destroy()
        end
    end
end

Tab:AddToggle({
    Name = "Esp",
    Default = false,
    Callback = function(value)
        espEnabled = value
        atualizarESP()
    end
})

Tab:AddSlider({
    Name = "Walkspeed",
    Min = 16,
    Max = 64,
    Default = 5,
    Color = Color3.fromRGB(255,255,255),
    Increment = 1,
    ValueName = "Speed",
    Callback = function(value)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
    end    
})
