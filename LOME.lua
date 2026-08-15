do
  ply = game.Players
  plr = ply.LocalPlayer
  Root = plr.Character.HumanoidRootPart
  replicated = game:GetService("ReplicatedStorage")
  Lv = game.Players.LocalPlayer.Data.Level.Value
  TeleportService = game:GetService("TeleportService")
  TW = game:GetService("TweenService")
  Lighting = game:GetService("Lighting")
  Enemies = workspace.Enemies
  vim1 = game:GetService("VirtualInputManager")
  vim2 = game:GetService("VirtualUser")
  TeamSelf = plr.Team
  RunSer = game:GetService("RunService")
  Stats = game:GetService("Stats")
  Energy = plr.Character.Energy.Value
  BringConnections = {}
  BossList = {}
  MaterialList = {}
  NPCList = {}
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

repeat local start = plr.PlayerGui:WaitForChild("Main"):WaitForChild("Loading") and game:IsLoaded() wait() until start
World1 = game.PlaceId == 2753915549 or game.PlaceId == 85211729168715
World2 = game.PlaceId == 4442272183 or game.PlaceId == 79091703265657
World3 = game.PlaceId == 7449423635 or game.PlaceId == 100117331123089
Sea = World1 or World2 or World3
Marines = function() replicated.Remotes.CommF_:InvokeServer("SetTeam","Marines") end
Pirates = function() replicated.Remotes.CommF_:InvokeServer("SetTeam","Pirates") end


Remotes = {
    RFSubmarineWorkerSpeak = replicated.Modules.Net["RF/SubmarineWorkerSpeak"],
    RFJobsRemoteFunction = replicated.Modules.Net["RF/JobsRemoteFunction"], 
    RFCraft = replicated:WaitForChild("Modules"):WaitForChild("Net"):WaitForChild("RF/Craft")
}
EquipWeapon = function(text)
  if not text then return end
  if plr.Backpack:FindFirstChild(text) then
	plr.Character.Humanoid:EquipTool(plr.Backpack:FindFirstChild(text))
  end
end
weaponSc = function(weapon)
  for __in, v in pairs(plr.Backpack:GetChildren()) do
    if v:IsA("Tool") then
      if v.ToolTip == weapon then EquipWeapon(v.Name) end
    end
  end
end
hookfunction(require(game:GetService("ReplicatedStorage").Effect.Container.Death),function() end)
hookfunction(require(game:GetService("ReplicatedStorage"):WaitForChild("GuideModule")).ChangeDisplayedNPC,function()end)
hookfunction(error, function()end)
hookfunction(warn, function()end)
Rock = workspace:FindFirstChild("Rocks")
if Rock then Rock:Destroy()end
gay = (function()
  local lightingLayers = nil
  local lighting = game:GetService("Lighting")
  lightingLayers = lighting:FindFirstChild("LightingLayers")

  if lightingLayers then
    local darkFog = lightingLayers:FindFirstChild("DarkFog")
    if darkFog then darkFog:Destroy() end
  end
end)()       -- ← thêm dòng này
-- deg
Attack = {}
Attack.__index = Attack

Attack.Alive = function(model) if not model or not model.Parent then return end local Humanoid = model:FindFirstChild("Humanoid") return Humanoid and Humanoid.Health > 0 end

Attack.Pos = function(model, dist)
  return (Root.Position - model.Position).Magnitude <= dist
end

Attack.Dist = function(model,dist) return (Root.Position - model:FindFirstChild("HumanoidRootPart").Position).Magnitude <= dist end

Attack.DistH = function(model,dist) return (Root.Position - model:FindFirstChild("HumanoidRootPart").Position).Magnitude > dist end


Attack.Kill = function(model,Succes)
  if model and model.Parent and Succes then
  if not model:GetAttribute("Locked") then model:SetAttribute("Locked",model.HumanoidRootPart.CFrame) end
  PosMon = model:GetAttribute("Locked").Position
  BringEnemy()
  EquipWeapon(_G.SelectWeapon)
  local Equipped = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool")
  local ToolTip = Equipped.ToolTip
  if ToolTip == "Blox Fruit" then _tp(model.HumanoidRootPart.CFrame * CFrame.new(0,10,0) * CFrame.Angles(0,math.rad(90),0)) else _tp(model.HumanoidRootPart.CFrame * CFrame.new(0,30,0) * CFrame.Angles(0,math.rad(180),0))end
  if RandomCFrame then wait(.5)_tp(model.HumanoidRootPart.CFrame * CFrame.new(0, 30, 25)) wait(.5)_tp(model.HumanoidRootPart.CFrame * CFrame.new(25, 30, 0)) wait(.5)_tp(model.HumanoidRootPart.CFrame * CFrame.new(-25, 30 ,0)) wait(.5)_tp(model.HumanoidRootPart.CFrame * CFrame.new(0, 30, 25)) wait(.5)_tp(model.HumanoidRootPart.CFrame * CFrame.new(-25, 30, 0))end
  end
