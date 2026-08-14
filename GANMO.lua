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
if World1 then BossList = {"The Gorilla King","Bobby","The Saw","Yeti","Mob Leader","Vice Admiral","Saber Expert","Warden","Chief Warden","Swan","Magma Admiral","Fishman Lord","Wysper","Thunder God","Cyborg","Ice Admiral","Greybeard"}
elseif World2 then BossList = {"Diamond","Jeremy","Orbitus","Don Swan","Smoke Admiral","Awakened Ice Admiral","Tide Keeper","Darkbeard","Cursed Captain","Order"}
elseif World3 then BossList = {"Stone","Hydra Leader","Kilo Admiral","Captain Elephant","Beautiful Pirate","Cake Queen","Dough King","Longma","Soul Reaper","Tyrant of the Skies"}
end
if World1 then MaterialList = {"Leather + Scrap Metal", "Angel Wings", "Magma Ore", "Fish Tail"}
elseif World2 then MaterialList = {"Leather + Scrap Metal", "Radioactive Material", "Ectoplasm", "Mystic Droplet", "Magma Ore", "Vampire Fang"}
elseif World3 then MaterialList = {"Scrap Metal", "Demonic Wisp", "Conjured Cocoa", "Dragon Scale", "Gunpowder", "Fish Tail", "Mini Tusk"}
end
Remotes = {
    RFSubmarineWorkerSpeak = replicated.Modules.Net["RF/SubmarineWorkerSpeak"],
    RFJobsRemoteFunction = replicated.Modules.Net["RF/JobsRemoteFunction"], 
    RFCraft = replicated:WaitForChild("Modules"):WaitForChild("Net"):WaitForChild("RF/Craft")
}
DungeonTables = {"Flame","Ice","Quake","Light","Dark","String","Rumble","Magma","Human: Buddha","Sand","Bird: Phoenix","Dough"}
RenMon = {"Snow Lurker","Arctic Warrior","Hidden Key","Awakened Ice Admiral"}
CursedTables = {["Mob"] = "Mythological Pirate",["Mob2"] = "Cursed Skeleton","Hell's Messenger",["Mob3"] = "Cursed Skeleton","Heaven's Guardian"}
Past = {"Part","SpawnLocation","Terrain","WedgePart","MeshPart"}
BartMon = {"Swan Pirate","Jeremy"}
CitizenTable = {"Forest Pirate","Captain Elephant"}
Human_v3_Mob = {"Fajita","Jeremy","Diamond"}
AllBoats = {"Beast Hunter","Lantern","Guardian","Grand Brigade","Dinghy","Sloop","The Sentinel"}
mastery1 = {"Cookie Crafter"}
mastery2 = {"Reborn Skeleton"}
PosMsList = {["Pirate Millionaire"] = CFrame.new(-712.8272705078125, 98.5770492553711, 5711.9541015625),["Pistol Billionaire"] = CFrame.new(-723.4331665039062, 147.42906188964844, 5931.9931640625),["Dragon Crew Warrior"] = CFrame.new(7021.50439453125, 55.76270294189453, -730.1290893554688),["Dragon Crew Archer"] = CFrame.new(6625, 378, 244),["Female Islander"] = CFrame.new(4692.7939453125, 797.9766845703125, 858.8480224609375),["Venomous Assailant"] = CFrame.new(4902, 670, 39), ["Marine Commodore"] = CFrame.new(2401, 123, -7589),["Marine Rear Admiral"] = CFrame.new(3588, 229, -7085),["Fishman Raider"] = CFrame.new(-10941, 332, -8760),["Fishman Captain"] = CFrame.new(-11035, 332, -9087),["Forest Pirate"] = CFrame.new(-13446, 413, -7760),["Mythological Pirate"] = CFrame.new(-13510, 584, -6987),["Jungle Pirate"] = CFrame.new(-11778, 426, -10592),["Musketeer Pirate"] = CFrame.new(-13282, 496, -9565),["Reborn Skeleton"] = CFrame.new(-8764, 142, 5963),["Living Zombie"] = CFrame.new(-10227, 421, 6161),["Demonic Soul"] = CFrame.new(-9579, 6, 6194),["Posessed Mummy"] = CFrame.new(-9579, 6, 6194),["Peanut Scout"] = CFrame.new(-1993, 187, -10103),["Peanut President"] = CFrame.new(-2215, 159, -10474),["Ice Cream Chef"] = CFrame.new(-877, 118, -11032),["Ice Cream Commander"] = CFrame.new(-877, 118, -11032),["Cookie Crafter"] = CFrame.new(-2021, 38, -12028),["Cake Guard"] = CFrame.new(-2024, 38, -12026),["Baking Staff"] = CFrame.new(-1932, 38, -12848),["Head Baker"] = CFrame.new(-1932, 38, -12848),["Cocoa Warrior"] = CFrame.new(95, 73, -12309),["Chocolate Bar Battler"] = CFrame.new(647, 42, -12401),["Sweet Thief"] = CFrame.new(116, 36, -12478),["Candy Rebel"] = CFrame.new(47, 61, -12889),["Ghost"] = CFrame.new(5251, 5, 1111)}
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
Attack.Kill2 = function(model,Succes)
  if model and model.Parent and Succes then
  if not model:GetAttribute("Locked") then model:SetAttribute("Locked",model.HumanoidRootPart.CFrame) end
  PosMon = model:GetAttribute("Locked").Position
  BringEnemy()
  EquipWeapon(_G.SelectWeapon)
  local Equipped = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool")
  local ToolTip = Equipped.ToolTip
  if ToolTip == "Blox Fruit" then _tp(model.HumanoidRootPart.CFrame * CFrame.new(0,10,0) * CFrame.Angles(0,math.rad(90),0)) else _tp(model.HumanoidRootPart.CFrame * CFrame.new(0,30,8) * CFrame.Angles(0,math.rad(180),0))end
  if RandomCFrame then wait(0.1)_tp(model.HumanoidRootPart.CFrame * CFrame.new(0, 30, 25)) wait(0.1)_tp(model.HumanoidRootPart.CFrame * CFrame.new(25, 30, 0)) wait(0.1)_tp(model.HumanoidRootPart.CFrame * CFrame.new(-25, 30 ,0)) wait(0.1)_tp(model.HumanoidRootPart.CFrame * CFrame.new(0, 30, 25)) wait(0.1)_tp(model.HumanoidRootPart.CFrame * CFrame.new(-25, 30, 0))end
  end
