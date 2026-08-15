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
-- Biến chọn mode AI (thay đổi bằng dropdown)
repeat local start = plr.PlayerGui:WaitForChild("Main"):WaitForChild("Loading") and game:IsLoaded() wait() until start
World1 = game.PlaceId == 2753915549 or game.PlaceId == 85211729168715
World2 = game.PlaceId == 4442272183 or game.PlaceId == 79091703265657
World3 = game.PlaceId == 7449423635 or game.PlaceId == 100117331123089
Sea = World1 or World2 or World3
Marines = function() replicated.Remotes.CommF_:InvokeServer("SetTeam","Marines") end
Pirates = function() replicated.Remotes.CommF_:InvokeServer("SetTeam","Pirates") end
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


-- [Giữ nguyên phần Metatable Hook bên dưới của bạn]
local MT = getrawmetatable(game)
local OldNameCall = MT.__namecall
local OldIndex = MT.__index
setreadonly(MT, false)

MT.__index = newcclosure(function(self, key)
    if getgenv().AimSkill and getgenv().AimPos and getgenv().AimTarget then
        if self == Mouse then
            if key == "Hit" or key == "hit" then
                return CFrame.new(getgenv().AimPos)
            elseif key == "Target" or key == "target" then
                return getgenv().AimTarget
            end
        end
    end
    return OldIndex(self, key)
end)

MT.__namecall = newcclosure(function(self, ...)
    local Method = getnamecallmethod()
    local Args = {...}
    if getgenv().AimSkill and getgenv().AimPos then
        if Method == "FireServer" or Method == "InvokeServer" then
            for i, v in pairs(Args) do
                if typeof(v) == "Vector3" then
                    Args[i] = getgenv().AimPos
                elseif typeof(v) == "CFrame" then
                    Args[i] = CFrame.new(getgenv().AimPos)
                end
            end
            return OldNameCall(self, unpack(Args))
        end
    end
    return OldNameCall(self, ...)
end)
setreadonly(MT, true)
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

block = Instance.new("Part", workspace)
block.Size = Vector3.new(1, 1, 1)
block.Name = "Rip_Indra"
block.Anchored = true
block.CanCollide = false
block.CanTouch = false
block.Transparency = 1
blockfind = workspace:FindFirstChild(block.Name)
if blockfind and blockfind ~= block then blockfind:Destroy() end

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
  Title = "DoMon Hub : Blox Fruits",
  SubTitle = "",
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
    Main = Window:MakeTab({ Title = "Tab General", Icon = "axe" }),
    Settings = Window:MakeTab({ Title = "Tab Setting", Icon = "rbxassetid://7734053495" }),
}


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

Tabs.Settings:AddButton({
    Name = "Xoá Map [ Tăng Tốc FPS Tối Đa ]",
    Description = "Làm trong suốt bản đồ, giữ lại va chạm để tránh lỗi rớt map",
    Callback = function()
        task.spawn(function()
            local MapFolder = Workspace:FindFirstChild("Map") or Workspace:FindFirstChild("SeaOutputs")
            local itemsToClear = MapFolder and MapFolder:GetDescendants() or Workspace:GetDescendants()
            
            for i, v in ipairs(itemsToClear) do
                if v.Parent and v.Parent.Name ~= "Enemies" and v.Parent.Name ~= "Players" and v.Parent.Name ~= plr.Name then
                    if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then
                        v.Transparency = 1
                        v.CastShadow = false
                        v.Material = Enum.Material.SmoothPlastic
                    elseif v:IsA("Decal") or v:IsA("Texture") then
                        v:Destroy()
                    end
                end
                if i % 500 == 0 then task.wait() end
            end
            
            pcall(function() 
                Workspace.Terrain.WaterTransparency = 1 
                Workspace.Terrain.WaterWaveSize = 0
                Workspace.Terrain.WaterWaveSpeed = 0
                -- ✅ Sửa typo: EnviromentalPhysicsThrottle → EnvironmentalPhysicsThrottle
                settings().Physics.PhysicsEnvironmentalThrottle = Enum.EnvironmentalPhysicsThrottle.DefaultAuto
            end)
        end)
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
Tabs.Settings:AddSlider({
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
Tabs.Settings:AddSlider({
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