end


Attack.dungeon = function(model,Succes)
  if model and model.Parent and Succes then
  if not model:GetAttribute("Locked") then model:SetAttribute("Locked",model.HumanoidRootPart.CFrame) end
  PosMon = model:GetAttribute("Locked").Position
  EquipWeapon(_G.SelectWeapon)
  local Equipped = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool")
  local ToolTip = Equipped.ToolTip
  if ToolTip == "Blox Fruit" then _tp(model.HumanoidRootPart.CFrame * CFrame.new(0,10,0) * CFrame.Angles(0,math.rad(90),0)) else _tp(model.HumanoidRootPart.CFrame * CFrame.new(0,30,0) * CFrame.Angles(0,math.rad(180),0))end
  if RandomCFrame then wait(.5)_tp(model.HumanoidRootPart.CFrame * CFrame.new(0, 30, 25)) wait(.5)_tp(model.HumanoidRootPart.CFrame * CFrame.new(25, 30, 0)) wait(.5)_tp(model.HumanoidRootPart.CFrame * CFrame.new(-25, 30 ,0)) wait(.5)_tp(model.HumanoidRootPart.CFrame * CFrame.new(0, 30, 25)) wait(.5)_tp(model.HumanoidRootPart.CFrame * CFrame.new(-25, 30, 0))end
  end
end

GetConnectionEnemies = function(a)
  for i,v in pairs(replicated:GetChildren()) do
    if v:IsA("Model") and  ((typeof(a) == "table" and table.find(a, v.Name)) or v.Name == a) and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
      return v
    end
  end
  for i,v in next,game.Workspace.Enemies:GetChildren() do
    if v:IsA("Model") and ((typeof(a) == "table" and table.find(a, v.Name)) or v.Name == a)  and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
      return v
    end
  end
end
LowCpu = function()
  local decalsyeeted = true
  local g = game
  local w = g.Workspace
  local l = g.Lighting
  local t = w.Terrain
  t.WaterWaveSize = 0
  t.WaterWaveSpeed = 0
  t.WaterReflectance = 0
  t.WaterTransparency = 0
  l.GlobalShadows = false
  l.FogEnd = 9e9
  l.Brightness = 0
  settings().Rendering.QualityLevel = "Level01"
  for i, v in pairs(g:GetDescendants()) do
    if v:IsA("Part") or v:IsA("Union") or v:IsA("CornerWedgePart") or v:IsA("TrussPart") then
      v.Material = "Plastic"
      v.Reflectance = 0
    elseif v:IsA("Decal") or v:IsA("Texture") and decalsyeeted then
      v.Transparency = 1
    elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
      v.Lifetime = NumberRange.new(0)
    elseif v:IsA("Explosion") then
      v.BlastPressure = 1
      v.BlastRadius = 1
    elseif v:IsA("Fire") or v:IsA("SpotLight") or v:IsA("Smoke") or v:IsA("Sparkles") then
      v.Enabled = false
    elseif v:IsA("MeshPart") then
      v.Material = "Plastic"
      v.Reflectance = 0
      v.TextureID = 10385902758728957
    end
  end
  for i, e in pairs(l:GetChildren()) do
    if e:IsA("BlurEffect") or e:IsA("SunRaysEffect") or e:IsA("ColorCorrectionEffect") or e:IsA("BloomEffect") or e:IsA("DepthOfFieldEffect") then
      e.Enabled = false
    end
  end
end


getgenv().TweenSpeedFar  = 300
getgenv().TweenSpeedNear = 400

_tp = function(I)
    local e = plr.Character
    if not e or not e:FindFirstChild("HumanoidRootPart") then return end

    local HRP = e.HumanoidRootPart

    shouldTween = true
    getgenv().OnFarm = false

    if HRP.Anchored then
        HRP.Anchored = false
        task.wait()
    end

    local dist = (I.Position - HRP.Position).Magnitude
    if dist < 1 then
        getgenv().OnFarm = true
        return
    end

    local speed = dist <= 15
        and (getgenv().TweenSpeedNear or 400)
        or  (getgenv().TweenSpeedFar  or 300)

    local info  = TweenInfo.new(dist / speed, Enum.EasingStyle.Linear)
    local tween = game:GetService("TweenService"):Create(HRP, info, { CFrame = I })

    tween:Play()

    task.spawn(function()
        while tween.PlaybackState == Enum.PlaybackState.Playing do
            if not shouldTween then
                tween:Cancel()
                break
            end
            task.wait(0.1)
        end
        getgenv().OnFarm = true
    end)
end

notween = function(I)
    plr.Character.HumanoidRootPart.CFrame = I
end

TeleportToTarget = function(I)
    _tp(I)
end