end
Attack.KillSea = function(model,Succes)
  if model and model.Parent and Succes then
  if not model:GetAttribute("Locked") then model:SetAttribute("Locked",model.HumanoidRootPart.CFrame) end
  PosMon = model:GetAttribute("Locked").Position
  BringEnemy()
  EquipWeapon(_G.SelectWeapon)
  local Equipped = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool")
  local ToolTip = Equipped.ToolTip
  if ToolTip == "Blox Fruit" then _tp(model.HumanoidRootPart.CFrame * CFrame.new(0,10,0) * CFrame.Angles(0,math.rad(90),0)) else notween(model.HumanoidRootPart.CFrame * CFrame.new(0,50,8)) wait(.85)notween(model.HumanoidRootPart.CFrame * CFrame.new(0,400,0)) wait(1)end
  end
end
Attack.Sword = function(model,Succes)
  if model and model.Parent and Succes then
  if not model:GetAttribute("Locked") then model:SetAttribute("Locked",model.HumanoidRootPart.CFrame) end
  PosMon = model:GetAttribute("Locked").Position
  BringEnemy()
  weaponSc("Sword")
  _tp(model.HumanoidRootPart.CFrame * CFrame.new(0,30,0))
  if RandomCFrame then wait(0.1)_tp(model.HumanoidRootPart.CFrame * CFrame.new(0, 30, 25)) wait(0.1)_tp(model.HumanoidRootPart.CFrame * CFrame.new(25, 30, 0)) wait(0.1)_tp(model.HumanoidRootPart.CFrame * CFrame.new(-25, 30 ,0)) wait(0.1)_tp(model.HumanoidRootPart.CFrame * CFrame.new(0, 30, 25)) wait(0.1)_tp(model.HumanoidRootPart.CFrame * CFrame.new(-25, 30, 0))end
  end
