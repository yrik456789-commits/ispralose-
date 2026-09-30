-- Services
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

-- Configuration & State
local Config = {
    MenuKey = Enum.KeyCode.LeftAlt,
    KillSoundEnabled = true,
    SelectedKillSound = "Mortal Kombat Headshot",
    HitSoundEnabled = true,
    SelectedHitSound = "Skeet",
    TracersEnabled = true,
    TracerColor = Color3.fromRGB(0, 170, 255),
    TracerDuration = 0.6,
    ESP = {
        Boxes = true,
        Skeleton = true,
        BoxColor = Color3.fromRGB(0, 170, 255),
        SkeletonColor = Color3.fromRGB(255, 255, 255)
    }
}

-- Sound Library (Рабочие ID)
local Sounds = {
    KillSounds = {
        ["Mortal Kombat Headshot"] = "rbxassetid://6650912708",
        ["Neverlose"] = "rbxassetid://8679627751",
        ["Gamesense"] = "rbxassetid://4817809188",
        ["Rust"] = "rbxassetid://1255040462"
    },
    HitSounds = {
        ["Skeet"] = "rbxassetid://4817809188",
        ["Neverlose"] = "rbxassetid://8679627751",
        ["Bell"] = "rbxassetid://6607204598"
    }
}

local function PlayCustomSound(soundId)
    if not soundId or soundId == "" then return end
    local sound = Instance.new("Sound")
    sound.SoundId = soundId
    sound.Volume = 2
    sound.Parent = SoundService
    sound:Play()
    sound.Ended:Connect(function()
        sound:Destroy()
    end)
end

-- ScreenGui Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "IspraloseGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 999
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Папка для хранения ESP элементов
local EspContainer = Instance.new("Folder")
EspContainer.Name = "ESP_Container"
EspContainer.Parent = ScreenGui

----------------------------------------------------
-- 1. ЭКРАН ЗАГРУЗКИ
----------------------------------------------------
local LoadingFrame = Instance.new("Frame")
LoadingFrame.Name = "LoadingFrame"
LoadingFrame.Size = UDim2.new(0, 350, 0, 180)
LoadingFrame.Position = UDim2.new(0.5, -175, 0.5, -90)
LoadingFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
LoadingFrame.BorderSizePixel = 0
LoadingFrame.Parent = ScreenGui

local LoadingCorner = Instance.new("UICorner")
LoadingCorner.CornerRadius = UDim.new(0, 10)
LoadingCorner.Parent = LoadingFrame

local LoadingTitle = Instance.new("TextLabel")
LoadingTitle.Size = UDim2.new(1, 0, 0, 40)
LoadingTitle.BackgroundTransparency = 1
LoadingTitle.Text = "ISPRALOSE"
LoadingTitle.TextColor3 = Color3.fromRGB(0, 150, 255)
LoadingTitle.TextSize = 22
LoadingTitle.Font = Enum.Font.GothamBold
LoadingTitle.Parent = LoadingFrame

local LoadingStatus = Instance.new("TextLabel")
LoadingStatus.Size = UDim2.new(1, 0, 0, 30)
LoadingStatus.Position = UDim2.new(0, 0, 0, 60)
LoadingStatus.BackgroundTransparency = 1
LoadingStatus.Text = "Инициализация модулей..."
LoadingStatus.TextColor3 = Color3.fromRGB(200, 200, 200)
LoadingStatus.TextSize = 13
LoadingStatus.Font = Enum.Font.Gotham
LoadingStatus.Parent = LoadingFrame

local ProgressBarBg = Instance.new("Frame")
ProgressBarBg.Size = UDim2.new(0.85, 0, 0, 8)
ProgressBarBg.Position = UDim2.new(0.075, 0, 0, 115)
ProgressBarBg.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
ProgressBarBg.BorderSizePixel = 0
ProgressBarBg.Parent = LoadingFrame

