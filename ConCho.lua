--==================================================
-- SERVICES
--==================================================

local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")

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

    local Distance =
        (CFrameTarget.Position - Root.Position).Magnitude

    if Distance < 1 then
        return
    end

    local TweenInfoData = TweenInfo.new(
        Distance / _G.Settings.TweenSpeed,
        Enum.EasingStyle.Linear,
        Enum.EasingDirection.Out
    )

    local Tween = TweenService:Create(
        Root,
        TweenInfoData,
        {
            CFrame = CFrameTarget
        }
    )

    Tween:Play()

    return Tween
end


local function NoTween(CFrameTarget)

    local Character = LocalPlayer.Character
    local Root =
        Character and Character:FindFirstChild("HumanoidRootPart")

    if Root and CFrameTarget then
        Root.CFrame = CFrameTarget
    end
end


--==================================================
-- CHARACTER
--==================================================

local function ApplyCharacterSettings(Character)

    local Humanoid =
        Character:WaitForChild("Humanoid", 10)

    if not Humanoid then
        return
    end

    Humanoid.UseJumpPower = true
    Humanoid.WalkSpeed = _G.Settings.WalkSpeed
    Humanoid.JumpPower = _G.Settings.JumpPower
end


LocalPlayer.CharacterAdded:Connect(
    ApplyCharacterSettings
)

if LocalPlayer.Character then
    ApplyCharacterSettings(
        LocalPlayer.Character
    )
end


--==================================================
-- CHARACTER SETTINGS LOOP
--==================================================

task.spawn(function()

    while task.wait(0.5) do

        local Character = LocalPlayer.Character

        if not Character then
            continue
        end

        local Humanoid =
            Character:FindFirstChildOfClass("Humanoid")

        if not Humanoid then
            continue
        end

        if Humanoid.WalkSpeed ~= _G.Settings.WalkSpeed then
            Humanoid.WalkSpeed =
                _G.Settings.WalkSpeed
        end

        if Humanoid.UseJumpPower ~= true then
            Humanoid.UseJumpPower = true
        end

        if Humanoid.JumpPower ~= _G.Settings.JumpPower then
            Humanoid.JumpPower =
                _G.Settings.JumpPower
        end
    end
end)


--==================================================
-- UI LIBRARY
--==================================================

local redzlib

pcall(function()

    redzlib = loadstring(
        game:HttpGet(
            "https://pastefy.app/MAbSfkcD/raw"
        )
    )()

end)

if not redzlib then
    warn("Không tải được UI Library")
    return
end


--==================================================
-- WINDOW
--==================================================

local Window = redzlib:MakeWindow({

    Title = "DoMon Hub : Blox Fruits",

    SubTitle = "",

    SaveFolder = "OrangeV5.lua"
})


--==================================================
-- MINIMIZE BUTTON
--==================================================

Window:AddMinimizeButton({

    Button = {

        Image =
            "rbxassetid://114476175638281",

        BackgroundTransparency = 0,

        Size =
            UDim2.new(0, 55, 0, 55),

        BackgroundColor3 =
            Color3.fromRGB(30, 30, 30),

        BorderMode =
            Enum.BorderMode.Inset,

        BorderSizePixel = 2,

        BorderColor3 =
            Color3.fromRGB(255, 140, 0)
    },

    Corner = {

        CornerRadius =
            UDim.new(1, 0)
    }
})


--==================================================
-- TABS
--==================================================

local Tabs = {

    Main = Window:MakeTab({

        Title = "Tab General",

        Icon = "axe"
    }),

    Settings = Window:MakeTab({

        Title = "Tab Setting",

        Icon = "rbxassetid://7734053495"
    })
}


--==================================================
-- DUNGEON
--==================================================

Tabs.Main:AddSection({
    {"Dungeon Event"}
})


Tabs.Main:AddToggle({

    Name =
        "Tự Động Farm Dungeon + Qua Cửa",

    Flag =
        "Dungeon",

    Default =
        false,

    Callback = function(Value)

        _G.Settings.Dungeon = Value
    end
})

task.spawn(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/ohmay5/Main/refs/heads/main/DUngeonFarm.lua"))()
    end)
--==================================================
-- CARD
--==================================================

local AllCards = {

    "Lifesteal",
    "All Cooldowns",
    "HYPER!",
    "Fruit M1 Speed",
    "Armor",
    "Sniper",
    "Overflow",
    "Gun",
    "Melee",
    "Fruit",
    "Defense",
    "Fortress"
}


