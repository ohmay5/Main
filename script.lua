local redzlib = loadstring(game:HttpGet("https://raw.githubusercontent.com/ohmay5/Main/refs/heads/main/UIREDZ.LUA"))()

local Window = redzlib:MakeWindow({
    Title = "Aim pvp Hub",
    SubTitle = "By You",
    SaveFolder = "AimHub.json"
})

local Player = Window:MakeTab({
    Title = "Local Player",
    Icon = "rbxassetid://13075651575"
})
	Player:AddSection({"Aimbot"});

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local plr = Players.LocalPlayer
local humanoid = plr.Character and plr.Character:FindFirstChildOfClass("Humanoid") or nil

plr.CharacterAdded:Connect(function(char)
    humanoid = char:WaitForChild("Humanoid")
end)

local SpeedEnabled = false
local JumpEnabled = false

local desiredSpeed = 16
local desiredJump = 50

local function protectSpeed()
    if humanoid then
        humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
            if SpeedEnabled and humanoid.WalkSpeed ~= desiredSpeed then
                humanoid.WalkSpeed = desiredSpeed
            end
        end)
    end
end

local function applyStats()
    if humanoid then
        if SpeedEnabled then humanoid.WalkSpeed = desiredSpeed end
        if JumpEnabled then humanoid.JumpPower = desiredJump end
    end
end

RunService.Heartbeat:Connect(function()
    if humanoid then
        if SpeedEnabled and humanoid.WalkSpeed ~= desiredSpeed then
            humanoid.WalkSpeed = desiredSpeed
        end
        if JumpEnabled and humanoid.JumpPower ~= desiredJump then
            humanoid.JumpPower = desiredJump
        end
    end
end)

plr.CharacterAdded:Connect(function(char)
    humanoid = char:WaitForChild("Humanoid")
    protectSpeed()
end)

protectSpeed()

-- Toggle para WalkSpeed
Player:AddToggle({
    Name = "Set WalkSpeed",
    Description = "Bật tốc độ chạy của bạn",
    Default = true,
    Callback = function(Value)
        SpeedEnabled = Value
        applyStats()
    end
})
Player:AddSlider({
    Name = "WalkSpeed Value",
    Description = "Kéo để chọn tốc độ",
    Default = 16,
    Min = 20,
    Max = 500,
    Rounding = 0,
    Callback = function(Value)
        desiredSpeed = Value
        applyStats()
    end
})
-- Input para definir valor da WalkSpeed

-- Toggle para JumpPower
Player:AddToggle({
	Name  = "Set JumpPower",
    Description = "Bật độ nhả cao của bạn",
    Default = true,
    Callback = function(Value)
        JumpEnabled = Value
        applyStats()
    end
})
Player:AddSlider({
    Name = "JumpPower Value",
    Description = "Kéo để chọn độ cao nhảy",
    Default = 50,
    Min = 50,
    Max = 900,
    Rounding = 0,
    Callback = function(Value)
        desiredJump = Value
        applyStats()
    end
})

Player:AddSection({"LocalPlayer Settings / Misc"});
Player:AddToggle({
	Name = "Instance Soru [ INF ]",
	Description = "Bật soru vô hạn",
	Default = true,
	Callback = function(I)
		_G.InfSoru = I;
		if I then
			getInfinity_Ability("Soru", _G.InfSoru);
		end;
	end,
});

Player:AddSection({"Settings Combat / Aimbot Settings"});
local v1 = loadstring(game:HttpGet("https://raw.githubusercontent.com/ohmay5/Main/refs/heads/main/Aimbot.lua.txt"))()

local AimbotEnabled = false
local AimPlayers = false
local AimMobs = false
local IgnoreMobs = true

-- ===============================
-- FUNÇÃO DE ATUALIZAÇÃO (COMPATÍVEL COM SUA LÓGICA)
-- ===============================
local function UpdateAimbot()
    if not AimbotEnabled then
        v1:SetPlayerSilentAim(false)
        v1:SetNPCSilentAim(false)
        return
    end

    -- Se estiver mirando players
    if AimPlayers then
        v1:SetPlayerSilentAim(true)
        v1:SetNPCSilentAim(false)
        return
    end

    -- Se estiver mirando mobs
    if AimMobs then
        if IgnoreMobs then
            v1:SetNPCSilentAim(false)
        else
            v1:SetNPCSilentAim(true)
        end
        v1:SetPlayerSilentAim(false)
        return
    end

    -- fallback de segurança
    v1:SetPlayerSilentAim(false)
    v1:SetNPCSilentAim(false)
end

-- ===============================
-- TOGGLE PRINCIPAL
-- ===============================
Player:AddToggle({
    Name = "Aimbot Gun",
    Default = true,
    Callback = function(v)
        AimbotEnabled = v

        if not v then
            v1:Pause()
        else
            v1:Restore()
        end

        UpdateAimbot()
    end
})

-- ===============================
-- AIM PLAYERS
-- ===============================
Player:AddToggle({
    Name = "Aimbot Tap",
    Default = true,
    Callback = function(v)
        AimPlayers = v

        if v then
            AimMobs = false
        end

        UpdateAimbot()
    end
})

-- ===============================
-- AIM MOBS
-- ===============================
Player:AddToggle({
    Name = "Aimbot Skills",
    Default = true,
    Callback = function(v)
        AimMobs = v

        if v then
            AimPlayers = false
        end

        UpdateAimbot()
    end
})

-- ===============================
-- IGNORE MOBS (AGORA FUNCIONAL)
-- ===============================
Player:AddToggle({
    Name = "Ignore Mobs",
    Default = true,
    Callback = function(v)
        IgnoreMobs = v
        UpdateAimbot()
    end
})

Player:AddSection({"Aimbot skill V2"})
local v1 = loadstring(game:HttpGet("https://raw.githubusercontent.com/ohmay5/Main/refs/heads/main/Aimbot.lua.txt"))()

local AimbotEnabled = false
local AimPlayers = false
local AimMobs = false

Player:AddToggle({
    Name = "Enable Aimbot Skill",
    Default = true,
    Callback = function(v)
        AimbotEnabled = v

        if not v then
            v1:Pause()
            v1:SetPlayerSilentAim(false)
            v1:SetNPCSilentAim(false)
        else
            if AimPlayers then
                v1:SetPlayerSilentAim(true)
            end
            if AimMobs then
                v1:SetNPCSilentAim(true)
            end
            v1:Restore()
        end
    end
})

Player:AddToggle({
    Name = "Aimbot on Players(Ghim người chơi)",
    Default = false,
    Callback = function(v)
        AimPlayers = v

        if v then
            AimMobs = false
            v1:SetNPCSilentAim(false)
        end

        if AimbotEnabled then
            v1:SetPlayerSilentAim(v)
        else
            v1:SetPlayerSilentAim(false)
        end
    end
})

Player:AddToggle({
    Name = "Aimbot on Mobs(Ghim quái)",
    Default = false,
    Callback = function(v)
        AimMobs = v

        if v then
            AimPlayers = false
            v1:SetPlayerSilentAim(false)
        end

        if AimbotEnabled then
            v1:SetNPCSilentAim(v)
        else
            v1:SetNPCSilentAim(false)
        end
    end
})