task.spawn(function()
  while task.wait(0.05) do
    pcall(function()
      if _G.SailBoat_Hydra or _G.WardenBoss or _G.AutoFactory or _G.HighestMirage or _G.HCM or _G.PGB or _G.Leviathan1 or _G.UPGDrago or _G.Complete_Trials or _G.TpDrago_Prehis or _G.BuyDrago or _G.AutoFireFlowers or _G.DT_Uzoth or _G.AutoBerry or _G.Prehis_Find or _G.Prehis_Skills or _G.Prehis_DB or _G.Prehis_DE or _G.FarmBlazeEM or _G.Dojoo or _G.CollectPresent or _G.AutoLawKak or _G.TpLab or _G.AutoPhoenixF or _G.AutoFarmChest or _G.AutoHytHallow or _G.LongsWord or _G.BlackSpikey or _G.AutoHolyTorch or _G.TrainDrago  or _G.AutoSaber or _G.FarmMastery_Dev or _G.CitizenQuest or _G.AutoEctoplasm or _G.KeysRen or _G.Auto_Rainbow_Haki or _G.obsFarm or _G.AutoBigmom or _G.Doughv2 or _G.AuraBoss or _G.Raiding or _G.Auto_Cavender or _G.TpPly or _G.Bartilo_Quest or _G.Level or _G.Dungeonh or _G.FarmEliteHunt or _G.AutoZou or _G.AutoFarm_Bone or getgenv().AutoMaterial or _G.CraftVM or _G.FrozenTP or _G.TPDoor or _G.AcientOne or _G.AutoFarmNear or _G.AutoRaidCastle or _G.DarkBladev3 or _G.AutoFarmRaid or _G.Auto_Cake_Prince or _G.Addealer or _G.TPNpc or _G.TwinHook or _G.FindMirage or _G.FarmChestM or _G.Shark or _G.TerrorShark or _G.Piranha or _G.MobCrew or _G.SeaBeast1 or _G.FishBoat or _G.AutoPole or _G.AutoPoleV2 or _G.Auto_SuperHuman or _G.AutoDeathStep or _G.Auto_SharkMan_Karate or _G.Auto_Electric_Claw or _G.AutoDragonTalon or _G.Auto_Def_DarkCoat or _G.Auto_God_Human or _G.Auto_Tushita or _G.AutoMatSoul or _G.AutoKenVTWO or _G.AutoSerpentBow or _G.AutoFMon or _G.Auto_Soul_Guitar or _G.TPGEAR or _G.AutoSaw or _G.AutoTridentW2 or _G.Auto_StartRaid or _G.AutoEvoRace or _G.AutoGetQuestBounty or _G.MarinesCoat or _G.TravelDres or _G.Defeating or _G.DummyMan or _G.Auto_Yama or _G.Auto_SwanGG or _G.SwanCoat or _G.AutoEcBoss or _G.Auto_Mink or _G.Auto_Human or _G.Auto_Skypiea or _G.Auto_Fish or _G.CDK_TS or _G.CDK_YM or _G.CDK or _G.AutoFarmGodChalice or _G.AutoFistDarkness or _G.AutoMiror or _G.Teleport or _G.AutoKilo or _G.AutoGetUsoap or _G.Praying or _G.TryLucky or _G.AutoColShad or _G.AutoUnHaki or _G.Auto_DonAcces or _G.AutoRipIngay or _G.DragoV3 or _G.DragoV1 or _G.SailBoats or NextIs or _G.FarmGodChalice or _G.IceBossRen or senth or senth2 or _G.Lvthan or _G.beasthunter or _G.DangerLV or _G.Relic123 or _G.tweenKitsune or _G.Collect_Ember or _G.AutofindKitIs or _G.snaguine or _G.TwFruits or _G.tweenKitShrine or _G.Tp_LgS or _G.Tp_MasterA or _G.tweenShrine or _G.FarmMastery_G or _G.FarmMastery_S or getgenv().AutoFarmBoss or getgenv().AutoFarmAllBoss or _G.AutoFishSlap or getgenv().FarmTyrant or getgenv().FarmPhaBinh or getgenv().UpgradeRaceV2 or _G.AutoSpawnCP or _G.AutoBerryH or _G.AutoChestBP or _G.FarmEliteHop or _G.AutoHop_Dough or _G.AutoDoughKing or _G.AutoChipFruit or _G.AutoChipBeli or _G.StartEvent or _G.AutoTrickOrTreat or _G.FarmUnboundWerewolf then
        shouldTween = true
        if not plr.Character.HumanoidRootPart:FindFirstChild("BodyClip") then
          local Noclip = Instance.new("BodyVelocity")
          Noclip.Name = "BodyClip"
          Noclip.Parent = plr.Character.HumanoidRootPart
          Noclip.MaxForce = Vector3.new(100000,100000,100000)
          Noclip.Velocity = Vector3.new(0,0,0)
        end        
      if not plr.Character:FindFirstChild("highlight") then
    local Test = Instance.new("Highlight")
    Test.Name = "highlight"
    Test.Enabled = true
    Test.FillColor = Color3.fromRGB(255,165,0)
    Test.OutlineColor = Color3.fromRGB(255,255,255)
    Test.FillTransparency = 0.5
    Test.OutlineTransparency = 0.2
    Test.Parent = plr.Character
end
        for _, no in pairs(plr.Character:GetDescendants()) do if no:IsA("BasePart") then no.CanCollide = false end end
      else
        shouldTween = false
        if plr.Character.HumanoidRootPart:FindFirstChild("BodyClip") then plr.Character.HumanoidRootPart:FindFirstChild("BodyClip"):Destroy() end
        if plr.Character:FindFirstChild('highlight') then plr.Character:FindFirstChild('highlight'):Destroy() end	        
      end
    end)
  end
end)