local ProgressCorner = Instance.new("UICorner")
ProgressCorner.CornerRadius = UDim.new(0, 4)
ProgressCorner.Parent = ProgressBarBg

local ProgressBarFill = Instance.new("Frame")
ProgressBarFill.Size = UDim2.new(0, 0, 1, 0)
ProgressBarFill.BackgroundColor3 = Color3.fromRGB(0, 140, 255)
ProgressBarFill.BorderSizePixel = 0
ProgressBarFill.Parent = ProgressBarBg

local FillCorner = Instance.new("UICorner")
FillCorner.CornerRadius = UDim.new(0, 4)
FillCorner.Parent = ProgressBarFill

----------------------------------------------------
-- 2. ОСНОВНОЕ МЕНЮ
----------------------------------------------------
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 550, 0, 380)
MainFrame.Position = UDim2.new(0.5, -275, 0.5, -190)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 8)
MainCorner.Parent = MainFrame

-- Хедер меню
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 35)
TopBar.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = "TitleLabel"
TitleLabel.Size = UDim2.new(0, 200, 1, 0)
TitleLabel.Position = UDim2.new(0, 12, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "ispralose"
TitleLabel.TextColor3 = Color3.fromRGB(0, 170, 255)
TitleLabel.TextSize = 18
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = TopBar

-- Анимированный синий градиент
local TitleGradient = Instance.new("UIGradient")
TitleGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 100, 255)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 220, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 100, 255))
})
TitleGradient.Parent = TitleLabel

task.spawn(function()
    while true do
        TitleGradient.Rotation = (TitleGradient.Rotation + 3) % 360
        task.wait(0.03)
    end
end)

-- Кнопки закрытия и сворачивания
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 35, 1, 0)
CloseBtn.Position = UDim2.new(1, -35, 0, 0)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
CloseBtn.TextSize = 15
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = TopBar

local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Size = UDim2.new(0, 35, 1, 0)
MinimizeBtn.Position = UDim2.new(1, -70, 0, 0)
MinimizeBtn.BackgroundTransparency = 1
MinimizeBtn.Text = "—"
MinimizeBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
MinimizeBtn.TextSize = 15
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.Parent = TopBar

----------------------------------------------------
-- 3. АНИМАЦИЯ СВОРАЧИВАНИЯ И КРЕСТИК
----------------------------------------------------
local isMinimized = false
local originalSize = UDim2.new(0, 550, 0, 380)
local originalPos = UDim2.new(0.5, -275, 0.5, -190)

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

local TabBar = Instance.new("Frame")
TabBar.Size = UDim2.new(0, 130, 1, -35)
TabBar.Position = UDim2.new(0, 0, 0, 35)
TabBar.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
TabBar.BorderSizePixel = 0
TabBar.Parent = MainFrame

local ContentArea = Instance.new("Frame")
ContentArea.Size = UDim2.new(1, -130, 1, -35)
ContentArea.Position = UDim2.new(0, 130, 0, 35)
ContentArea.BackgroundTransparency = 1
ContentArea.Parent = MainFrame

MinimizeBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        TabBar.Visible = false
        ContentArea.Visible = false
        TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 160, 0, 35),
            Position = UDim2.new(0.5, -80, 0, 12)
        }):Play()
        TweenService:Create(MainCorner, TweenInfo.new(0.4), {
            CornerRadius = UDim.new(0, 18)
        }):Play()
    else
        TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            Size = originalSize,
            Position = originalPos
        }):Play()
        TweenService:Create(MainCorner, TweenInfo.new(0.4), {
            CornerRadius = UDim.new(0, 8)
        }):Play()
        task.delay(0.2, function()
            if not isMinimized then
                TabBar.Visible = true
                ContentArea.Visible = true
            end
        end)
    end
end)

