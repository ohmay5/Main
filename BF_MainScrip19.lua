
do
    ply = Services.Players
    plr = ply.LocalPlayer
    Root = plr.Character.HumanoidRootPart
    replicated = Services.ReplicatedStorage
    Lv = plr.Data.Level.Value
    TeleportService = Services.TeleportService
    TW = Services.TweenService
    Lighting = Services.Lighting
    Enemies = workspace.Enemies
    vim1 = Services.VirtualInputManager
    vim2 = Services.VirtualUser
    TeamSelf = plr.Team
    RunSer = Services.RunService
    Stats = Services.Stats
    Energy = plr.Character.Energy.Value
    
    -- Tables
    Boss = {}
    BringConnections = {}
    MaterialList = {}
    NPCList = {}
    
    -- Flags
    shouldTween = false
    SoulGuitar = false
    KenTest = true
    debug = false
    Brazier1 = false
    Brazier2 = false
    Brazier3 = false
    Sec = 0.1
    ClickState = 0
    Num_self = 25
end
Dungeon = false

local placeId = game.PlaceId
elseif placeId == 73902483975735 then
    Dungeon = true
end

EquipWeapon = function(I)
		if not I then
			return;
		end;
		if plr.Backpack:FindFirstChild(I) then
			plr.Character.Humanoid:EquipTool(plr.Backpack:FindFirstChild(I));
		end;
	end;
weaponSc = function(I)
		for e, K in pairs(plr.Backpack:GetChildren()) do
			if K:IsA("Tool") then
				if K.ToolTip == I then
					EquipWeapon(K.Name);
				end;
			end;
		end;
	end;

local G = {};
G.__index = G;
G.Alive = function(I)
		if not I then
			return;
		end;
		local e = I:FindFirstChild("Humanoid");
		return e and e.Health > 0;
	end;
G.Pos = function(I, e)
		return (Root.Position - mode.Position).Magnitude <= e;
	end;
G.Dist = function(I, e)
		return (Root.Position - (I:FindFirstChild("HumanoidRootPart")).Position).Magnitude <= e;
	end;
G.DistH = function(I, e)
		return (Root.Position - (I:FindFirstChild("HumanoidRootPart")).Position).Magnitude > e;
	end;
-- ALTURA ÚNICA AJUSTÁVEL DO MOB
_G.MobHeight = _G.MobHeight or 20

G.Kill = function(I, e)
	if not (I and e) then return end

	local hrp = I:FindFirstChild("HumanoidRootPart")
	if not hrp then return end

	-- trava posição do mob
	if not I:GetAttribute("Locked") then
		I:SetAttribute("Locked", hrp.CFrame)
	end

	-- posição alvo do bring
	PosMon = (I:GetAttribute("Locked")).Position

	-- equipa arma
	EquipWeapon(_G.SelectWeapon)

	local tool = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool")
	if not tool then return end

	-- TP acima do mob (altura única)
	_tp(hrp.CFrame * CFrame.new(0, _G.MobHeight, 0))
     task.wait(0.05)
	-- Gọi bring sau khi đã cầm vũ khí và TP
	_B = true
	BringEnemy()
end
_G = _G or {}

_B = false
PosMon = nil

_G.BringRange = _G.BringRange or 230
_G.MaxBringMobs = _G.MaxBringMobs or 6 -- LIMITE DE MOBS

_G.FarmPriorityElf = _G.FarmPriorityElf or false
_G.FarmMastery_S   = _G.FarmMastery_S or false

local TweenService = game:GetService("TweenService")
local TweenInfoBring = TweenInfo.new(
    0.50, -- velocidade do tween
    Enum.EasingStyle.Linear,
    Enum.EasingDirection.Out
)