redzlib = nil
pcall(function() redzlib = loadstring(game:HttpGet("https://pastefy.app/MAbSfkcD/raw"))() end)
Players=game:GetService("Players")
lp=Players.LocalPlayer
lastPick=0

local function ToSet(v)
	if type(v)~="table" then return {} end
	if next(v)==nil then return {} end
	if type(next(v))=="number" then
		local s={}
		for _,n in ipairs(v) do
			if type(n)=="string" and n~="" then s[n]=true end
		end
		return s
	end
	return v
end

local function IterCards(cb)
	local pg=lp:FindFirstChildOfClass("PlayerGui")
	if not pg then return end
	for _,g in next,pg:GetChildren() do
		local t=g.Name=="ScreenGui" and g:FindFirstChild("1") and g["1"]:FindFirstChild("2")
		if t then
			local ok,n=pcall(function() return t.DisplayName.Text end)
			if ok and n~="" then cb(t,n) end
		end
	end
end

function ResetPick()
	lastPick=0
end

local function PickSelectedCards()
	local set=ToSet(_G.Select_Cards)
	local has=next(set)~=nil
	if not has then return end

	local now=os.clock()
	if now-lastPick<0.35 then return end

	local picked=false
	IterCards(function(t,n)
		if not picked and set[n] then
			picked=true
			lastPick=now
			pcall(function()
				if firesignal and t.Activated then firesignal(t.Activated) else t:Activate() end
			end)
		end
	end)
end

task.spawn(function()
	while task.wait(0.1) do
		if _G.Pickcard then
			xpcall(PickSelectedCards,function() task.wait(1) end)
		end
	end
end)

Window = redzlib:MakeWindow({
  Title = "BaCon Hub : Blox Fruits",
  SubTitle = "by_orgvip³⁶",
  SaveFolder = "OrangeV5.lua"
})

MinimizeButton = Window:AddMinimizeButton({
    Button = { 
        Image = "rbxassetid://114476175638281", 
        BackgroundTransparency = 0,
        Size = UDim2.new(0, 55, 0, 55),
        BackgroundColor3 = Color3.fromRGB(30, 30, 30),
        BorderMode = Enum.BorderMode.Inset,
        BorderSizePixel = 2,
        BorderColor3 = Color3.fromRGB(255, 140, 0) -- Màu cam cố định
    },
    Corner = { 
        CornerRadius = UDim.new(1, 0) 
    },
})
-- Bỏ toàn bộ task.spawn hiệu ứng cầu vồng

Tabs = {
    Info = Window:MakeTab({ Title = "Trang Chủ", Icon = "home" }),
    Main = Window:MakeTab({ Title = "Tab General", Icon = "axe" }),
    Settings = Window:MakeTab({ Title = "Tab Setting", Icon = "rbxassetid://7734053495" }),

}

Tabs.Info:AddSection("Thông Tin Chính")
Tabs.Info:AddDiscordInvite({
    Name = " BaCon Hub",
    Description = "",
    Logo = "rbxassetid://114476175638281",
    Invite = ""
})

Time = Tabs.Info:AddParagraph({
    Title = "Múi Giờ",
    Content = ""
})
function UpdateOS()
    local date = os.date("*t")
    local hour = (date.hour) % 24
    local ampm = hour < 12 and "Sáng" or "Tối"
    local timezone = string.format("%02i:%02i:%02i %s", ((hour - 1) % 12) + 1, date.min, date.sec, ampm)
    local datetime = string.format("%02d/%02d/%04d", date.day, date.month, date.year)    
    local LocalizationService = game:GetService("LocalizationService")
    local Players = game:GetService("Players")
    local player = Players.LocalPlayer
    local name = player.Name
    local result, code    
    if not getgenv().countryRegionCode then
        result, code = pcall(function()
            return LocalizationService:GetCountryRegionForPlayerAsync(player)
        end)
        if result then
            getgenv().countryRegionCode = code
        else
            getgenv().countryRegionCode = "Unknown"
        end
    else
        code = getgenv().countryRegionCode
    end
    Time:SetDesc(datetime.." - "..timezone.." [ " .. code .. " ]")