-- Анимация экрана загрузки
task.spawn(function()
    local steps = {
        {p = 0.25, t = "Загрузка конфигурации..."},
        {p = 0.55, t = "Подключение ESP & Tracer..."},
        {p = 0.85, t = "Загрузка Kill & Hit Sounds..."},
        {p = 1.00, t = "Готово!"}
    }
    for _, s in ipairs(steps) do
        LoadingStatus.Text = s.t
        TweenService:Create(ProgressBarFill, TweenInfo.new(0.6, Enum.EasingStyle.Quad), {Size = UDim2.new(s.p, 0, 1, 0)}):Play()
        task.wait(0.65)
    end
    task.wait(0.2)
    TweenService:Create(LoadingFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0)
    }):Play()
    task.wait(0.4)
    LoadingFrame:Destroy()
    MainFrame.Visible = true
end)

----------------------------------------------------
-- 4. СИСТЕМА ВКЛАДОК И СКРОЛЛА
----------------------------------------------------
local TabListLayout = Instance.new("UIListLayout")
TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabListLayout.Padding = UDim.new(0, 5)
TabListLayout.Parent = TabBar

local Tabs = {}

local function CreateTab(name)
    local TabBtn = Instance.new("TextButton")
    TabBtn.Size = UDim2.new(1, -10, 0, 32)
    TabBtn.Position = UDim2.new(0, 5, 0, 0)
    TabBtn.BackgroundColor3 = Color3.fromRGB(24, 24, 32)
    TabBtn.BorderSizePixel = 0
    TabBtn.Text = name
    TabBtn.TextColor3 = Color3.fromRGB(160, 160, 160)
    TabBtn.Font = Enum.Font.GothamMedium
    TabBtn.TextSize = 13
    TabBtn.Parent = TabBar

    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 6)
    BtnCorner.Parent = TabBtn

    -- Настроенный ScrollingFrame с гарантированным перерасчетом CanvasSize
    local Page = Instance.new("ScrollingFrame")
    Page.Size = UDim2.new(1, -10, 1, -10)
    Page.Position = UDim2.new(0, 5, 0, 5)
    Page.BackgroundTransparency = 1
    Page.BorderSizePixel = 0
    Page.ScrollBarThickness = 5
    Page.ScrollBarImageColor3 = Color3.fromRGB(0, 150, 255)
    Page.Visible = false
    Page.Parent = ContentArea

    local PageLayout = Instance.new("UIListLayout")
    PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
    PageLayout.Padding = UDim.new(0, 8)
    PageLayout.Parent = Page

    -- ФИКС СКРОЛЛА: Динамический перерасчет CanvasSize при добавлении элементов
    PageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        Page.CanvasSize = UDim2.new(0, 0, 0, PageLayout.AbsoluteContentSize.Y + 25)
    end)

    TabBtn.MouseButton1Click:Connect(function()
        for _, tab in pairs(Tabs) do
            tab.Page.Visible = false
            tab.Button.TextColor3 = Color3.fromRGB(160, 160, 160)
            tab.Button.BackgroundColor3 = Color3.fromRGB(24, 24, 32)
        end
        Page.Visible = true
        TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        TabBtn.BackgroundColor3 = Color3.fromRGB(0, 130, 230)
    end)

    Tabs[name] = {Button = TabBtn, Page = Page}
    return Page
end

local VisualsPage = CreateTab("Visuals")
local SoundsPage = CreateTab("Sounds")
local KeybindsPage = CreateTab("Keybinds")

Tabs["Visuals"].Page.Visible = true
Tabs["Visuals"].Button.BackgroundColor3 = Color3.fromRGB(0, 130, 230)
Tabs["Visuals"].Button.TextColor3 = Color3.fromRGB(255, 255, 255)

