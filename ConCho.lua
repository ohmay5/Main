--==================================================
-- SERVICES
--==================================================

local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer


--==================================================
-- SETTINGS
--==================================================

_G.Settings = _G.Settings or {}

_G.Settings.Dungeon = false
_G.Settings.PickCard = true
_G.Settings.Buso = false
_G.Settings.RaceV3 = false
_G.Settings.RaceV4 = false
_G.Settings.FastAttack = true

_G.Settings.WalkSpeed = 30
_G.Settings.JumpPower = 50
_G.Settings.TweenSpeed = 300

_G.Settings.SelectedCards = {
    Melee = true
}


--==================================================
-- TWEEN
--==================================================

local function TweenTo(CFrameTarget)
    local Character = LocalPlayer.Character
    if not Character then return end

    local Root = Character:FindFirstChild("HumanoidRootPart")
    if not Root or not CFrameTarget then return end

    local Distance = (CFrameTarget.Position - Root.Position).Magnitude
    if Distance < 1 then return end

    local TweenInfoData = TweenInfo.new(
        Distance / _G.Settings.TweenSpeed,
        Enum.EasingStyle.Linear,
        Enum.EasingDirection.Out
    )

    local Tween = TweenService:Create(Root, TweenInfoData, {CFrame = CFrameTarget})
    Tween:Play()
    return Tween
end


local function NoTween(CFrameTarget)
    local Character = LocalPlayer.Character
    local Root = Character and Character:FindFirstChild("HumanoidRootPart")
    if Root and CFrameTarget then
        Root.CFrame = CFrameTarget
    end
end


--==================================================
-- CHARACTER SETTINGS LOOP
--==================================================

local function ApplyCharacterSettings(Character)
    local Humanoid = Character:WaitForChild("Humanoid", 10)
    if not Humanoid then return end

    Humanoid.UseJumpPower = true
    Humanoid.WalkSpeed = _G.Settings.WalkSpeed
    Humanoid.JumpPower = _G.Settings.JumpPower
end

LocalPlayer.CharacterAdded:Connect(ApplyCharacterSettings)
if LocalPlayer.Character then
    ApplyCharacterSettings(LocalPlayer.Character)
end

task.spawn(function()
    while task.wait(0.5) do
        local Character = LocalPlayer.Character
        if not Character then continue end
        local Humanoid = Character:FindFirstChildOfClass("Humanoid")
        if not Humanoid then continue end

        if Humanoid.WalkSpeed ~= _G.Settings.WalkSpeed then
            Humanoid.WalkSpeed = _G.Settings.WalkSpeed
        end
        if Humanoid.UseJumpPower ~= true then
            Humanoid.UseJumpPower = true
        end
        if Humanoid.JumpPower ~= _G.Settings.JumpPower then
            Humanoid.JumpPower = _G.Settings.JumpPower
        end
    end
end)


--==================================================
-- UI LIBRARY
--==================================================

local redzlib
pcall(function()
    redzlib = loadstring(game:HttpGet("https://pastefy.app/MAbSfkcD/raw"))()
end)

if not redzlib then
    warn("Không tải được UI Library")
    return
end


--==================================================
-- WINDOW & TABS
--==================================================

local Window = redzlib:MakeWindow({
    Title = "DoMon Hub : Blox Fruits",
    SubTitle = "",
    SaveFolder = "OrangeV5.lua"
})

Window:AddMinimizeButton({
    Button = {
        Image = "rbxassetid://114476175638281",
        BackgroundTransparency = 0,
        Size = UDim2.new(0, 55, 0, 55),
        BackgroundColor3 = Color3.fromRGB(30, 30, 30),
        BorderMode = Enum.BorderMode.Inset,
        BorderSizePixel = 2,
        BorderColor3 = Color3.fromRGB(255, 140, 0)
    },
    Corner = {
        CornerRadius = UDim.new(1, 0)
    }
})

local Tabs = {
    Main = Window:MakeTab({ Title = "Tab General", Icon = "axe" }),
    Settings = Window:MakeTab({ Title = "Tab Setting", Icon = "rbxassetid://7734053495" })
}