--==================================================
-- FUNÇÃO: VERIFICA SE QUALQUER FARM ESTÁ ATIVO
--==================================================
local function FarmAtivo()
    -- PRIORIDADE ABSOLUTA (ELF)
    if _G.FarmPriorityElf or _G.FarmElfLevelCustom then
        return true
    end

    -- AUTO MASTERY ALL SWORD (INDEPENDENTE DO START FARM)  
    if _G.FarmMastery_S then  
        return true  
    end  

    -- OUTROS FARMS (DEPENDENTES DO START FARM)  
    return _G.StartFarm and (
        _G.Level or  
        _G.AutoFarm_Bone or  
        _G.AutoFarm_Cake or  
        _G.FarmMastery_Dev or  
        _G.FarmMastery_G or  
        (getgenv()).AutoMaterial or  
        _G.AutoTyrant or
        _G.SailBoat_Hydra or _G.WardenBoss or _G.AutoFactory or _G.HighestMirage or _G.HCM or _G.PGB or _G.Leviathan1 or _G.UPGDrago or _G.Complete_Trials or _G.TpDrago_Prehis or _G.BuyDrago or _G.AutoFireFlowers or _G.DT_Uzoth or _G.AutoBerry or _G.Prehis_Find or _G.Prehis_Skills or _G.Prehis_DB or _G.Prehis_DE or _G.FarmBlazeEM or _G.Dojoo or _G.CollectPresent or _G.AutoLawKak or _G.TpLab or _G.AutoPhoenixF or _G.AutoHytHallow or _G.LongsWord or _G.BlackSpikey or _G.AutoHolyTorch or _G.TrainDrago or _G.AutoSaber or _G.FarmMastery_Dev or _G.CitizenQuest or _G.AutoEctoplasm or _G.KeysRen or _G.Auto_Rainbow_Haki or _G.obsFarm or _G.AutoBigmom or _G.Doughv2 or _G.AuraBoss or _G.Raiding or _G.Auto_Cavender or _G.TpPly or _G.Level or _G.FarmEliteHunt or _G.AutoZou or _G.AutoFarm_Bone or (getgenv()).AutoMaterial or _G.CraftVM or _G.FrozenTP or _G.TPDoor or _G.AcientOne or _G.AutoFarmNear or _G.AutoRaidCastle or _G.DarkBladev3 or _G.AutoFarmRaid or _G.Auto_Cake_Prince or _G.Addealer or _G.TPNpc or _G.TwinHook or _G.FindMirage or _G.FarmChestM or _G.Shark or _G.TerrorShark or _G.Piranha or _G.MobCrew or _G.SeaBeast1 or _G.FishBoat or _G.Auto or _G.AutoPoleV2 or _G.Auto_SuperHuman or _G.AutoDeathStep or _G.Auto_SharkMan_Karate or _G.Auto_Electric_Claw or _G.AutoDragonTalon or _G.Auto_Def_DarkCoat or _G.Auto_God_Human or _G.Auto_Tushita or _G.AutoMatSoul or _G.AutoKenVTWO or _G.AutoSerpentBow or _G.AutoFMon or _G.Auto_Soul_Guitar or _G.TPGEAR or _G.AutoSaw or _G.AutoTridentW2 or _G.Auto_StartRaid or _G.AutoEvoRace or _G.AutoGetQuestBounty or _G.MarinesCoat or _G.TravelDres or _G.Defeating or _G.DummyMan or _G.Auto_Yama or _G.Auto_SwanGG or _G.SwanCoat or _G.AutoEcBoss or _G.Auto_Human or _G.CDK_TS or _G.CDK_YM or _G.CDK or _G.AutoFarmGodChalice or _G.AutoFistDarkness or _G.AutoMiror or _G.Teleport or _G.AutoKilo or _G.AutoGetUsoap or _G.Praying or _G.TryLucky or _G.AutoColShad or _G.AutoUnHaki or _G.AutoRipIngay or _G.DragoV3 or _G.DragoV1 or _G.SailBoats or NextIs or _G.FarmGodChalice or _G.IceBossRen or senth or senth2 or _G.Lvthan or _G.beasthunter or _G.DangerLV or _G.Relic123 or _G.tweenKitsune or _G.Collect_Ember or _G.AutofindKitIs or _G.snaguine or _G.TwFruits or _G.tweenKitShrine or _G.Tp_LgS or _G.Tp_MasterA or _G.tweenShrine or _G.FarmMastery_G or _G.FarmMastery_S or getgenv().AutoCyborg or _G.AutoBartilo or G.AutoRaceV3 or _G.Greybeard or _G.AutoKeyRen or _G.AutoDoughKing
    )
