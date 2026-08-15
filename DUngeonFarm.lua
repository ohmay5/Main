local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local DUNGEON_PLACEID = 73902483975735

_G.GoingExit = false
_G.DeathPause = false

local AIR_Y_THRESHOLD = 35
local TARGET_RANGE = 5000
local TARGET_OFFSET_Y = 30

local function IsDungeonWorld()
    return game.PlaceId == DUNGEON_PLACEID
end

local function IsInDungeon()
    return workspace:FindFirstChild("Map")
        and workspace.Map:FindFirstChild("Dungeon")
end

local function GetChar()
    return LocalPlayer.Character
end

local function GetHum()
    local c = GetChar()
    return c and c:FindFirstChildOfClass("Humanoid")
end

local function GetHRP()
    local char = GetChar()
    return char and char:FindFirstChild("HumanoidRootPart")
end

local function WaitHRP(timeout)
    local t = tick() + (timeout or 10)
    repeat
        local hrp = GetHRP()
        if hrp then return hrp end
        task.wait(0.1)
    until tick() > t
end


local PRIORITY_NAME  = "PropHitboxPlaceholder"
local PRIORITY_BONUS = 1000000
local SHADOW_NAME    = "Blank Buddy" -- KHÔNG đánh

local function GetHRP()
    local ch = game.Players.LocalPlayer.Character
    return ch and ch:FindFirstChild("HumanoidRootPart")
end

local function GetFloorModel(floor)
    local map = workspace:FindFirstChild("Map")
    local dun = map and map:FindFirstChild("Dungeon")
    return dun and dun:FindFirstChild(tostring(floor))
end

local function IsInsideModelBBox(model, pos)
    if not model or not pos or not model:IsA("Model") then return false end
    local cf, size = model:GetBoundingBox()
    local p = cf:PointToObjectSpace(pos)
    local pad = 25
    return math.abs(p.X) <= (size.X/2 + pad)
       and math.abs(p.Y) <= (size.Y/2 + pad)
       and math.abs(p.Z) <= (size.Z/2 + pad)
end

local function GetCurrentFloor()
    if not IsInDungeon() then return nil end
    local hrp = GetHRP()
    if not hrp then return nil end

    local dungeon = workspace.Map.Dungeon

    -- bbox hit
    for _, floor in ipairs(dungeon:GetChildren()) do
        if floor:IsA("Model") and IsInsideModelBBox(floor, hrp.Position) then
            return floor
        end
    end

    -- fallback: nearest bbox center
    local best, bestD = nil, math.huge
    for _, floor in ipairs(dungeon:GetChildren()) do
        if floor:IsA("Model") then
            local cf = floor:GetBoundingBox()
            local d = (hrp.Position - cf.Position).Magnitude
            if d < bestD then
                bestD = d
                best = floor
            end
        end
    end
    return best
end

local function ClearPropHitboxPlaceholder()
    local enemies = workspace:FindFirstChild("Enemies")
    if not enemies then return end
    for _, mob in ipairs(enemies:GetChildren()) do
        if mob and mob.Name == PRIORITY_NAME then
            mob:Destroy()
        end
    end
end

local _Floor16Hooked = false
local function Floor16CleanerTick()
    local hrp = GetHRP()
    local f16 = GetFloorModel(16)
    if f16 and hrp and IsInsideModelBBox(f16, hrp.Position) then
        ClearPropHitboxPlaceholder()

        if not _Floor16Hooked then
            _Floor16Hooked = true
            local enemies = workspace:FindFirstChild("Enemies")
            if enemies then
                enemies.ChildAdded:Connect(function(ch)
                    local hrp2 = GetHRP()
                    local f16_2 = GetFloorModel(16)
                    if ch and ch.Name == PRIORITY_NAME and f16_2 and hrp2 and IsInsideModelBBox(f16_2, hrp2.Position) then
                        ch:Destroy()
                    end
                end)
            end
        end
    end
end

local function IsValidMob(mob, hrp)
    if not mob or not mob.Parent then return false end
    if mob.Name == SHADOW_NAME then return false end -- skip Blank Buddy

    local hum = mob:FindFirstChild("Humanoid")
    local mhrp = mob:FindFirstChild("HumanoidRootPart")
    if not hum or not mhrp then return false end
    if hum.Health <= 0 then return false end

    local d = (hrp.Position - mhrp.Position).Magnitude
    if d > TARGET_RANGE then return false end

    return true
end

local function GetBestPropOnCurrentFloor()
    if not IsInDungeon() then return nil end
    local hrp = GetHRP()
    if not hrp then return nil end

    local floor = GetCurrentFloor()
    if not floor then return nil end

    local props = floor:FindFirstChild("Props")
    if not props then return nil end

    local best, bestD = nil, math.huge
    for _, obj in ipairs(props:GetChildren()) do
        local part = obj
        if obj:IsA("Model") then
            part = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart", true)
        end
        if part and part:IsA("BasePart") then
            local d = (hrp.Position - part.Position).Magnitude
            if d < bestD then
                bestD = d
                best = obj
            end
        end
    end

    return best