----------------------------------------------------
-- 5. ЭЛЕМЕНТЫ УПРАВЛЕНИЯ (TOGGLES & SELECTORS)
----------------------------------------------------
local function AddToggle(page, text, defaultState, callback)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Size = UDim2.new(1, -10, 0, 36)
    ToggleFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
    ToggleFrame.BorderSizePixel = 0
    ToggleFrame.Parent = page

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = ToggleFrame

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.65, 0, 1, 0)
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(220, 220, 220)
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Font = Enum.Font.Gotham
    Label.TextSize = 13
    Label.Parent = ToggleFrame

    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(0, 44, 0, 22)
    Btn.Position = UDim2.new(1, -54, 0.5, -11)
    Btn.BackgroundColor3 = defaultState and Color3.fromRGB(0, 150, 255) or Color3.fromRGB(45, 45, 55)
    Btn.Text = ""
    Btn.Parent = ToggleFrame

    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 11)
    BtnCorner.Parent = Btn

    local Circle = Instance.new("Frame")
    Circle.Size = UDim2.new(0, 16, 0, 16)
    Circle.Position = defaultState and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
    Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Circle.BorderSizePixel = 0
    Circle.Parent = Btn

    local CircleCorner = Instance.new("UICorner")
    CircleCorner.CornerRadius = UDim.new(1, 0)
    CircleCorner.Parent = Circle

    local state = defaultState
    Btn.MouseButton1Click:Connect(function()
        state = not state
        TweenService:Create(Btn, TweenInfo.new(0.2), {
            BackgroundColor3 = state and Color3.fromRGB(0, 150, 255) or Color3.fromRGB(45, 45, 55)
        }):Play()
        TweenService:Create(Circle, TweenInfo.new(0.2), {
            Position = state and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
        }):Play()
        callback(state)
    end)
end