end

--==================================================
-- FUNÇÃO: IGNORA MOBS INDESEJADOS
--==================================================
local function IsRaidMob(mob)
    local n = mob.Name:lower()

    if n:find("raid") or n:find("microchip") or n:find("island") then  
        return true  
    end  

    if mob:GetAttribute("IsRaid")  
        or mob:GetAttribute("RaidMob")  
        or mob:GetAttribute("IsBoss") then  
        return true  
    end  

    local hum = mob:FindFirstChild("Humanoid")  
    if hum and hum.WalkSpeed == 0 then  
        return true  
    end  

    if mob.Parent and tostring(mob.Parent):lower():find("_worldorigin") then  
        return true  
    end  

    return false
end

--==================================================
-- FUNÇÃO PRINCIPAL: BRING
--==================================================
BringEnemy = function()
    if not (FarmAtivo() or _G.AutoBartilo) or not _B then return end

    local plr = game.Players.LocalPlayer  
    local char = plr.Character  
    local hrp = char and char:FindFirstChild("HumanoidRootPart")  
    if not hrp then return end  

    pcall(function()  
        sethiddenproperty(plr, "SimulationRadius", math.huge)  
    end)  

    local targetPos = PosMon or hrp.Position  
    local enemies = workspace.Enemies:GetChildren()  
    
    -- SẮP XẾP QUÁI THEO KHOẢNG CÁCH (Ưu tiên kéo quái ở gần trước)
    table.sort(enemies, function(a, b)
        local rootA = a:FindFirstChild("HumanoidRootPart")
        local rootB = b:FindFirstChild("HumanoidRootPart")
        if rootA and rootB then
            return (rootA.Position - targetPos).Magnitude < (rootB.Position - targetPos).Magnitude
        end
        return false
    end)

    local count = 0  

    for _, mob in ipairs(enemies) do  
        if count >= _G.MaxBringMobs then break end  

        local hum = mob:FindFirstChild("Humanoid")  
        local root = mob:FindFirstChild("HumanoidRootPart")  

        if hum and root and hum.Health > 0 and not IsRaidMob(mob) then  
            local dist = (root.Position - targetPos).Magnitude  

            if dist <= _G.BringRange then  
                count += 1  

                for _, part in ipairs(mob:GetChildren()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end

                hum:ChangeState(Enum.HumanoidStateType.Physics)
                root.Velocity = Vector3.zero
                root.RotVelocity = Vector3.zero

                if dist < 6 then
                    root.CFrame = CFrame.new(targetPos)
                else
                    root.CFrame = root.CFrame:Lerp(CFrame.new(targetPos), 0.3)
                end

                task.defer(function()
                    if hum and hum.Health > 0 then
                        hum:ChangeState(Enum.HumanoidStateType.GettingUp)
                    end
                end)
            end  
        end  
    end
end
task.spawn(function()
    while task.wait(0.1) do
        if FarmAtivo() or _G.AutoBartilo then
            _B = true
            BringEnemy()
        else  
            _B = false  
        end  
    end
end)

-- [[ VARIÁVEIS PARA O SEU INPUT ]] --
getgenv().TweenSpeedFar = 255  -- Velocidade Padrão (Longe)
getgenv().TweenSpeedNear = 255  -- Velocidade Boost (Perto <= 15 studs)

_tp = function(I)
local e = plr.Character;
if not e or not e:FindFirstChild("HumanoidRootPart") then
return;
end;

local HRP = e.HumanoidRootPart;  

-- Desativar farm enquanto tweena  
shouldTween = true  
getgenv().OnFarm = false  

-- Garantir que não está ancorado  
if HRP.Anchored then  
	HRP.Anchored = false  
	task.wait()  
end  

local dist = (I.Position - HRP.Position).Magnitude  

-- ===============================  
--  SE ESTIVER ATÉ 15 STUDS → USA A VELOCIDADE DE PERTO
--  CASO CONTRÁRIO → USA A VELOCIDADE PADRÃO
-- ===============================  
local speed = dist <= 15 and (getgenv().TweenSpeedNear or 255) or (getgenv().TweenSpeedFar or 255)

local info = TweenInfo.new(dist / speed, Enum.EasingStyle.Linear)  
local tween = game:GetService("TweenService"):Create(C, info, { CFrame = I })  

-- Caso esteja sentado  
if e.Humanoid.Sit == true then  
	C.CFrame = CFrame.new(C.Position.X, I.Y, C.Position.Z)  
end  

tween:Play()  

-- Anti travamento / controle  
task.spawn(function()  
	while tween.PlaybackState == Enum.PlaybackState.Playing do  
		if not shouldTween then  
			tween:Cancel()  
			break  
		end  
		task.wait(.1)  
	end  

	getgenv().OnFarm = true  
end)

end

TeleportToTarget = function(I)
_tp(I)
end

notween = function(I)
plr.Character.HumanoidRootPart.CFrame = I
end


function BTP(I)
	local e = game.Players.LocalPlayer;
	local K = e.Character.HumanoidRootPart;
	local n = e.Character.Humanoid;
	local d = e.PlayerGui.Main;
	local z = I.Position;
	local H = K.Position;

	repeat
		n.Health = 0;
		K.CFrame = I;
		d.Quest.Visible = false;

		if (K.Position - H).Magnitude > 1 then
			H = K.Position;
			K.CFrame = I;
		end;

		task.wait(.5);
	until (I.Position - K.Position).Magnitude <= 2000;
end;
spawn(function()
	while task.wait() do
		pcall(function()
			if _G.SailBoat_Hydra or _G.WardenBoss or _G.AutoFactory or _G.HighestMirage or _G.HCM or _G.PGB or _G.Leviathan1 or _G.UPGDrago or _G.Complete_Trials or _G.TpDrago_Prehis or _G.BuyDrago or _G.AutoFireFlowers or _G.DT_Uzoth or _G.AutoBerry or _G.Prehis_Find or _G.Prehis_Skills or _G.Prehis_DB or _G.Prehis_DE or _G.FarmBlazeEM or _G.Dojoo or _G.CollectPresent or _G.AutoLawKak or _G.TpLab or _G.AutoPhoenixF or _G.AutoFarmChest or _G.AutoHytHallow or _G.LongsWord or _G.BlackSpikey or _G.AutoHolyTorch or _G.TrainDrago or _G.AutoSaber or _G.FarmMastery_Dev or _G.CitizenQuest or _G.AutoEctoplasm or _G.KeysRen or _G.Auto_Rainbow_Haki or _G.obsFarm or _G.AutoBigmom or _G.Doughv2 or _G.AuraBoss or _G.Raiding or _G.Auto_Cavender or _G.TpPly or _G.Level or _G.FarmEliteHunt or _G.AutoZou or _G.AutoFarm_Bone or (getgenv()).AutoMaterial or _G.CraftVM or _G.FrozenTP or _G.TPDoor or _G.AcientOne or _G.AutoFarmNear or _G.AutoRaidCastle or _G.DarkBladev3 or _G.AutoFarmRaid or _G.Auto_Cake_Prince or _G.Addealer or _G.TPNpc or _G.TwinHook or _G.FindMirage or _G.FarmChestM or _G.Shark or _G.TerrorShark or _G.Piranha or _G.MobCrew or _G.SeaBeast1 or _G.FishBoat or _G.Auto or _G.AutoPoleV2 or _G.Auto_SuperHuman or _G.AutoDeathStep or _G.Auto_SharkMan_Karate or _G.Auto_Electric_Claw or _G.AutoDragonTalon or _G.Auto_Def_DarkCoat or _G.Auto_God_Human or _G.Auto_Tushita or _G.AutoMatSoul or _G.AutoKenVTWO or _G.AutoSerpentBow or _G.AutoFMon or _G.Auto_Soul_Guitar or _G.TPGEAR or _G.AutoSaw or _G.AutoTridentW2 or _G.Auto_StartRaid or _G.AutoEvoRace or _G.AutoGetQuestBounty or _G.MarinesCoat or _G.TravelDres or _G.Defeating or _G.DummyMan or _G.Auto_Yama or _G.Auto_SwanGG or _G.SwanCoat or _G.AutoEcBoss or _G.Auto_Human or _G.CDK_TS or _G.CDK_YM or _G.CDK or _G.AutoFarmGodChalice or _G.AutoFistDarkness or _G.AutoMiror or _G.Teleport or _G.AutoKilo or _G.AutoGetUsoap or _G.Praying or _G.TryLucky or _G.AutoColShad or _G.AutoUnHaki or _G.Auto_DonAcces or _G.AutoRipIngay or _G.DragoV3 or _G.DragoV1 or _G.SailBoats or NextIs or _G.FarmGodChalice or _G.IceBossRen or senth or senth2 or _G.Lvthan or _G.beasthunter or _G.DangerLV or _G.Relic123 or _G.tweenKitsune or _G.Collect_Ember or _G.AutofindKitIs or _G.snaguine or _G.TwFruits or _G.tweenKitShrine or _G.Tp_LgS or _G.Tp_MasterA or _G.tweenShrine or _G.FarmMastery_G or _G.FarmMastery_S or getgenv().AutoNewWorld or getgenv().UpgradeRaceV2 or getgenv().AutoRaceV2 or getgenv().AutoCyborg or _G.AutoBartilo or G.AutoRaceV3 or _G.Greybeard or _G.AutoKeyRen or _G.Dungeonh then
				shouldTween = true;
				if not plr.Character.HumanoidRootPart:FindFirstChild("BodyClip") then
					local I = Instance.new("BodyVelocity");
					I.Name = "BodyClip";
					I.Parent = plr.Character.HumanoidRootPart;
					I.MaxForce = Vector3.new(100000, 100000, 100000);
					I.Velocity = Vector3.new(0, 0, 0);
				end;
				for I, e in pairs(plr.Character:GetDescendants()) do
					if e:IsA("BasePart") then
						e.CanCollide = false;
					end;
				end;
			else
				shouldTween = false;
				if plr.Character.HumanoidRootPart:FindFirstChild("BodyClip") then
					(plr.Character.HumanoidRootPart:FindFirstChild("BodyClip")):Destroy();
				end;
				if plr.Character:FindFirstChild("highlight") then
					(plr.Character:FindFirstChild("highlight")):Destroy();
				end;
			end;
		end);
	end;
end);
	local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/ohmay5/Main/refs/heads/main/xRedzLib.lua"))():MakeWindow({
    Title = "BaCoNhǎo | Hub",
    SubTitle = "Blox Fruit",
    SaveFolder = "BaCoNhǎo.json"
})
-- Criar ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ControlGUI"
screenGui.Parent = game.CoreGui

