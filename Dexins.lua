local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()
local Window = OrionLib:MakeWindow({
    Name = "Dexins",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "OrionTest",
    IntroText = "Dexins Hub Loading...",
    IntroIcon = "rbxassetid://16924654288",
    Icon = "rbxassetid://16924654288"
})

local Tab = Window:MakeTab({
    Name = "Main",
    Icon = "rbxassetid://16924656716",
    PremiumOnly = false
})

local Section = Tab:AddSection({
    Name = "Esp and Tracers"
})

Tab:AddToggle({
    Name = "ESP Toggle",
    Default = false,
    Callback = onESPEnabledChanged
})

-- Settings
local Settings = {
    Murderer_Color = Color3.fromRGB(255, 0, 0),
    Sheriff_Color = Color3.fromRGB(0, 0, 255),
    Innocent_Color = Color3.fromRGB(255, 255, 255),
    Box_Thickness = 2,
    Team_Check = true,
    Autothickness = true
}

local espEnabled = false

-- Locais
local Space = game:GetService("Workspace")
local Player = game:GetService("Players").LocalPlayer
local Camera = Space.CurrentCamera

-- Função para criar uma nova linha
local function NewLine(color, thickness)
    local line = Drawing.new("Line")
    line.Visible = false
    line.From = Vector2.new(0, 0)
    line.To = Vector2.new(0, 0)
    line.Color = color
    line.Thickness = thickness
    line.Transparency = 1
    return line
end

-- Função para definir a visibilidade das linhas
local function Vis(lib, state)
    for i, v in pairs(lib) do
        v.Visible = state
    end
end

-- Função para colorir as linhas
local function Colorize(lib, color)
    for i, v in pairs(lib) do
        v.Color = color
    end
end

-- Função principal para desenhar as hitboxes
local function Main(player)
    repeat wait() until player.Character ~= nil and player.Character:FindFirstChild("Humanoid") ~= nil
    local Library = {
        TL1 = NewLine(Settings.Murderer_Color, Settings.Box_Thickness),
        TL2 = NewLine(Settings.Murderer_Color, Settings.Box_Thickness),
        TR1 = NewLine(Settings.Murderer_Color, Settings.Box_Thickness),
        TR2 = NewLine(Settings.Murderer_Color, Settings.Box_Thickness),
        BL1 = NewLine(Settings.Murderer_Color, Settings.Box_Thickness),
        BL2 = NewLine(Settings.Murderer_Color, Settings.Box_Thickness),
        BR1 = NewLine(Settings.Murderer_Color, Settings.Box_Thickness),
        BR2 = NewLine(Settings.Murderer_Color, Settings.Box_Thickness)
    }
    local oripart = Instance.new("Part")
    oripart.Parent = Space
    oripart.Transparency = 1
    oripart.CanCollide = false
    oripart.Size = Vector3.new(1, 1, 1)
    oripart.Position = Vector3.new(0, 0, 0)

    -- Função para atualizar as hitboxes
    local function Update()
        local c
        c = game:GetService("RunService").RenderStepped:Connect(function()
            if player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
                local Hum = player.Character
                local HumPos, vis = Camera:WorldToViewportPoint(Hum.HumanoidRootPart.Position)
                if vis then
                    oripart.Size = Vector3.new(Hum.HumanoidRootPart.Size.X, Hum.HumanoidRootPart.Size.Y * 1.5, Hum.HumanoidRootPart.Size.Z)
                    oripart.CFrame = CFrame.new(Hum.HumanoidRootPart.CFrame.Position, Camera.CFrame.Position)
                    local SizeX = oripart.Size.X
                    local SizeY = oripart.Size.Y
                    local TL = Camera:WorldToViewportPoint((oripart.CFrame * CFrame.new(SizeX, SizeY, 0)).p)
                    local TR = Camera:WorldToViewportPoint((oripart.CFrame * CFrame.new(-SizeX, SizeY, 0)).p)
                    local BL = Camera:WorldToViewportPoint((oripart.CFrame * CFrame.new(SizeX, -SizeY, 0)).p)
                    local BR = Camera:WorldToViewportPoint((oripart.CFrame * CFrame.new(-SizeX, -SizeY, 0)).p)

                    local ratio = (Camera.CFrame.p - Hum.HumanoidRootPart.Position).magnitude
                    local offset = math.clamp(1 / ratio * 750, 2, 300)

                    -- Definir as coordenadas das linhas
                    Library.TL1.From = Vector2.new(TL.X, TL.Y)
                    Library.TL1.To = Vector2.new(TL.X + offset, TL.Y)
                    Library.TL2.From = Vector2.new(TL.X, TL.Y)
                    Library.TL2.To = Vector2.new(TL.X, TL.Y + offset)

                    Library.TR1.From = Vector2.new(TR.X, TR.Y)
                    Library.TR1.To = Vector2.new(TR.X - offset, TR.Y)
                    Library.TR2.From = Vector2.new(TR.X, TR.Y)
                    Library.TR2.To = Vector2.new(TR.X, TR.Y + offset)

                    Library.BL1.From = Vector2.new(BL.X, BL.Y)
                    Library.BL1.To = Vector2.new(BL.X + offset, BL.Y)
                    Library.BL2.From = Vector2.new(BL.X, BL.Y)
                    Library.BL2.To = Vector2.new(BL.X, BL.Y - offset)

                    Library.BR1.From = Vector2.new(BR.X, BR.Y)
                    Library.BR1.To = Vector2.new(BR.X - offset, BR.Y)
                    Library.BR2.From = Vector2.new(BR.X, BR.Y)
                    Library.BR2.To = Vector2.new(BR.X, BR.Y - offset)

                    Vis(Library, true)

                    -- Definir a espessura das linhas automaticamente
                    if Settings.Autothickness then
                        local distance = (Player.Character.HumanoidRootPart.Position - oripart.Position).magnitude
                        local value = math.clamp(1 / distance * 100, 1, 4)
                        for u, x in pairs(Library) do
                            x.Thickness = value
                        end
                    else
                        for u, x in pairs(Library) do
                            x.Thickness = Settings.Box_Thickness
                        end
                    end
                else
                    Vis(Library, false)
                end
            else
                Vis(Library, false)
                if not game:GetService("Players"):FindFirstChild(player.Name) then
                    for i, v in pairs(Library) do
                        v:Remove()
                    end
                    oripart:Destroy()
                    c:Disconnect()
                end
            end
        end)
    end
    coroutine.wrap(Update)()