end
Attack.Mas = function(model,Succes)
  if model and model.Parent and Succes then
  if not model:GetAttribute("Locked") then model:SetAttribute("Locked",model.HumanoidRootPart.CFrame) end
  PosMon = model:GetAttribute("Locked").Position
  BringEnemy()
    if model.Humanoid.Health <= HealthM then
      _tp(model.HumanoidRootPart.CFrame * CFrame.new(0,20,0))
      Useskills("Blox Fruit","Z")
      Useskills("Blox Fruit","X")
      Useskills("Blox Fruit","C")
    else
      weaponSc("Melee")
      _tp(model.HumanoidRootPart.CFrame * CFrame.new(0,30,0))
    end
  end
end
Attack.Masgun = function(model,Succes)
  if model and model.Parent and Succes then
  if not model:GetAttribute("Locked") then model:SetAttribute("Locked",model.HumanoidRootPart.CFrame) end
  PosMon = model:GetAttribute("Locked").Position
  BringEnemy()
    if model.Humanoid.Health <= HealthM then
      _tp(model.HumanoidRootPart.CFrame * CFrame.new(0,35,8))
      Useskills("Gun","Z")
      Useskills("Gun","X")
    else
      weaponSc("Melee")
      _tp(model.HumanoidRootPart.CFrame * CFrame.new(0,30,0))
    end
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
statsSetings = function(Num, value)
  if Num == "Melee" then
    if plr.Data.Points.Value ~= 0 then
      replicated.Remotes.CommF_:InvokeServer("AddPoint","Melee",value)
    end
  elseif Num == "Defense" then
    if plr.Data.Points.Value ~= 0 then
      replicated.Remotes.CommF_:InvokeServer("AddPoint","Defense",value)
    end
  elseif Num == "Sword" then
    if plr.Data.Points.Value ~= 0 then
      replicated.Remotes.CommF_:InvokeServer("AddPoint","Sword",value)
    end
  elseif Num == "Gun" then
    if plr.Data.Points.Value ~= 0 then
      replicated.Remotes.CommF_:InvokeServer("AddPoint","Gun",value)
    end
  elseif Num == "Devil" then
    if plr.Data.Points.Value ~= 0 then
      replicated.Remotes.CommF_:InvokeServer("AddPoint","Demon Fruit",value)
    end
  end
end
_B = _B or false
_G.BringRange = _G.BringRange or 350
_G.SpeedB = _G.SpeedB or 180
_G.MobM = _G.MobM or 8

local Players = game:GetService("Players")
local TS = game:GetService("TweenService")
local plr = Players.LocalPlayer
local plrUserId = tostring(plr.UserId)

local BringingMobs = {}

local function isBossMob(mob)
    if not BossList then return false end
    for _, b in ipairs(BossList) do
        if mob.Name == b then return true end
    end
    return false
end

local function IsValidMob(v)
    if not v or not v.Parent then return false end
    local hum = v:FindFirstChildOfClass("Humanoid")
    local pp = v.PrimaryPart or v:FindFirstChild("HumanoidRootPart")
    if not hum or not pp then return false end
    if hum.Health <= 0 then return false end
    if hum:GetState() == Enum.HumanoidStateType.Dead then return false end
    local transparent = true
    for _, part in pairs(v:GetDescendants()) do
        if part:IsA("BasePart") then
            if part.Transparency < 0.9 then
                transparent = false
                break
            end
        end
    end
    if transparent then return false end
    return true