-- Criar ImageButton
local imageButton = Instance.new("ImageButton")
imageButton.Size = UDim2.new(0, 50, 0, 50)
imageButton.Position = UDim2.new(0.15, 0, 0.15, 0)
imageButton.Image = "rbxassetid://114476175638281"
imageButton.BackgroundTransparency = 1
imageButton.Parent = screenGui

-- Deixar o botão completamente redondo
local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(1, 0)
uiCorner.Parent = imageButton

-- Variáveis para arrastar
local dragging = false
local dragInput
local dragStart
local startPos

-- Função para atualizar posição
local function update(input)
    local delta = input.Position - dragStart
    imageButton.Position = UDim2.new(
        startPos.X.Scale,
        startPos.X.Offset + delta.X,
        startPos.Y.Scale,
        startPos.Y.Offset + delta.Y
    )
end

-- Detectar início do arrasto
imageButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then

        dragging = true
        dragStart = input.Position
        startPos = imageButton.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

-- Detectar movimento do mouse
imageButton.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then

        dragInput = input
    end
end)

-- Atualizar posição durante arrasto
game:GetService("UserInputService").InputChanged:Connect(function(input)
    if dragging and input == dragInput then
        update(input)
    end
end)

-- Abrir/Fechar GUI (Minimize)
local isOpen = true