Tabs.Main:AddDropdown({

    Name =
        "Chọn Thẻ",

    Options =
        AllCards,

    MultiSelect =
        true,

    Flag =
        "SelectCards",

    Callback = function(Value)

        _G.Settings.SelectedCards =
            Value

    end
})


Tabs.Main:AddToggle({

    Name =
        "Tự Động Chọn Thẻ Dungeon",

    Flag =
        "PickCard",

    Default =
        true,

    Callback = function(Value)

        _G.Settings.PickCard =
            Value

if not Value then ResetPick() end

    end
})


--==================================================
-- SETTINGS
--==================================================

Tabs.Settings:AddSection({
    {"Settings / Configure"}
})


--==================================================
-- TWEEN SPEED
--==================================================

Tabs.Settings:AddSlider({

    Name =
        "Tốc Độ Tween",

    Min =
        50,

    Max =
        600,

    Default =
        _G.Settings.TweenSpeed,

    Callback = function(Value)

        _G.Settings.TweenSpeed =
            Value

    end
})


--==================================================
-- GRAPHICS
--==================================================

Tabs.Settings:AddButton({

    Name =
        "Xoá Hiệu Ứng [ Siêu Mượt Mobile ]",

    Description =
        "Giảm hiệu ứng đồ họa",

    Callback = function()

        Lighting.GlobalShadows = false

        Lighting.FogEnd = 9e9

        task.spawn(function()

            for _, Object
                in ipairs(game:GetDescendants()) do

                if Object:IsA("BasePart") then

                    Object.Material =
                        Enum.Material.SmoothPlastic

                    Object.CastShadow =
                        false

                elseif
                    Object:IsA("ParticleEmitter")
                    or Object:IsA("Trail")
                    or Object:IsA("Smoke")
                    or Object:IsA("Fire")
                    or Object:IsA("Sparkles") then

                    Object.Enabled = false

                elseif
                    Object:IsA("Decal")
                    or Object:IsA("Texture") then

                    Object.Transparency = 1
                end

                task.wait()
            end

        end)
    end
})


--==================================================
-- HAKI
--==================================================

Setting:AddToggle({
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
            if Boud then
                local I = {"HasBuso", "Buso"}

                if not plr.Character:FindFirstChild(I[1]) then
                    replicated.Remotes.CommF_:InvokeServer(I[2])
                end
            end
        end)
    end
end)


TabsSettings:AddToggle({
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
                replicated.Remotes.CommE:FireServer("ActivateAbility")
                task.wait(30)
            end
        end)
    end
end)


task.spawn(function()
    while task.wait(0.2) do
        pcall(function()
            if _G.RaceClickAutov4 then
                local Character = plr.Character
                local RaceEnergy = Character
                    and Character:FindFirstChild("RaceEnergy")

                if RaceEnergy and RaceEnergy.Value == 1 then
                    Useskills("nil", "Y")
                end
            end
        end)
    end
end)

--==================================================
-- WALK SPEED
--==================================================

Players = game:GetService("Players")
lp = Players.LocalPlayer

getgenv().WalkSpeedValue = 30
getgenv().JumpValue = 50

local function ApplyHumanoid(char)
    local hum = char:WaitForChild("Humanoid", 5)
    if not hum then return end

    local isApplying = false

    local function SetJump()
        if isApplying then return end

        isApplying = true
        hum.UseJumpPower = true
        hum.JumpPower = getgenv().JumpValue
        isApplying = false
    end

    local function SetSpeed()
        hum.WalkSpeed = getgenv().WalkSpeedValue
    end

    SetJump()
    SetSpeed()

    hum.StateChanged:Connect(function(_, newState)
        if newState == Enum.HumanoidStateType.Landed
            or newState == Enum.HumanoidStateType.Jumping
            or newState == Enum.HumanoidStateType.Freefall
            or newState == Enum.HumanoidStateType.Running
            or newState == Enum.HumanoidStateType.RunningNoPhysics then

            SetJump()
        end
    end)

    hum:GetPropertyChangedSignal("UseJumpPower"):Connect(function()
        if not hum.UseJumpPower then
            SetJump()
        end
    end)

    hum:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
        if hum.WalkSpeed ~= getgenv().WalkSpeedValue then
            SetSpeed()
        end
    end)
end

lp.CharacterAdded:Connect(function(char)
    ApplyHumanoid(char)
end)