end

local TAG_KEY     = "BringOwner"
-- FIX: tăng timeout lên 10s, đủ để đánh xong 1 mob
local TAG_TIMEOUT = 10

local function IsMobTaggedByOther(pp)
    local ok, tag = pcall(function() return pp:GetAttribute(TAG_KEY) end)
    if not ok or not tag then return false end
    local parts = string.split(tostring(tag), ":")
    if #parts ~= 2 then return false end
    local tagOwner = parts[1]
    local tagTime  = tonumber(parts[2]) or 0
    if (tick() - tagTime) > TAG_TIMEOUT then return false end
    if tagOwner == plrUserId then return false end
    return true
end

local function TagMob(pp)
    pcall(function()
        pp:SetAttribute(TAG_KEY, plrUserId .. ":" .. tostring(tick()))
    end)
end

local function UntagMob(pp)
    pcall(function()
        pp:SetAttribute(TAG_KEY, nil)
    end)
end

local function ResetMobPhysics(pp)
    pcall(function()
        pp.AssemblyLinearVelocity  = Vector3.new(0, 0, 0)
        pp.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
        pp.CanCollide = false
    end)
end

-- FIX: Keep-alive loop refresh tag cho mob đang bị farm
-- Chạy song song, untag khi mob chết hoặc _B tắt
local FarmingMobs = {} -- track mob đang bị farm (sau khi bring xong)

local function StartFarmTag(mob, pp)
    local mobKey = mob:GetFullName()
    if FarmingMobs[mobKey] then return end
    FarmingMobs[mobKey] = true

    task.spawn(function()
        while _B and IsValidMob(mob) do
            TagMob(pp)
            task.wait(1) -- refresh mỗi 1s, dưới TAG_TIMEOUT
        end
        -- Mob chết hoặc farm tắt → untag
        UntagMob(pp)
        FarmingMobs[mobKey] = nil
    end)
end