imageButton.MouseButton1Click:Connect(function()
    isOpen = not isOpen

    if isOpen then
        Library:Minimize(false)
    else
        Library:Minimize(true)
    end
end)

local Status = Library:MakeTab({
    Title = "Info & Server",
    Icon = "rbxassetid://7040410130"
})

local Farm = Library:MakeTab({
    Title = "Tab Farming",
    Icon = "rbxassetid://127561653320876"
})
local Setting = Library:MakeTab({
    Title = "Setting & UI",
    Icon = "rbxassetid://7734053495"
})
Status:AddDiscordInvite({
    Name = "Bacon Hub",
    Description = "",
    Logo = "rbxassetid://114476175638281",
    Invite = ""
})
Farm:AddDropdown({
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
                if e:IsA("Tool") and e.ToolTip == _G.ChooseWP then
                    _G.SelectWeapon = e.Name
                    break
                end
            end
        end)
    end
end)
Farm:AddSection({"Farm Ngục tối "})
Farm:AddToggle({
    Name = "Tự Động Farm Dungeon + Qua Cửa",
    Flag = "Dungoenvp",
    Description = "",
    Default = false,
    Callback = function(Value)
        _G.Dungeonh = Value
    end
})

task.spawn(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/ohmay5/Main/refs/heads/main/DUngeonFarm.lua"))()
end)
AllCards={"Lifesteal","All Cooldowns","HYPER!","Fruit M1 Speed","Armor","Sniper","Overflow","Gun","Melee","Fruit","Defense","Fortress"}