end

-- Desenhar hitboxes para jogadores existentes
for i, v in pairs(game:GetService("Players"):GetPlayers()) do
    if v.Name ~= Player.Name then
        coroutine.wrap(Main)(v)
    end
end

-- Conectar evento para desenhar hitboxes para novos jogadores
game:GetService("Players").PlayerAdded:Connect(function(newplr)
    coroutine.wrap(Main)(newplr)
end)

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
    espBox.Color3 = isMurderer and Settings.Murderer_Color or isSheriff and Settings.Sheriff_Color or Settings.Innocent_Color
    espBox.ZIndex = 1
    espBox.Parent = player.Character

    local espName = Instance.new("BillboardGui")
    espName.Name = "ESPName"
    espName.Size = UDim2.new(0, 100, 0, 60)  -- Ajuste para acomodar o texto da distância
    espName.AlwaysOnTop = true
    espName.StudsOffset = Vector3.new(0, 3, 0)
    espName.Parent = player.Character.Head

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, 0, 0.5, 0)  -- Ajuste para o tamanho do nome
    nameLabel.Position = UDim2.new(0, 0, 0, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = name
    nameLabel.TextColor3 = espBox.Color3
    nameLabel.Font = Enum.Font.SourceSans
    nameLabel.TextSize = 18
    nameLabel.Parent = espName

    local roleLabel = Instance.new("TextLabel")
    roleLabel.Size = UDim2.new(1, 0, 0.5, 0)  -- Ajuste para o tamanho do papel
    roleLabel.Position = UDim2.new(0, 0, 0.5, 0)
    roleLabel.BackgroundTransparency = 1
    roleLabel.Text = isMurderer and "Murderer" or isSheriff and "Sheriff" or ""
    roleLabel.TextColor3 = espBox.Color3
    roleLabel.Font = Enum.Font.SourceSans
    roleLabel.TextSize = 14
    roleLabel.Parent = espName

    local distanceLabel = Instance.new("TextLabel")
    distanceLabel.Size = UDim2.new(1, 0, 0.5, 0)  -- Ajuste para o tamanho da distância
    distanceLabel.Position = UDim2.new(0, 0, 1, 0)
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
        local espName = player.Character:FindFirstChild("ESPName")  -- Adicionado para encontrar a instância do nome do ESP
        if espEnabled then
            if not espBox then
                local isMurderer = player.Backpack:FindFirstChild("Knife") or player.Character:FindFirstChild("Knife")
                local isSheriff = player.Backpack:FindFirstChild("Gun") or player.Character:FindFirstChild("Gun")
                if isMurderer or isSheriff then
                    criarESP(player, isMurderer, isSheriff)
                end
            elseif espName then  -- Se o ESP já existe, atualize a distância
                local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    local position = humanoid.RootPart.Position
                    local distance = (position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude
                    local distanceLabel = espName:FindFirstChild("TextLabel")
                    if distanceLabel then
                        distanceLabel.Text = string.format("%.1f meters", distance)
                    end
                end
            end
        elseif espBox then
            espBox:Destroy()
            if espName then
                espName:Destroy()  -- Destruir também o nome do ESP
            end
        end
    end
end


local function onESPEnabledChanged(value)
    espEnabled = value
    if espEnabled then
        identificarPapeis()
    else
        atualizarESP()
    end
end