BringEnemy = function()
    if not _B then
        -- FIX: Tắt farm → untag tất cả mob đang giữ
        for mobKey in pairs(FarmingMobs) do
            FarmingMobs[mobKey] = nil
        end
        return
    end

    local bringTarget = FarmPos or PosMon
    if not bringTarget then return end

    local char   = plr.Character
    local hrpPlr = char and char:FindFirstChild("HumanoidRootPart")
    if not hrpPlr then return end

    local range  = tonumber(_G.BringRange) or 350
    local speed  = tonumber(_G.SpeedB)     or 180
    local maxMob = tonumber(_G.MobM)       or 8

    pcall(function()
        if sethiddenproperty then sethiddenproperty(plr, "SimulationRadius", math.huge) end
        if setscriptable then setscriptable(plr, "SimulationRadius", true) end
    end)

    -- Dọn cache mob đã chết/mất
    for mobKey in pairs(BringingMobs) do
        local parts = string.split(mobKey, ".")
        local found = workspace.Enemies:FindFirstChild(parts[#parts])
        if not found then BringingMobs[mobKey] = nil end
    end

    local list = {}

    for _, v in pairs(workspace.Enemies:GetChildren()) do
        if isBossMob(v) then continue end
        if not IsValidMob(v) then continue end

        local mobKey = v:GetFullName()
        if BringingMobs[mobKey] then continue end

        local pp = v.PrimaryPart or v:FindFirstChild("HumanoidRootPart")
        if IsMobTaggedByOther(pp) then continue end

        local dist = (pp.Position - bringTarget).Magnitude
        if dist <= range then
            table.insert(list, { mob = v, pp = pp, dist = dist })
        end
    end

    table.sort(list, function(a, b) return a.dist < b.dist end)
    if #list == 0 then return end

    local count = 0
    for _, it in ipairs(list) do
        if count >= maxMob then break end

        local v, pp = it.mob, it.pp
        if not IsValidMob(v) then continue end
        if IsMobTaggedByOther(pp) then continue end

        count = count + 1

        local mobKey = v:GetFullName()
        BringingMobs[mobKey] = true
        TagMob(pp)

        pcall(function()
            ResetMobPhysics(pp)

            local offsetX  = math.random(-5, 5)
            local offsetZ  = math.random(-5, 5)
            local targetCF = CFrame.new(
                bringTarget.X + offsetX,
                bringTarget.Y,
                bringTarget.Z + offsetZ
            )

            local duration  = math.max(it.dist / speed, 0.1)
            local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
            local move      = TS:Create(pp, tweenInfo, { CFrame = targetCF })
            move:Play()

            task.spawn(function()
                while move.PlaybackState == Enum.PlaybackState.Playing do
                    task.wait(0.05)
                    if not IsValidMob(v) then
                        move:Cancel()
                        break
                    end
                    TagMob(pp)
                    ResetMobPhysics(pp)
                end

                pcall(function()
                    pp.CanCollide = true
                end)

                BringingMobs[mobKey] = nil

                -- FIX: Sau khi bring xong → bắt đầu keep-alive tag
                -- Mob sẽ bị giữ tag cho đến khi chết hoặc _B tắt
                if IsValidMob(v) and _B then
                    StartFarmTag(v, pp)
                else
                    UntagMob(pp)
                end
            end)

            move.Completed:Connect(function(state)
                pcall(function()
                    ResetMobPhysics(pp)
                    if state == Enum.PlaybackState.Completed then
                        pp.CanCollide = true
                    end
                end)
                BringingMobs[mobKey] = nil
            end)
        end)
    end
end

Useskills = function(weapon, skill)
  if weapon == "Melee" then
    weaponSc("Melee")
    if skill == "Z" then
      vim1:SendKeyEvent(true, "Z", false, game);
      vim1:SendKeyEvent(false, "Z", false, game);
    elseif skill == "X" then
      vim1:SendKeyEvent(true, "X", false, game);
      vim1:SendKeyEvent(false, "X", false, game);
    elseif skill == "C" then
      vim1:SendKeyEvent(true, "C", false, game);
      vim1:SendKeyEvent(false, "C", false, game);
    end
  elseif weapon == "Sword" then
    weaponSc("Sword")
    if skill == "Z" then
      vim1:SendKeyEvent(true, "Z", false, game);
      vim1:SendKeyEvent(false, "Z", false, game);
    elseif skill == "X" then
      vim1:SendKeyEvent(true, "X", false, game);
      vim1:SendKeyEvent(false, "X", false, game);
    end
  elseif weapon == "Blox Fruit" then
    weaponSc("Blox Fruit")
    if skill == "Z" then
      vim1:SendKeyEvent(true, "Z", false, game);
      vim1:SendKeyEvent(false, "Z", false, game);
    elseif skill == "X" then
      vim1:SendKeyEvent(true, "X", false, game);
      vim1:SendKeyEvent(false, "X", false, game);
    elseif skill == "C" then
      vim1:SendKeyEvent(true, "C", false, game);
      vim1:SendKeyEvent(false, "C", false, game);        
    elseif skill == "V" then
      vim1:SendKeyEvent(true, "V", false, game);
      vim1:SendKeyEvent(false, "V", false, game);
    end
  elseif weapon == "Gun" then
    weaponSc("Gun")
    if skill == "Z" then
      vim1:SendKeyEvent(true, "Z", false, game);
      vim1:SendKeyEvent(false, "Z", false, game);
    elseif skill == "X" then
      vim1:SendKeyEvent(true, "X", false, game);
      vim1:SendKeyEvent(false, "X", false, game);
    end
  end
  if weapon == "nil" and skill == "Y" then
    vim1:SendKeyEvent(true, "Y", false, game);
    vim1:SendKeyEvent(false, "Y", false, game);
  end
end
getgenv().AimSkill = false
getgenv().AimRadius = 2500
getgenv().AimPos = nil
getgenv().AimTarget = nil 
-- Biến này sẽ chứa Player được chọn từ Dropdown
getgenv().SelectedPlayer = nil 

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local RunService = game:GetService("RunService")

-- Hàm lấy vị trí mục tiêu
local function GetTarget()
    local myChar = LocalPlayer.Character
    if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then return nil end

    -- ƯU TIÊN 1: Nếu có mục tiêu được chọn từ Dropdown
    if getgenv().SelectedPlayer then
        local p = getgenv().SelectedPlayer
        if p and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChild("Humanoid") then
            if p.Character.Humanoid.Health > 0 then
                return p.Character.HumanoidRootPart
            end
        end
    end

    -- ƯU TIÊN 2: Nếu không chọn ai hoặc người đó chết/thoát, tự động quét người gần nhất (Optional)
    -- Nếu bạn CHỈ muốn bắn người chọn trong Dropdown, hãy xóa phần code dưới này
    local closestPart = nil
    local shortestDistance = getgenv().AimRadius

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer 
           and player.Character 
           and player.Character:FindFirstChild("HumanoidRootPart") 
           and player.Character:FindFirstChild("Humanoid") 
           and player.Character.Humanoid.Health > 0 
           and player.Team ~= LocalPlayer.Team then
            
            local targetRoot = player.Character.HumanoidRootPart
            local distance = (myChar.HumanoidRootPart.Position - targetRoot.Position).Magnitude

            if distance < shortestDistance then
                closestPart = targetRoot
                shortestDistance = distance
            end
        end
    end
    return closestPart
end

-- Cập nhật vị trí mục tiêu liên tục
RunService.Heartbeat:Connect(function()
    if getgenv().AimSkill then
        local targetPart = GetTarget()
        if targetPart then
            getgenv().AimTarget = targetPart
            -- Bạn có thể cộng thêm Vector3.new(0, 2, 0) nếu muốn aim vào đầu
            getgenv().AimPos = targetPart.Position 
        else
            getgenv().AimTarget = nil
            getgenv().AimPos = nil
        end
    end
end)

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
CheckF = function()
  if GetBP("Dragon-Dragon") or GetBP("Gas-Gas") or GetBP("Yeti-Yeti") or GetBP("Kitsune-Kitsune") or GetBP("T-Rex-T-Rex") then return true end
end
CheckBoat = function()
  for i, v in pairs(workspace.Boats:GetChildren()) do
    if tostring(v.Owner.Value) == tostring(plr.Name) then
      return v    
end;
  end;
  return false
end;
CheckEnemiesBoat = function()
  for _,v in pairs(workspace.Enemies:GetChildren()) do
    if (v.Name == "FishBoat") and v:FindFirstChild("Health").Value > 0 then
      return true    
end;
  end;
  return false
end;
CheckPirateGrandBrigade = function()
  for _,v in pairs(workspace.Enemies:GetChildren()) do
    if (v.Name == "PirateGrandBrigade" or v.Name == "PirateBrigade") and v:FindFirstChild("Health").Value > 0 then
      return true
    end
  end
  return false
end
CheckShark = function()
  for _,v in pairs(workspace.Enemies:GetChildren()) do
    if v.Name == "Shark" and Attack.Alive(v) then
      return true    
end;
  end;
  return false
end;
CheckTerrorShark = function()
  for _,v in pairs(workspace.Enemies:GetChildren()) do
    if v.Name == "Terrorshark" and Attack.Alive(v) then
      return true    
end;
  end;
  return false
end;
CheckPiranha = function()
  for _,v in pairs(workspace.Enemies:GetChildren()) do
    if v.Name == "Piranha" and Attack.Alive(v) then
      return true    
end;
  end;
  return false
end;
CheckFishCrew = function()
  for _,v in pairs(workspace.Enemies:GetChildren()) do
    if (v.Name == "Fish Crew Member" or v.Name == "Haunted Crew Member") and Attack.Alive(v) then
      return true    
end;
  end;
  return false
end;
CheckHauntedCrew = function()
  for _,v in pairs(workspace.Enemies:GetChildren()) do
    if (v.Name == "Haunted Crew Member") and Attack.Alive(v) then
      return true    
end;
  end;
  return false
end;
CheckSeaBeast = function()
  if workspace.SeaBeasts:FindFirstChild("SeaBeast1") then
    return true  
end;
  return false
end;
CheckLeviathan = function()
  if workspace.SeaBeasts:FindFirstChild("Leviathan") then
    return true  
end;
  return false
end;
UpdStFruit = function()
  for z,x in next, plr.Backpack:GetChildren() do
  StoreFruit = x:FindFirstChild("EatRemote", true)
    if StoreFruit then
      replicated.Remotes.CommF_:InvokeServer("StoreFruit",StoreFruit.Parent:GetAttribute("OriginalName"),
      plr.Backpack:FindFirstChild(x.Name))
    end
  end
end
collectFruits = function(Succes)
  if Succes then
    local Character = plr.Character
    for _,v1 in pairs(workspace:GetChildren()) do
    if string.find(v1.Name, "Fruit") then v1.Handle.CFrame = Character.HumanoidRootPart.CFrame end
    end
  end
end
Getmoon = function()
  if World1 then
    return Lighting.FantasySky.MoonTextureId
  elseif World2 then
    return Lighting.FantasySky.MoonTextureId
  elseif World3 then
    return Lighting.Sky.MoonTextureId
  end
end
DropFruits = function()
  for _,v3 in next, plr.Backpack:GetChildren() do
    if string.find(v3.Name, "Fruit") then
      EquipWeapon(v3.Name) wait(.1)
      if plr.PlayerGui.Main.Dialogue.Visible == true then plr.PlayerGui.Main.Dialogue.Visible = false end EquipWeapon(v3.Name) plr.Character:FindFirstChild(v3.Name).EatRemote:InvokeServer("Drop")
    end
  end
  for a,b2 in pairs(plr.Character:GetChildren()) do
    if string.find(b2.Name, "Fruit") then EquipWeapon(b2.Name) wait(.1)
    if plr.PlayerGui.Main.Dialogue.Visible == true then plr.PlayerGui.Main.Dialogue.Visible = false end EquipWeapon(b2.Name) plr.Character:FindFirstChild(b2.Name).EatRemote:InvokeServer("Drop")
    end
  end
end
GetBP = function(v)
  return plr.Backpack:FindFirstChild(v) or plr.Character:FindFirstChild(v)
end
GetIn = function(Name)
  for _ ,v1 in pairs(replicated.Remotes.CommF_:InvokeServer("getInventory")) do
    if type(v1) == "table" then
      if v1.Name == Name or plr.Character:FindFirstChild(Name) or plr.Backpack:FindFirstChild(Name) then
        return true
	 end
    end
  end
  return false
end
GetM = function(Name)
  for _,tab in pairs(replicated.Remotes.CommF_:InvokeServer("getInventory")) do
    if type(tab) == "table" then
	  if tab.Type == "Material" then
	    if tab.Name == Name then
		  return tab.Count
	    end
	  end
    end
  end
return 0
end
GetWP = function(nametool)
  for _,v4 in pairs(replicated.Remotes.CommF_:InvokeServer("getInventory")) do
    if type(v4) == "table" then
      if v4.Type == "Sword" then
        if v4.Name == nametool or plr.Character:FindFirstChild(nametool) or plr.Backpack:FindFirstChild(nametool) then
	     return true
	     end
	   end
      end
    end
  return false
end 
getInfinity_Ability = function(Method, Var)
  if not Root then return end
  if Method == "Soru" and Var then
    for _,gc in next, getgc() do
      if plr.Character.Soru then
        if ((typeof(gc) == "function") and (getfenv(gc).script == plr.Character.Soru)) then
          for _, v in next, getupvalues(gc) do
            if (typeof(v) == "table") then
              repeat wait(Sec) v.LastUse = 0 until not Var or (plr.Character.Humanoid.Health <= 0)
            end
          end
        end
      end
    end    
  elseif Method == "Energy" and Var then
    plr.Character.Energy.Changed:connect(function()
      if Var then plr.Character.Energy.Value = Energy end 
    end)
  elseif Method == "Observation" and Var then
    local VisionRadius = plr.VisionRadius
    VisionRadius.Value = math.huge
  end
end
Hop = function()
  pcall(function()
    for count = math.random(1, math.random(40, 75)), 100 do
      local remote = replicated.__ServerBrowser:InvokeServer(count)
	  for _, v in next, remote do
	  if tonumber(v['Count']) < 12 then TeleportService:TeleportToPlaceInstance(game.PlaceId, _) end
	  end    
    end
  end)
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
getgenv().TweenSpeedNear = 600

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
        and (getgenv().TweenSpeedNear or 600)
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
    Test.OutlineColor = Color3.fromRGB(255,0,0)
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
  Title = "Orange Hub : Blox Fruits",
  SubTitle = "by_orgvip³⁶",
  SaveFolder = "OrangeV5.lua"
})