_G.Select_Cards=_G.Select_Cards or {Melee=true}

Farm:AddDropdown({
	Name = "Chọn Thẻ",
	Options=AllCards,
	MultiSelect=true,
	Flag="SelectCards",
	Callback=function(v)
		_G.Select_Cards=v
		if ResetPick then ResetPick() end
	end
})

Farm:AddToggle({
	Name = "Tự Động Chọn Thẻ Dungeon",
	Flag = "Pickcard",
	Description = "",
	Default = true,
	Callback = function(Value)
		_G.Pickcard = Value
		if not Value then ResetPick() end
	end
})

_G.MobHeight = _G.SaveData["MobHeight_Save"] or 20

Setting:AddSlider({
    Title = "Farm Height",
    Description = "Độ cao farm quái",
    Default = _G.SaveData["MobHeight_Save"] or 20,
    Min = 0,
    Max = 100,
    Rounding = 1,
    Callback = function(Value)
        _G.MobHeight = Value
        _G.SaveData["MobHeight_Save"] = Value
        SaveSettings()
    end
})

Setting:AddSlider({
    Title = "Tween Speed",
    Description = "Điều chỉnh tốc độ tween",
    Default = _G.SaveData["TweenSpeed_Save"] or 255, -- Lấy giá trị đã lưu, nếu chưa có thì mặc định là 255
    Min = 50,      -- Giá trị nhỏ nhất
    Max = 500,    -- Giá trị lớn nhất
    Rounding = 0,  -- Số chữ số thập phân (0 là số nguyên)
    Callback = function(I)
        getgenv().TweenSpeedFar = I
        _G.SaveData["TweenSpeed_Save"] = I
        SaveSettings()
    end
});
loadstring(game:HttpGet("https://raw.githubusercontent.com/ohmay5/Main/refs/heads/main/attachgun.txt"))()
_G.Settings = _G.Settings or {}
_G.Settings.FastAttack = true

-- Tốc độ FastAttack
local AttackDelay = 0.2

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