end

local function GetBestMob()
    local hrp = GetHRP()
    if not hrp then return nil end

    local prop = GetBestPropOnCurrentFloor()
    if prop then
        if prop:IsA("Model") and prop:FindFirstChildOfClass("Humanoid") and prop:FindFirstChild("HumanoidRootPart") then
            return prop
        end

        local enemies = workspace:FindFirstChild("Enemies")
        if enemies then
            for _, mob in ipairs(enemies:GetChildren()) do
                if mob and mob.Name:find(PRIORITY_NAME) then
                    return mob
                end
            end
        end

    end

    -- 2) fallback: tìm mob trong Enemies như cũ
    local enemies = workspace:FindFirstChild("Enemies")
    if not enemies then return nil end

    local best, bestScore = nil, math.huge
    for _, mob in ipairs(enemies:GetChildren()) do
        if IsValidMob(mob, hrp) then
            local d = (hrp.Position - mob.HumanoidRootPart.Position).Magnitude
            if d < bestScore then
                bestScore = d
                best = mob
            end
        end
    end

    return best
end

local function HasAnyRealEnemy()
    local hrp = GetHRP()
    if not hrp then return false end

    local enemies = workspace:FindFirstChild("Enemies")
    if not enemies then return false end

    for _, mob in ipairs(enemies:GetChildren()) do
        if IsValidMob(mob, hrp) then
            return true
        end
    end
    return false
end

local function GetExitPart(exit)
    if exit:IsA("BasePart") then return exit end
    if exit:IsA("Model") then
        if exit.PrimaryPart then return exit.PrimaryPart end
        for _, v in pairs(exit:GetDescendants()) do
            if v:IsA("BasePart") then
                return v
            end
        end
    end
end

local function GetExitFromFloor(floorModel)
    if not floorModel then return nil end
    local exit = floorModel:FindFirstChild("ExitTeleporter")
    if not exit then return nil end
    return GetExitPart(exit)
end

local function GetNearestExit()
    if not IsInDungeon() then return end
    local hrp = GetHRP()
    if not hrp then return end

    local nearest, dist = nil, math.huge
    for _, floor in pairs(workspace.Map.Dungeon:GetChildren()) do
        local exit = floor:FindFirstChild("ExitTeleporter")
        if exit then
            local part = GetExitPart(exit)
            if part then
                local d = (hrp.Position - part.Position).Magnitude
                if d < dist then
                    dist = d
                    nearest = part
                end
            end
        end
    end
    return nearest
end

local function GoNextFloor()
    if not _G.Dungeonh then return end
    if _G.GoingExit then return end
    if not IsDungeonWorld() then return end

    _G.GoingExit = true

    local hrp = WaitHRP(12)
    if not hrp then
        _G.GoingExit = false
        return
    end

    local mapTimeout = tick() + 10
    repeat task.wait(0.2) until IsInDungeon() or tick() > mapTimeout

    for _ = 1, 8 do
        Floor16CleanerTick()

        local currentFloor = GetCurrentFloor()
        local exitPart = GetExitFromFloor(currentFloor) or GetNearestExit()

        if exitPart then
            _tp(exitPart.CFrame * CFrame.new(0, 3, 0))

            local reachTimeout = tick() + 4
            repeat
                task.wait(0.1)
                hrp = GetHRP()
                if hrp and (hrp.Position - exitPart.Position).Magnitude <= 8 then
                    -- ĐÃ ĐẾN CỬA / SANG TẦNG MỚI:
                    _G.GoingExit = false
                    
                    -- 👉 THÊM ĐOẠN NÀY ĐỂ CHỜ QUÁI SPAWN KỊP
                    task.wait(1.5) -- Chờ 1.5 giây cho quái xuất hiện rồi mới cho phép farm
                    
                    return
                end
            until tick() > reachTimeout
        end

        task.wait(0.35)
    end

    _G.GoingExit = false
end

local function FreezeMobOnce(mob)
    if mob:FindFirstChild("Ngu") then return end

    local tag = Instance.new("BoolValue")
    tag.Name = "Ngu"
    tag.Parent = mob

    pcall(function()
        mob.HumanoidRootPart.Size = Vector3.new(60,60,60)
        mob.HumanoidRootPart.Transparency = 1
        mob.HumanoidRootPart.CanCollide = false
        mob.Humanoid.WalkSpeed = 0
        mob.Humanoid.JumpPower = 0
    end)
end

local diedConn
local function HookDeath()
    if diedConn then pcall(function() diedConn:Disconnect() end) end

    local hum = GetHum()
    if not hum then return end

    diedConn = hum.Died:Connect(function()
        if not _G.Dungeonh then return end
        _G.DeathPause = true
        pcall(function() StopTween(true) end)
    end)