end
task.spawn(function()
    while true do
        UpdateOS()
        wait(1)
    end
end)
Timmessss = Tabs.Info:AddParagraph({
    Title = "Thời Gian",
    Content = ""
})
function UpdateTime()
    local GameTime = math.floor(workspace.DistributedGameTime + 0.5)
    local Hour = math.floor(GameTime / (60^2)) % 24
    local Minute = math.floor(GameTime / (60^1)) % 60
    local Second = math.floor(GameTime / (60^0)) % 60
    Timmessss:SetDesc(Hour.." Hour (h) "..Minute.." Minute (m) "..Second.." Second (s) ")
end
task.spawn(function()
    while true do
        UpdateTime()
        wait(1)
    end
end)

WeaponDropdown = Tabs.Main:AddDropdown({
    Name = "Chọn Vũ Khí",
    Flag = "WeaponDropdown",
    Options = {"Melee","Sword","Blox Fruit","Gun"},
    Default = "Melee",
    Callback = function(Value)
    _G.ChooseWP = Value
end})


task.spawn(function()
    while task.wait(0.5) do
        pcall(function()
            if _G.ChooseWP == "Melee" then
                for _,v in pairs(plr.Backpack:GetChildren()) do
                    if v.ToolTip == "Melee" then
                        _G.SelectWeapon = v.Name
                    end
                end
            elseif _G.ChooseWP == "Sword" then
                for _,v in pairs(plr.Backpack:GetChildren()) do
                    if v.ToolTip == "Sword" then
                        _G.SelectWeapon = v.Name
                    end
                end
            elseif _G.ChooseWP == "Gun" then
                for _,v in pairs(plr.Backpack:GetChildren()) do
                    if v.ToolTip == "Gun" then
                        _G.SelectWeapon = v.Name
                    end
                end
            elseif _G.ChooseWP == "Blox Fruit" then
                for _,v in pairs(plr.Backpack:GetChildren()) do
                    if v.ToolTip == "Blox Fruit" then
                        _G.SelectWeapon = v.Name
                    end
                end
            end
        end)
    end
end)

AttackDropdown = Tabs.Main:AddDropdown({
    Name = "Chọn Tốc Độ Đánh",
    Flag = "AttackDropdown",
    Options = {"Normal Attack","Fast Attack","Super Fast Attack","Orange Attack"},
    Default = "Fast Attack",
    Callback = function(Value)
    _G.FastAttackGravity_Mode = Value
end})


DelayConfig = {
    ["Normal Attack"] = 0.25,
    ["Fast Attack"] = 0.15,
    ["Super Fast Attack"] = 0.05,
    ["Orange Attack"] = 0.1
}

task.spawn(function()
    while task.wait(0.1) do
        pcall(function()
            if _G.FastAttackGravity_Mode and DelayConfig[_G.FastAttackGravity_Mode] then
                _G.Fast_Delay = DelayConfig[_G.FastAttackGravity_Mode]
            end
        end)
    end
end)
Tabs.Settings:AddSection({"Settings / Configure"})

Tabs.Settings:AddButton({
    Name = "Xoá Hiệu Ứng [ Siêu Mượt Mobile ]",
    Description = "Tắt bóng đổ, ánh sáng và các hiệu ứng hạt",
    Callback = function()
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 9e9
        pcall(function() Lighting.ShadowMapLightingInfo = false end)
        
        task.spawn(function()
            local descendants = Workspace:GetDescendants()
            for i, v in ipairs(descendants) do
                if v:IsA("BasePart") then
                    v.Material = Enum.Material.SmoothPlastic
                    v.CastShadow = false
                elseif v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Smoke") or v:IsA("Fire") or v:IsA("Sparkles") then
                    v.Enabled = false
                elseif v:IsA("Decal") or v:IsA("Texture") then
                    v:Destroy()
                end
                if i % 500 == 0 then task.wait() end 
            end
        end)
    end
})
Tabs.Main:AddSection({"Dungeon Event"})
Dungoenvp = Tabs.Main:AddToggle({
    Name = "Tự Động Farm Dungeon + Qua Cửa",
    Flag = "Dungoenvp",
    Description = "",
    Default = false,
    Callback = function(Value)
        _G.Dungeonh = Value
    end
})

task.spawn(function()
    loadstring(game:HttpGet("https://pastefy.app/10LRDk2J/raw"))()
end)
AllCards={"Lifesteal","All Cooldowns","HYPER!","Fruit M1 Speed","Armor","Sniper","Overflow","Gun","Melee","Fruit","Defense","Fortress"}

_G.Select_Cards=_G.Select_Cards or {Melee=true}

Card=Tabs.Main:AddDropdown({
	Name = "Chọn Thẻ",
	Options=AllCards,
	MultiSelect=true,
	Flag="SelectCards",
	Callback=function(v)
		_G.Select_Cards=v
		if ResetPick then ResetPick() end
	end
})