local function AddSelector(page, title, options, defaultSelected, callback)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, -10, 0, 40)
    Frame.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
    Frame.BorderSizePixel = 0
    Frame.Parent = page

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = Frame

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.5, 0, 1, 0)
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = title
    Label.TextColor3 = Color3.fromRGB(220, 220, 220)
    Label.Font = Enum.Font.Gotham
    Label.TextSize = 13
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Frame

    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(0, 150, 0, 26)
    Btn.Position = UDim2.new(1, -160, 0.5, -13)
    Btn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    Btn.Text = defaultSelected
    Btn.TextColor3 = Color3.fromRGB(0, 170, 255)
    Btn.Font = Enum.Font.GothamBold
    Btn.TextSize = 11
    Btn.Parent = Frame

    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 5)
    BtnCorner.Parent = Btn

    local currentIndex = 1
    for i, opt in ipairs(options) do
        if opt == defaultSelected then currentIndex = i break end
    end

    Btn.MouseButton1Click:Connect(function()
        currentIndex = (currentIndex % #options) + 1
        local newOpt = options[currentIndex]
        Btn.Text = newOpt
        callback(newOpt)
    end)
end

-- VISUALS PAGE
AddToggle(VisualsPage, "Boxes (Боксы)", Config.ESP.Boxes, function(v) Config.ESP.Boxes = v end)
AddToggle(VisualsPage, "Skeleton (Скелет)", Config.ESP.Skeleton, function(v) Config.ESP.Skeleton = v end)
AddToggle(VisualsPage, "Tracer Bullets (Трейсеры)", Config.TracersEnabled, function(v) Config.TracersEnabled = v end)

-- SOUNDS PAGE
AddToggle(SoundsPage, "Kill Sound (Звук убийства)", Config.KillSoundEnabled, function(v) Config.KillSoundEnabled = v end)
AddSelector(SoundsPage, "Выбор Kill Sound", {"Mortal Kombat Headshot", "Neverlose", "Gamesense", "Rust"}, Config.SelectedKillSound, function(s)
    Config.SelectedKillSound = s
    PlayCustomSound(Sounds.KillSounds[s])
end)

AddToggle(SoundsPage, "Hit Sound (Звук попадания)", Config.HitSoundEnabled, function(v) Config.HitSoundEnabled = v end)
AddSelector(SoundsPage, "Выбор Hit Sound", {"Skeet", "Neverlose", "Bell"}, Config.SelectedHitSound, function(s)
    Config.SelectedHitSound = s
    PlayCustomSound(Sounds.HitSounds[s])
end)

-- KEYBINDS PAGE
local KeybindFrame = Instance.new("Frame")
KeybindFrame.Size = UDim2.new(1, -10, 0, 40)
KeybindFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
KeybindFrame.BorderSizePixel = 0
KeybindFrame.Parent = KeybindsPage

local KeyCorner = Instance.new("UICorner")
KeyCorner.CornerRadius = UDim.new(0, 6)
KeyCorner.Parent = KeybindFrame

local KeyLabel = Instance.new("TextLabel")
KeyLabel.Size = UDim2.new(0.6, 0, 1, 0)
KeyLabel.Position = UDim2.new(0, 10, 0, 0)
KeyLabel.BackgroundTransparency = 1
KeyLabel.Text = "Открыть / Скрыть меню"
KeyLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
KeyLabel.Font = Enum.Font.Gotham
KeyLabel.TextSize = 13
KeyLabel.TextXAlignment = Enum.TextXAlignment.Left
KeyLabel.Parent = KeybindFrame

local KeyBtn = Instance.new("TextButton")
KeyBtn.Size = UDim2.new(0, 90, 0, 26)
KeyBtn.Position = UDim2.new(1, -100, 0.5, -13)
KeyBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
KeyBtn.Text = Config.MenuKey.Name
KeyBtn.TextColor3 = Color3.fromRGB(0, 170, 255)
KeyBtn.Font = Enum.Font.GothamBold
KeyBtn.TextSize = 12
KeyBtn.Parent = KeybindFrame

local KeyBtnCorner = Instance.new("UICorner")
KeyBtnCorner.CornerRadius = UDim.new(0, 4)
KeyBtnCorner.Parent = KeyBtn

local binding = false
KeyBtn.MouseButton1Click:Connect(function()
    binding = true
    KeyBtn.Text = "..."
end)

UserInputService.InputBegan:Connect(function(input, gpe)
    if binding and input.UserInputType == Enum.UserInputType.Keyboard then
        Config.MenuKey = input.KeyCode
        KeyBtn.Text = input.KeyCode.Name
        binding = false
    elseif not gpe and input.KeyCode == Config.MenuKey then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

----------------------------------------------------
-- 6. ПОЛНОЦЕННАЯ РАБОЧАЯ СИСТЕМА ESP (БОКСЫ И СКЕЛЕТ)
----------------------------------------------------
local PlayerESP = {}

local function CreateESPForPlayer(player)
    if player == LocalPlayer then return end

    local BoxFrame = Instance.new("Frame")
    BoxFrame.Name = "Box_" .. player.Name
    BoxFrame.BackgroundTransparency = 1
    BoxFrame.BorderSizePixel = 0
    BoxFrame.Visible = false
    BoxFrame.Parent = EspContainer

    local BoxStroke = Instance.new("UIStroke")
    BoxStroke.Color = Config.ESP.BoxColor
    BoxStroke.Thickness = 1.5
    BoxStroke.Parent = BoxFrame

    local SkeletonFolder = Instance.new("Folder")
    SkeletonFolder.Name = "Skeleton_" .. player.Name
    SkeletonFolder.Parent = EspContainer

    PlayerESP[player] = {
        Box = BoxFrame,
        Skeleton = SkeletonFolder
    }
end

local function RemoveESPForPlayer(player)
    if PlayerESP[player] then
        if PlayerESP[player].Box then PlayerESP[player].Box:Destroy() end
        if PlayerESP[player].Skeleton then PlayerESP[player].Skeleton:Destroy() end
        PlayerESP[player] = nil
    end
end

for _, p in ipairs(Players:GetPlayers()) do CreateESPForPlayer(p) end
Players.PlayerAdded:Connect(CreateESPForPlayer)
Players.PlayerRemoving:Connect(RemoveESPForPlayer)

-- Функция отрисовки 2D-линии для Скелета
local function Draw2DLine(p1, p2, folder, lineIndex)
    local line = folder:FindFirstChild("Line_" .. lineIndex)
    if not line then
        line = Instance.new("Frame")
        line.Name = "Line_" .. lineIndex
        line.BackgroundColor3 = Config.ESP.SkeletonColor
        line.BorderSizePixel = 0
        line.AnchorPoint = Vector2.new(0.5, 0.5)
        line.Parent = folder
    end

    local distance = (p1 - p2).Magnitude
    local angle = math.atan2(p2.Y - p1.Y, p2.X - p1.X)

    line.Size = UDim2.new(0, distance, 0, 1.5)
    line.Position = UDim2.new(0, (p1.X + p2.X) / 2, 0, (p1.Y + p2.Y) / 2)
    line.Rotation = math.deg(angle)
    line.Visible = true
    return line
end

-- Цикл отрисовки ESP каждый кадр
RunService.RenderStepped:Connect(function()
    for player, esp in pairs(PlayerESP) do
        local char = player.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildOfClass("Humanoid")

        if char and hrp and hum and hum.Health > 0 then
            local head = char:FindFirstChild("Head")
            if head then
                local headPos, headOnScreen = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.7, 0))
                local legPos, legOnScreen = Camera:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3, 0))

                -- 1. ОТРИСОВКА БОКСОВ
                if headOnScreen and legOnScreen and Config.ESP.Boxes then
                    local height = math.abs(legPos.Y - headPos.Y)
                    local width = height * 0.55

                    esp.Box.Size = UDim2.new(0, width, 0, height)
                    esp.Box.Position = UDim2.new(0, headPos.X - (width / 2), 0, headPos.Y)
                    esp.Box.Visible = true
                else
                    esp.Box.Visible = false
                end

                -- 2. ОТРИСОВКА СКЕЛЕТА
                if headOnScreen and Config.ESP.Skeleton then
                    local limbs = {
                        {"Head", "UpperTorso"},
                        {"UpperTorso", "LowerTorso"},
                        {"UpperTorso", "LeftUpperArm"},
                        {"LeftUpperArm", "LeftLowerArm"},
                        {"LeftLowerArm", "LeftHand"},
                        {"UpperTorso", "RightUpperArm"},
                        {"RightUpperArm", "RightLowerArm"},
                        {"RightLowerArm", "RightHand"},
                        {"LowerTorso", "LeftUpperLeg"},
                        {"LeftUpperLeg", "LeftLowerLeg"},
                        {"LeftLowerLeg", "LeftFoot"},
                        {"LowerTorso", "RightUpperLeg"},
                        {"RightUpperLeg", "RightLowerLeg"},
                        {"RightRightLeg", "RightFoot"}
                    }
                    if not char:FindFirstChild("UpperTorso") then -- R6 поддержка
                        limbs = {
                            {"Head", "Torso"},
                            {"Torso", "Left Arm"},
                            {"Torso", "Right Arm"},
                            {"Torso", "Left Leg"},
                            {"Torso", "Right Leg"}
                        }
                    end

                    local lineIdx = 0
                    for _, joint in ipairs(limbs) do
                        local part1 = char:FindFirstChild(joint[1])
                        local part2 = char:FindFirstChild(joint[2])
                        if part1 and part2 then
                            local pos1, vis1 = Camera:WorldToViewportPoint(part1.Position)
                            local pos2, vis2 = Camera:WorldToViewportPoint(part2.Position)
                            if vis1 and vis2 then
                                lineIdx = lineIdx + 1
                                Draw2DLine(Vector2.new(pos1.X, pos1.Y), Vector2.new(pos2.X, pos2.Y), esp.Skeleton, lineIdx)
                            end
                        end
                    end
                    -- Скрываем неиспользуемые линии
                    for _, child in ipairs(esp.Skeleton:GetChildren()) do
                        local num = tonumber(child.Name:match("Line_(%d+)"))
                        if num and num > lineIdx then
                            child.Visible = false
                        end
                    end
                else
                    for _, child in ipairs(esp.Skeleton:GetChildren()) do
                        child.Visible = false
                    end
                end
            else
                esp.Box.Visible = false
            end
        else
            esp.Box.Visible = false
            for _, child in ipairs(esp.Skeleton:GetChildren()) do
                child.Visible = false
            end
        end
    end