--==================================================
-- DUNGEON & CARDS
--==================================================

Tabs.Main:AddSection({{"Dungeon Event"}})
Tabs.Main:AddDropdown({
    Name = "Select Weapon",
    Description = "Chọn vũ khí",
    Options = {"Melee", "Sword", "Blox Fruit", "Gun"},
    Default = "Melee",
    Multi = false,
    Callback = function(I)
        _G.ChooseWP = I
    end,
})

_G.ChooseWP = "Melee"

spawn(function()
    while task.wait(Sec) do
        pcall(function()
            for _, e in pairs(plr.Backpack:GetChildren()) do
                if e.ToolTip == _G.ChooseWP then
                    _G.SelectWeapon = e.Name
                    break
                end
            end
        end)
    end
end)

Tabs.Main:AddToggle({
    Name = "Tự Động Farm Dungeon + Qua Cửa",
    Flag = "Dungeon",
    Default = false,
    Callback = function(Value)
        _G.Settings.Dungeon = Value
    end
})

task.spawn(function()
    pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/ohmay5/Main/refs/heads/main/DUngeonFarm.lua"))()
    end)
end)

local AllCards = {
    "Lifesteal", "All Cooldowns", "HYPER!", "Fruit M1 Speed",
    "Armor", "Sniper", "Overflow", "Gun", "Melee", "Fruit", "Defense", "Fortress"
}

Tabs.Main:AddDropdown({
    Name = "Chọn Thẻ",
    Options = AllCards,
    MultiSelect = true,
    Flag = "SelectCards",
    Callback = function(Value)
        _G.Settings.SelectedCards = Value
    end
})

Tabs.Main:AddToggle({
    Name = "Tự Động Chọn Thẻ Dungeon",
    Flag = "PickCard",
    Default = true,
    Callback = function(Value)
        _G.Settings.PickCard = Value
    end
})


--==================================================
-- SETTINGS TAB
--==================================================

Tabs.Settings:AddSection({{"Settings / Configure"}})

Tabs.Settings:AddSlider({
    Name = "Tốc Độ Tween",
    Min = 50,
    Max = 600,
    Default = _G.Settings.TweenSpeed,
    Callback = function(Value)
        _G.Settings.TweenSpeed = Value
    end
})

Tabs.Settings:AddButton({
    Name = "Xoá Hiệu Ứng [ Siêu Mượt Mobile ]",
    Description = "Giảm hiệu ứng đồ họa",
    Callback = function()
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 9e9
        task.spawn(function()
            for _, Object in ipairs(game:GetDescendants()) do
                if Object:IsA("BasePart") then
                    Object.Material = Enum.Material.SmoothPlastic
                    Object.CastShadow = false
                elseif Object:IsA("ParticleEmitter") or Object:IsA("Trail") or Object:IsA("Smoke") or Object:IsA("Fire") or Object:IsA("Sparkles") then
                    Object.Enabled = false
                elseif Object:IsA("Decal") or Object:IsA("Texture") then
                    Object.Transparency = 1
                end
                task.wait()
            end
        end)
    end
})


--==================================================
-- HAKI & RACES (FIXED)
--==================================================

local Boud = true
local Sec = 0.5

Tabs.Settings:AddToggle({
    Name = "Auto Active Haki",
    Description = "tự động kích hoạt haki",
    Default = true,
    Callback = function(I)
        Boud = I
    end,
})

task.spawn(function()
    while task.wait(Sec) do
        pcall(function()
            if Boud and LocalPlayer.Character then
                if not LocalPlayer.Character:FindFirstChild("HasBuso") then
                    ReplicatedStorage.Remotes.CommF_:InvokeServer("Buso")
                end
            end
        end)
    end
end)

Tabs.Settings:AddToggle({
    Name = "Auto Active V3",
    Description = "tự động dùng tộc v3",
    Default = false,
    Callback = function(I)
        _G.RaceClickAutov3 = I
    end,
})

Tabs.Settings:AddToggle({
    Name = "Auto Active V4",
    Description = "tự động dùng tộc v4",
    Default = false,
    Callback = function(I)
        _G.RaceClickAutov4 = I
    end,
})