Pickcard = Tabs.Main:AddToggle({
	Name = "Tự Động Chọn Thẻ Dungeon",
	Flag = "Pickcard",
	Description = "",
	Default = true,
	Callback = function(Value)
		_G.Pickcard = Value
		if not Value then ResetPick() end
	end
})



Players = game:GetService("Players")
lp = Players.LocalPlayer

-- Giá trị mặc định
getgenv().WalkSpeedValue = 30
getgenv().JumpValue = 50

-- ==============================
-- 1. HÀM ÉP BUỘC HUMANOID
-- ==============================
local function ApplyHumanoid(char)
    local hum = char:WaitForChild("Humanoid", 5)
    if not hum then return end

    local isApplying = false -- ✅ Flag chống loop conflict

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

    -- Gán giá trị ban đầu
    SetJump()
    SetSpeed()

    -- ✅ FIX CHÍNH: Bắt đúng state để reapply
    hum.StateChanged:Connect(function(_, newState)
        if newState == Enum.HumanoidStateType.Landed then
            task.wait(0.05) -- Chờ physics ổn định
            SetJump()
        elseif newState == Enum.HumanoidStateType.Jumping then
            -- Giữ JumpPower trong lúc nhảy
            SetJump()
        elseif newState == Enum.HumanoidStateType.Freefall then
            SetJump()
        elseif newState == Enum.HumanoidStateType.Running
            or newState == Enum.HumanoidStateType.RunningNoPhysics then
            SetJump()
        end
    end)

    -- Chống game tắt UseJumpPower
    hum:GetPropertyChangedSignal("UseJumpPower"):Connect(function()
        if not hum.UseJumpPower then
            SetJump()
        end
    end)

    -- Chống game đổi WalkSpeed
    hum:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
        if hum.WalkSpeed ~= getgenv().WalkSpeedValue then
            SetSpeed()
        end
    end)

    -- ✅ Bỏ GetPropertyChangedSignal("JumpPower") vì nó gây conflict loop
    -- Thay bằng loop ngắn riêng bên dưới
end

-- ==============================
-- 2. KHI NHÂN VẬT XUẤT HIỆN
-- ==============================
lp.CharacterAdded:Connect(function(char)
    ApplyHumanoid(char)
end)

if lp.Character then
    ApplyHumanoid(lp.Character)
end

