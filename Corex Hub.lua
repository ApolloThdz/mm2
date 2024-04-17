-- Criar uma UI
local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "ScriptExecutorUI"
gui.Parent = player.PlayerGui

-- Estilização da UI
local mainColor = Color3.fromRGB(50, 50, 50) -- Cor cinza escuro
local strokeColor = Color3.fromRGB(128, 0, 128) -- Cor roxa
local textColor = Color3.new(1, 1, 1) -- Cor branca

-- Layout da UI
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0.3, 0, 0.3, 0)
frame.Position = UDim2.new(0.5, 0, 0.5, 0)
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.BackgroundColor3 = mainColor
frame.BorderColor3 = strokeColor
frame.BorderSizePixel = 0 -- Removendo a borda
frame.Parent = gui
frame.ClipsDescendants = true -- Clip children to this frame

-- Função para criar um botão
local function createButton(text, position, clickFunction)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0.1, 0, 0.1, 0)
    button.Position = position
    button.BackgroundColor3 = mainColor
    button.BorderColor3 = strokeColor
    button.TextColor3 = textColor
    button.Font = Enum.Font.SourceSansBold
    button.TextSize = 18
    button.Text = text
    button.Parent = frame
    button.MouseButton1Click:Connect(clickFunction)
    return button
end

-- Caixa de texto para inserir o script
local scriptTextBox = Instance.new("TextBox")
scriptTextBox.Size = UDim2.new(0.9, 0, 0.7, 0)
scriptTextBox.Position = UDim2.new(0.05, 0, 0.15, 0)
scriptTextBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
scriptTextBox.BorderColor3 = strokeColor
scriptTextBox.TextColor3 = textColor
scriptTextBox.Font = Enum.Font.SourceSans
scriptTextBox.TextSize = 18
scriptTextBox.TextWrapped = true
scriptTextBox.ClearTextOnFocus = false
scriptTextBox.PlaceholderText = "Insira seu script aqui..."
scriptTextBox.Parent = frame

-- Botão para executar o script
local executeButton = createButton("Executar", UDim2.new(0.05, 0, 0.85, 0), function()
    local script = scriptTextBox.Text
    local success, errorMessage = pcall(loadstring(script))
    if not success then
        warn("Erro ao executar o script:", errorMessage)
    end
end)

-- Botão para minimizar a UI
local minimizeButton = createButton("-", UDim2.new(0.8, 0, 0, 0), function()
    frame.Visible = false
end)

-- Botão para fechar a UI
local closeButton = createButton("X", UDim2.new(0.9, 0, 0, 0), function()
    frame.Visible = false
end)

-- Função para restaurar a UI
local function restoreUI()
    frame.Visible = true
end

-- Conectar a tecla RShift para restaurar a UI
game:GetService("UserInputService").InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.RightShift then
        restoreUI()
    end
end)