end)

----------------------------------------------------
-- 7. ТРЕЙСЕРЫ ПУЛЬ (ИЗ ДУЛА В ТОЧКУ ВЫСТРЕЛА)
----------------------------------------------------
local function CreateBulletTracer(fromPos, toPos)
    if not Config.TracersEnabled then return end

    local line = Instance.new("Part")
    line.Name = "BulletTracer"
    line.Material = Enum.Material.Neon
    line.Color = Config.TracerColor
    line.CanCollide = false
    line.Anchored = true
    line.BorderSizePixel = 0

    local distance = (toPos - fromPos).Magnitude
    line.Size = Vector3.new(0.08, 0.08, distance)
    line.CFrame = CFrame.lookAt(fromPos, toPos) * CFrame.new(0, 0, -distance / 2)
    line.Parent = Workspace

    TweenService:Create(line, TweenInfo.new(Config.TracerDuration), {Transparency = 1}):Play()
    task.delay(Config.TracerDuration, function() line:Destroy() end)
end

local function GetMuzzlePosition(character)
    local tool = character:FindFirstChildOfClass("Tool")
    if tool then
        local muzzle = tool:FindFirstChild("Muzzle") or tool:FindFirstChild("Handle")
        if muzzle then return muzzle.Position end
    end
    return character:FindFirstChild("Head") and character.Head.Position or Vector3.new()