-- ==============================
-- 3. LOOP DỰ PHÒNG
-- ==============================
task.spawn(function()
    while task.wait(0.2) do
        local char = lp.Character
        if char then
            local hum = char:FindFirstChild("Humanoid")
            if hum then
                -- Chỉ fix khi đang đứng/chạy, KHÔNG fix khi đang nhảy
                local state = hum:GetState()
                local isMidAir = (
                    state == Enum.HumanoidStateType.Jumping or
                    state == Enum.HumanoidStateType.Freefall
                )

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

-- ==============================
-- 4. SLIDER UI
-- ==============================

-- Slider Tăng Tốc Chạy
Tabs.Main:AddSlider({
    Name = "Tăng Tốc Chạy",
    Min = 100,
    Max = 300,
    Default = getgenv().WalkSpeedValue,
    Callback = function(Value)
        getgenv().WalkSpeedValue = Value
        local hum = lp.Character and lp.Character:FindFirstChild("Humanoid")
        if hum then
            hum.WalkSpeed = Value
        end
    end
})

-- Slider Tăng Sức Bật Nhảy
Tabs.Main:AddSlider({
    Name = "Tăng Sức Bật Nhảy",
    Min = 70,
    Max = 350,
    Default = getgenv().JumpValue,
    Description = "Chỉnh Tối Đa Từ 200-300 Là Ngon Nhất",
    Callback = function(Value)
        getgenv().JumpValue = Value
        local hum = lp.Character and lp.Character:FindFirstChild("Humanoid")
        if hum then
            hum.UseJumpPower = true
            hum.JumpPower = Value
        end
    end
})

-- ========== TOGGLE ==========
Tabs.Settings:AddToggle({
    Name = "M1 Fruits (Đánh Siêu Nhanh)",
    Default = true,
    Flag = "hieudz",
    Callback = function(v)
        _G.Nhi1 = v
    end
})

-- ========== MAIN SCRIPT ==========
task.spawn(function()
    local plr = game:GetService("Players").LocalPlayer
    local enemies = workspace:WaitForChild("Enemies")
    
    -- Delay giữa các lần quét (giảm để tăng tốc)
    local scanDelay = 0.01  -- 1/100 giây
    
    while task.wait(scanDelay) do
        if not _G.Nhi1 then continue end
        
        -- Đợi nhân vật xuất hiện
        local char = plr.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then
            continue
        end
        local root = char.HumanoidRootPart
        
        -- Tìm Remote LeftClickRemote trong Tool đang cầm hoặc Backpack
        local remote = nil
        
        -- Kiểm tra tool trong tay
        for _, v in pairs(char:GetChildren()) do
            if v:IsA("Tool") then
                remote = v:FindFirstChild("LeftClickRemote", true)
                if remote then break end
            end
        end
        
        -- Nếu chưa có, tìm trong Backpack
        if not remote then
            local backpack = plr:WaitForChild("Backpack")
            for _, v in pairs(backpack:GetChildren()) do
                if v:IsA("Tool") then
                    remote = v:FindFirstChild("LeftClickRemote", true)
                    if remote then break end
                end
            end
        end
        
        if not remote then continue end
        
        -- Tìm enemy gần nhất
        local closestDist = math.huge
        local closestTarget = nil
        
        for _, enemy in pairs(enemies:GetChildren()) do
            local hum = enemy:FindFirstChildOfClass("Humanoid")
            local hrp = enemy:FindFirstChild("HumanoidRootPart")
            if hum and hrp and hum.Health > 0 then
                local dist = (hrp.Position - root.Position).Magnitude
                if dist < closestDist then
                    closestDist = dist
                    closestTarget = hrp
                end
            end
        end
        
        if closestTarget then
            -- Tính hướng từ người chơi đến enemy
            local direction = (closestTarget.Position - root.Position)
            if direction.Magnitude == 0 then
                direction = Vector3.zero
            else
                direction = direction.Unit
            end
            
            -- Gửi 3 đòn liên tiếp trong cùng một lần quét (tăng tốc cực mạnh)
            -- Tham số cuối FALSE để tắt knockback (không bị văng)
            for i = 1, 3 do
                remote:FireServer(direction, 1, false)
                task.wait(0)  -- nhường nhịn xử lý, tránh quá tải
            end
        end
    end
end)

BusuAura = Tabs.Settings:AddToggle({
Name = "Tự Động Bật Haki", 
Flag = "BusuAura",
Description = "", 
Default = true,
Callback = function(Value)
  Boud = Value
end})
task.spawn(function()
  while task.wait(Sec) do
    pcall(function()
      if Boud then
      local _HasBuso = {"HasBuso","Buso"}
  	  if not plr.Character:FindFirstChild(_HasBuso[1]) then replicated.Remotes.CommF_:InvokeServer(_HasBuso[2]) end
      end
    end)
  end
end)
RaceV3Aura = Tabs.Settings:AddToggle({
Name = "Tự Động Bật Tộc V3", 
Flag = "RaceV3Aura",
Description = "", 
Default = false,
Callback = function(Value)
  _G.RaceClickAutov3 = Value
end})
task.spawn(function()
  while task.wait(0.2) do
    pcall(function()
      if _G.RaceClickAutov3 then
        repeat
          replicated.Remotes.CommE:FireServer("ActivateAbility") 
          wait(30)
        until not _G.RaceClickAutov3   
      end 
    end)
  end
end)
RaceV4Aura = Tabs.Settings:AddToggle({
Name = "Tự Động Bật Tộc V4", 
Flag = "RaceV4Aura",
Description = "", 
Default = false,
Callback = function(Value)
  _G.RaceClickAutov4 = Value
end})
task.spawn(function()
  while task.wait(0.2) do
    pcall(function()
      if _G.RaceClickAutov4 then
  	    if plr.Character:FindFirstChild("RaceEnergy") then
        if plr.Character:FindFirstChild("RaceEnergy").Value == 1 then Useskills("nil","Y") end
        end        
      end 
    end)
  end
end)

Tabs.Settings:AddButton({
Name = "Bật Chế Độ Nhanh", 
Description = "",
Callback = function()
  for _,zx in next, workspace:GetDescendants() do
  if table.find(Past, zx.ClassName) then  zx.Material = "Plastic" end
  end
end})
Tabs.Settings:AddButton({
Name = "Xoá Sương Mù", 
Description = "",
Callback = function()
  if Lighting:FindFirstChild("LightingLayers") then Lighting.LightingLayers:Destroy() end
  if Lighting:FindFirstChild("SeaTerrorCC") then Lighting.SeaTerrorCC:Destroy() end
  if Lighting:FindFirstChild("FantasySky") then Lighting.FantasySky:Destroy() end
end})

Tabs.Settings:AddSection({"Configure - God"})
briggt1 = Tabs.Settings:AddToggle({
Name = "Bật Max Tầm Nhìn", 
Flag = "briggt1",
Description = "", 
Default = false,
Callback = function(Value)
  bright = Value
  if Value == true then
    Lighting.Ambient = Color3.new(1, 1, 1)
    Lighting.ColorShift_Bottom = Color3.new(1, 1, 1)
    Lighting.ColorShift_Top = Color3.new(1, 1, 1)
  else
    Lighting.Ambient = Color3.new(0, 0, 0)
    Lighting.ColorShift_Bottom = Color3.new(0, 0, 0)
    Lighting.ColorShift_Top = Color3.new(0, 0, 0)
  end  
end
})
walkWater = Tabs.Settings:AddToggle({
Name = "Bật Đi Trên Nước", 
Flag = "walkWater",
Description = "", 
Default = true,
Callback = function(Value)
  _G.WalkWater_Part = Value
  if _G.WalkWater_Part then
    game:GetService("Workspace").Map["WaterBase-Plane"].Size = Vector3.new(1000, 112, 1000)
  else
    game:GetService("Workspace").Map["WaterBase-Plane"].Size = Vector3.new(1000, 80, 1000)
  end
end
})

Players = game:GetService("Players")
RS = game:GetService("ReplicatedStorage")
RunService = game:GetService("RunService")

plr = Players.LocalPlayer

v1 = next
v2 = {
    RS:WaitForChild("Util"),
    RS:WaitForChild("Common"),
    RS:WaitForChild("Remotes"),
    RS:WaitForChild("Assets"),
    RS:WaitForChild("FX"),
}

v3 = nil
u4 = nil -- RemoteEvent found
u5 = nil -- Id attribute

do
    while true do
        local folder
        v3, folder = v1(v2, v3)
        if v3 == nil then break end

        for _, obj in ipairs(folder:GetChildren()) do
            if obj:IsA("RemoteEvent") and obj:GetAttribute("Id") then
                u5 = obj:GetAttribute("Id")
                u4 = obj
            end
        end

        -- listen new children
        folder.ChildAdded:Connect(function(obj)
            if obj:IsA("RemoteEvent") and obj:GetAttribute("Id") then
                u5 = obj:GetAttribute("Id")
                u4 = obj
            end
        end)
    end
end

local function BuildHits(character, range)
    local hrp = character and character:FindFirstChild("HumanoidRootPart")
    if not hrp then return {} end

    local hits = {}
    for _, container in ipairs({workspace:FindFirstChild("Enemies"), workspace:FindFirstChild("Characters")}) do
        if container then
            for _, mob in ipairs(container:GetChildren()) do
                if mob ~= character then
                    local mhrp = mob:FindFirstChild("HumanoidRootPart")
                    local hum = mob:FindFirstChildOfClass("Humanoid") or mob:FindFirstChild("Humanoid")
                    if mhrp and hum and hum.Health > 0 then
                        if (mhrp.Position - hrp.Position).Magnitude <= range then
                            for _, part in ipairs(mob:GetChildren()) do
                                if part:IsA("BasePart") then
                                    if (mhrp.Position - hrp.Position).Magnitude <= range then
                                        hits[#hits+1] = {mob, part}
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    return hits
end


do
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local Workspace = game:GetService("Workspace")

    local Player = Players.LocalPlayer
    local Net = ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Net")
    local RegisterAttack = Net:WaitForChild("RE/RegisterAttack")
    local RegisterHit = Net:WaitForChild("RE/RegisterHit")

    local ATTACK_RANGE = 65
    local ATTACK_COOLDOWN = 0.2
    local SCAN_INTERVAL = 0.25

    local enemyCache = {}
    local lastAttackTime = 0
    local lastScanTime = 0

    local function UpdateEnemyCache()
        local character = Player.Character
        if not character then return end
        local rootPart = character:FindFirstChild("HumanoidRootPart")
        if not rootPart then return end

        local newCache = {}
        local enemies = Workspace:FindFirstChild("Enemies")
        if not enemies then return end

        for _, enemy in pairs(enemies:GetChildren()) do
            local hrp = enemy:FindFirstChild("HumanoidRootPart")
            local hum = enemy:FindFirstChild("Humanoid")
            if hrp and hum and hum.Health > 0 then
                if (hrp.Position - rootPart.Position).Magnitude <= ATTACK_RANGE then
                    table.insert(newCache, enemy)
                end
            end
        end
        enemyCache = newCache
    end

    local function SendHits()
        local now = tick()
        if now - lastAttackTime < ATTACK_COOLDOWN then return end

        if now - lastScanTime >= SCAN_INTERVAL then
            lastScanTime = now
            UpdateEnemyCache()
        end

        if #enemyCache == 0 then return end

        local args = { [1] = nil, [2] = {} }

        for idx, enemy in ipairs(enemyCache) do
            local hrp = enemy:FindFirstChild("HumanoidRootPart")
            if hrp then
                if not args[1] then
                    args[1] = enemy:FindFirstChild("Head") or hrp
                end
                args[2][idx] = { [1] = enemy, [2] = hrp }
            end
        end

        if not args[1] or #args[2] == 0 then return end

        pcall(function()
            RegisterAttack:FireServer(0)
            RegisterHit:FireServer(unpack(args))
        end)

        lastAttackTime = now
    end

    RunService.Heartbeat:Connect(function()
        SendHits()
    end)

    Player.CharacterAdded:Connect(function()
        enemyCache = {}
        lastScanTime = 0
        lastAttackTime = 0
    end)
end