end

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.25)
    HookDeath()

    -- nếu đang bật dungeon mà vừa respawn: bay tới floor gần nhất rồi mới resume
    task.spawn(function()
        if _G.Dungeonh and IsDungeonWorld() then
            _G.DeathPause = true
            task.wait(0.25)
            GoNextFloor()
            task.wait(0.2)
            _G.DeathPause = false
        end
    end)
end)

-- hook lần đầu
task.spawn(function()
    task.wait(0.5)
    HookDeath()
end)

task.spawn(function()

    local RETARGET_EVERY = 0.20
    local _lastRetarget = 0
    local LockedPriorityMob = nil

    while task.wait(0.05) do
        if not _G.Dungeonh then continue end
        if _G.GoingExit or _G.DeathPause then continue end
        if not IsDungeonWorld() or not IsInDungeon() then continue end

        pcall(function()
            local hrp = GetHRP()
            if not hrp then return end


            Floor16CleanerTick()


            local mob = GetBestMob()

            -- nếu không còn quái hợp lệ → next
            if not mob or not IsValidMob(mob, hrp) then
                LockedPriorityMob = nil
                if not HasAnyRealEnemy() then
                    GoNextFloor()
                end
                return
            end

            -- safety: nếu lỡ target prop ở floor 16
            do
                local f16 = GetFloorModel(16)
                if mob.Name == PRIORITY_NAME and f16 and IsInsideModelBBox(f16, hrp.Position) then
                    mob:Destroy()
                    LockedPriorityMob = nil
                    if not HasAnyRealEnemy() then
                        GoNextFloor()
                    end
                    return
                end
            end

            FreezeMobOnce(mob)

            repeat
                if not _G.Dungeonh or _G.GoingExit or _G.DeathPause then break end

                hrp = GetHRP()
                if not hrp then break end

                if not mob or not mob.Parent then break end
                if not mob:FindFirstChild("Humanoid") or mob.Humanoid.Health <= 0 then break end

                -- dọn prop liên tục nếu đang floor 16
                Floor16CleanerTick()

                if tick() - _lastRetarget >= RETARGET_EVERY then
                    _lastRetarget = tick()

                    local newMob = GetBestMob()

                    -- nếu đang lock priority
                    if LockedPriorityMob then
                        if (not LockedPriorityMob.Parent)
                            or (not LockedPriorityMob:FindFirstChild("Humanoid"))
                            or LockedPriorityMob.Humanoid.Health <= 0 then
                            LockedPriorityMob = nil
                        else
                            mob = LockedPriorityMob
                        end
                    end

                    -- nếu chưa lock
                    if not LockedPriorityMob and newMob and newMob.Parent then
                        if newMob.Name == PRIORITY_NAME then
                            LockedPriorityMob = newMob
                            mob = newMob
                            FreezeMobOnce(mob)
                        else
                            if (not IsValidMob(mob, hrp)) and IsValidMob(newMob, hrp) then
                                mob = newMob
                                FreezeMobOnce(mob)
                            end
                        end
                    end
                end


                AutoHaki()
                EquipWeapon(_G.SelectWeapon)

                local mhrp = mob:FindFirstChild("HumanoidRootPart")
                if not mhrp then break end

task.wait(tonumber(_G.Fast_Delay) or 0.06)
Attack.Kill(mob, true)
            until false

            StartBring = (_G.DungeonBring ~= false)
            LockedPriorityMob = nil

            if _G.Dungeonh and (not _G.GoingExit) and (not _G.DeathPause) then
                if not HasAnyRealEnemy() then
                    GoNextFloor()
                end
            end
        end)
    end
end)

local _EmptySince = 0
local EMPTY_DELAY = 1.5 -- trống ~0.9s mới next (đỡ next sớm)

task.spawn(function()
    local emptySince = 0

    while task.wait(0.05) do
        if not _G.Dungeonh then continue end
        if _G.GoingExit or _G.DeathPause or _G.Recovering then continue end
        if not IsInDungeon() then continue end

        if type(Attack) ~= "table" or type(Attack.dungeon) ~= "function" then
            continue
        end

        local hrp = GetHRP()
        if not hrp then continue end

        local mob = GetBestMob()
        if not mob then
            if not HasAnyRealEnemy() then
                if emptySince == 0 then emptySince = tick() end
                if tick() - emptySince >= 0.8 then
                    GoNextFloor()
                    emptySince = 0
                end
            else
                emptySince = 0
            end
            continue
        end
        emptySince = 0

        local hum = mob:FindFirstChildOfClass("Humanoid")
        while _G.Dungeonh and mob.Parent and hum and hum.Health > 0 do
            if _G.GoingExit or _G.DeathPause or _G.Recovering then break end
            if not IsInDungeon() then break end

            Attack.dungeon(mob, true)
            task.wait(tonumber(_G.Fast_Delay) or 0.06)

            hum = mob:FindFirstChildOfClass("Humanoid")
        end
    end
end)