if lp.Character then
    ApplyHumanoid(lp.Character)
end

task.spawn(function()
    while task.wait(0.2) do
        local char = lp.Character

        if char then
            local hum = char:FindFirstChild("Humanoid")

            if hum then
                local state = hum:GetState()

                local isMidAir =
                    state == Enum.HumanoidStateType.Jumping
                    or state == Enum.HumanoidStateType.Freefall

                if not isMidAir then
                    if not hum.UseJumpPower then
                        hum.UseJumpPower = true
                    end

                    if hum.JumpPower ~= getgenv().JumpValue then
                        hum.JumpPower = getgenv().JumpValue
                    end
                end

                if hum.WalkSpeed ~= getgenv().WalkSpeedValue then
                    hum.WalkSpeed = getgenv().WalkSpeedValue
                end
            end
        end
    end
end)

Tabs.Settings:AddSlider({
    Name = "Tăng Tốc Chạy",
    Min = 16,
    Max = 300,
    Default = getgenv().WalkSpeedValue,

    Callback = function(Value)
        getgenv().WalkSpeedValue = Value

        local hum = lp.Character
            and lp.Character:FindFirstChild("Humanoid")

        if hum then
            hum.WalkSpeed = Value
        end
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

        local hum = lp.Character
            and lp.Character:FindFirstChild("Humanoid")

        if hum then
            hum.UseJumpPower = true
            hum.JumpPower = Value
        end
    end
})

loadstring(game:HttpGet("https://raw.githubusercontent.com/ohmay5/Main/refs/heads/main/attachgun.txt"))()
_G.Settings = _G.Settings or {}
_G.Settings.FastAttack = true

-- Tốc độ FastAttack
local AttackDelay = 0.15

-- =========================
-- SERVICES
-- =========================

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Player = Players.LocalPlayer

if not Player then
    return
end

-- =========================
-- NET
-- =========================

local Net = ReplicatedStorage
    :WaitForChild("Modules")
    :WaitForChild("Net")

local RegisterAttack =
    Net:WaitForChild("RE/RegisterAttack")

local RegisterHit =
    Net:WaitForChild("RE/RegisterHit")

-- =========================
-- FOLDERS
-- =========================

local Enemies =
    workspace:FindFirstChild("Enemies")

local Characters =
    workspace:FindFirstChild("Characters")

-- =========================
-- CHECK
-- =========================

local function IsAlive(Character)
    local Humanoid =
        Character and Character:FindFirstChildOfClass("Humanoid")

    return Humanoid and Humanoid.Health > 0
end

local function GetCharacter()
    local Character = Player.Character

    if Character and IsAlive(Character) then
        return Character
    end

    return nil
end

-- =========================
-- FAST ATTACK
-- =========================

local FastAttack = {
    Distance = 55
}

function FastAttack:GetTargets()

    local Character = GetCharacter()

    if not Character then
        return {}, nil
    end

    local Root =
        Character:FindFirstChild("HumanoidRootPart")

    if not Root then
        return {}, nil
    end

    local Targets = {}
    local BasePart

    local function Scan(Folder)

        if not Folder then
            return
        end

        for _, Enemy in ipairs(Folder:GetChildren()) do

            if Enemy ~= Character then

                local Humanoid =
                    Enemy:FindFirstChildOfClass("Humanoid")

                if Humanoid and Humanoid.Health > 0 then

                    local Part =
                        Enemy:FindFirstChild("HumanoidRootPart")
                        or Enemy:FindFirstChild("Head")

                    if Part then

                        local Offset =
                            Root.Position - Part.Position

                        if Offset:Dot(Offset)
                            <= self.Distance * self.Distance then

                            Targets[#Targets + 1] = {
                                Enemy,
                                Part
                            }

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

    local Targets, BasePart =
        self:GetTargets()

    if not BasePart or #Targets == 0 then
        return
    end

    pcall(function()

        RegisterAttack:FireServer(0)

        RegisterHit:FireServer(
            BasePart,
            Targets
        )

    end)
end

-- =========================
-- LOOP
-- =========================

task.spawn(function()

    while _G.Settings.FastAttack do

        local Character = GetCharacter()

        if Character then

            local Tool =
                Character:FindFirstChildOfClass("Tool")

            if Tool and Tool.ToolTip ~= "Gun" then
                FastAttack:Attack()
            end
        end

        task.wait(AttackDelay)
    end
end)

print("[FastAttack] Started | Delay:", AttackDelay)