end

local function HookLocalPlayerCombat()
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    char.ChildAdded:Connect(function(child)
        if child:IsA("Tool") then
            child.Activated:Connect(function()
                local muzzlePos = GetMuzzlePosition(char)
                local targetPos = Mouse.Hit.Position
                CreateBulletTracer(muzzlePos, targetPos)
            end)
        end
    end)
end

LocalPlayer.CharacterAdded:Connect(HookLocalPlayerCombat)
if LocalPlayer.Character then HookLocalPlayerCombat() end

----------------------------------------------------
-- 8. ДЕТЕКТ ПОПАДАНИЯ И УБИЙСТВА (HITSOUND & KILLSOUND)
----------------------------------------------------
local function TrackEnemyCombat(player)
    if player == LocalPlayer then return end

    local function OnCharacter(char)
        local hum = char:WaitForChild("Humanoid", 5)
        if hum then
            local lastHealth = hum.Health
            hum.HealthChanged:Connect(function(newHealth)
                if newHealth < lastHealth then
                    local dmg = lastHealth - newHealth
                    if dmg > 0 and newHealth > 0 then
                        if Config.HitSoundEnabled then
                            PlayCustomSound(Sounds.HitSounds[Config.SelectedHitSound])
                        end
                    elseif newHealth <= 0 and lastHealth > 0 then
                        if Config.KillSoundEnabled then
                            PlayCustomSound(Sounds.KillSounds[Config.SelectedKillSound])
                        end
                    end
                end
                lastHealth = newHealth
            end)
        end
    end

    if player.Character then OnCharacter(player.Character) end
    player.CharacterAdded:Connect(OnCharacter)
end

for _, p in ipairs(Players:GetPlayers()) do TrackEnemyCombat(p) end
Players.PlayerAdded:Connect(TrackEnemyCombat)