task.spawn(function()
    while task.wait(0.2) do
        pcall(function()
            if _G.RaceClickAutov3 then
                ReplicatedStorage.Remotes.CommE:FireServer("ActivateAbility")
                task.wait(30)
            end
        end)
    end
end)

task.spawn(function()
    while task.wait(0.2) do
        pcall(function()
            if _G.RaceClickAutov4 and LocalPlayer.Character then
                local RaceEnergy = LocalPlayer.Character:FindFirstChild("RaceEnergy")
                if RaceEnergy and RaceEnergy.Value == 1 then
                    VirtualUser:Button1Down(Vector2.new(0,0))
                    VirtualUser:Button1Up(Vector2.new(0,0))
                end
            end
        end)
    end
end)


--==================================================
-- WALK SPEED & JUMP SLIDERS
--==================================================

getgenv().WalkSpeedValue = 30
getgenv().JumpValue = 50

Tabs.Settings:AddSlider({
    Name = "Tăng Tốc Chạy",
    Min = 16,
    Max = 300,
    Default = getgenv().WalkSpeedValue,
    Callback = function(Value)
        getgenv().WalkSpeedValue = Value
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
        if hum then hum.WalkSpeed = Value end
    end
})

Tabs.Settings:AddSlider({
    Name = "Tăng Sức Bật Nhảy",
    Min = 50,
    Max = 350,
    Default = getgenv().JumpValue,
    Description = "Chỉnh khoảng 200-300 là ổn",
    Callback = function(Value)
        getgenv().JumpValue = Value
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
        if hum then
            hum.UseJumpPower = true
            hum.JumpPower = Value
        end
    end
})


--==================================================
-- FAST ATTACK
--==================================================

task.spawn(function()
    pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/ohmay5/Main/refs/heads/main/attachgun.txt"))()
    end)
end)

local AttackDelay = 0.15
local Net = ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Net")
local RegisterAttack = Net:WaitForChild("RE/RegisterAttack")
local RegisterHit = Net:WaitForChild("RE/RegisterHit")

local Enemies = workspace:FindFirstChild("Enemies")
local Characters = workspace:FindFirstChild("Characters")

local function IsAlive(Character)
    local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
    return Humanoid and Humanoid.Health > 0
end

local function GetCharacter()
    local Character = LocalPlayer.Character
    if Character and IsAlive(Character) then return Character end
    return nil
end

local FastAttack = { Distance = 55 }

function FastAttack:GetTargets()
    local Character = GetCharacter()
    if not Character then return {}, nil end
    local Root = Character:FindFirstChild("HumanoidRootPart")
    if not Root then return {}, nil end

    local Targets = {}
    local BasePart

    local function Scan(Folder)
        if not Folder then return end
        for _, Enemy in ipairs(Folder:GetChildren()) do
            if Enemy ~= Character then
                local Humanoid = Enemy:FindFirstChildOfClass("Humanoid")
                if Humanoid and Humanoid.Health > 0 then
                    local Part = Enemy:FindFirstChild("HumanoidRootPart") or Enemy:FindFirstChild("Head")
                    if Part then
                        local Offset = Root.Position - Part.Position
                        if Offset:Dot(Offset) <= self.Distance * self.Distance then
                            Targets[#Targets + 1] = {Enemy, Part}
                            BasePart = Part
                        end
                    end
                end
            end
        end
    end

    Scan(Enemies)
    Scan(Characters)
    return Targets, BasePart
end

function FastAttack:Attack()
    local Targets, BasePart = self:GetTargets()
    if not BasePart or #Targets == 0 then return end
    pcall(function()
        RegisterAttack:FireServer(0)
        RegisterHit:FireServer(BasePart, Targets)
    end)
end

task.spawn(function()
    while task.wait(AttackDelay) do
        if _G.Settings.FastAttack then
            local Character = GetCharacter()
            if Character then
                local Tool = Character:FindFirstChildOfClass("Tool")
                if Tool and Tool.ToolTip ~= "Gun" then
                    FastAttack:Attack()
                end
            end
        end
    end
end)

print("[FastAttack] Started | Delay:", AttackDelay)