MinimizeButton = Window:AddMinimizeButton({
    Button = { 
        Image = "rbxassetid://104922707580804", 
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
Initialize = Tabs.Settings:AddToggle({
Name = "Đánh Nhanh", 
Flag = "Initialize",
Description = "", 
Default = true,
Callback = function(Value)
  _G.Seriality = Value
end})
Bringmob = Tabs.Settings:AddToggle({
    Name = "Kéo Quái", 
    Flag = "Bringmob",
    Description = "", 
    Default = true,
    Callback = function(Value)
        _B = Value
        _G.BringMob = Value
    end
})

Tabs.Settings:AddSlider({
    Name = "Số Lượng Quái Kéo",
    Flag = "MobAmount",
    Description = "Kéo Max Lên Nhé",
    Min = 8,
    Max = 16,
    Default = _G.MobM,
    Increment = 1,
    Callback = function(Value)
        _G.MobM = Value
    end
})

Tabs.Settings:AddSlider({
    Name = "Range Kéo Quái",
    Flag = "BringRange",
    Description = "",
    Min = 300,
    Max = 350,
    Default = _G.BringRange,
    Increment = 10,
    Callback = function(Value)
        _G.BringRange = Value
    end
})


-- 🌀 Toggle Auto Server Hop mỗi 30 phút
HopToggle = Tabs.Settings:AddToggle({
    Name = "Tự Động Chuyển Server Mỗi 30 Phút",
    Flag = "HopToggle",
    Description = "",
    Default = false,
    Callback = function(Value)
    _G.AutoHopServer = Value
end})

-- 🕒 Bộ đếm và xử lý hop
task.spawn(function()
    while task.wait(1) do
        pcall(function()
            if _G.AutoHopServer then
                if not _G.HopTimer then
                    _G.HopTimer = tick()
                end
                local elapsed = tick() - _G.HopTimer
                if elapsed >= 1800 then -- 1800s = 30 phút
                    _G.HopTimer = tick()
                    if syn and syn.queue_on_teleport then
                        syn.queue_on_teleport("loadstring(game:HttpGet('https://pastefy.app/iiFOhcot/raw'))()")
                    end
                    game:GetService("TeleportService"):Teleport(game.PlaceId, game.Players.LocalPlayer)
                end
            else
                _G.HopTimer = nil
            end
        end)
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