--==================================================
-- DUNGEON FARM - REWORK
--==================================================

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local DUNGEON_PLACEID = 73902483975735

_G.GoingExit = false
_G.DeathPause = false
_G.Recovering = false

local TARGET_RANGE = 5000
local MOB_SPAWN_WAIT = 1.5
local EXIT_DISTANCE = 8

local PRIORITY_NAME = "PropHitboxPlaceholder"
local SHADOW_NAME = "Blank Buddy"


--==================================================
-- CHARACTER
--==================================================

local function GetChar()
    return LocalPlayer.Character
end

local function GetHum()
    local char = GetChar()
    return char and char:FindFirstChildOfClass("Humanoid")
end

local function GetHRP()
    local char = GetChar()
    return char and char:FindFirstChild("HumanoidRootPart")
end


--==================================================
-- DUNGEON CHECK
--==================================================

local function IsDungeonWorld()
    return game.PlaceId == DUNGEON_PLACEID
end

local function GetDungeon()
    local map = workspace:FindFirstChild("Map")
    return map and map:FindFirstChild("Dungeon")
end

local function IsInDungeon()
    return GetDungeon() ~= nil
end


--==================================================
-- FLOOR
--==================================================

local function IsInsideModelBBox(model, position)
    if not model or not position then
        return false
    end

    if not model:IsA("Model") then
        return false
    end

    local cf, size = model:GetBoundingBox()
    local localPos = cf:PointToObjectSpace(position)

    local padding = 25

    return
        math.abs(localPos.X) <= size.X / 2 + padding
        and
        math.abs(localPos.Y) <= size.Y / 2 + padding
        and
        math.abs(localPos.Z) <= size.Z / 2 + padding
end


local function GetCurrentFloor()
    local dungeon = GetDungeon()
    local hrp = GetHRP()

    if not dungeon or not hrp then
        return nil
    end

    -- Ưu tiên floor đang đứng bên trong
    for _, floor in ipairs(dungeon:GetChildren()) do
        if floor:IsA("Model") then
            if IsInsideModelBBox(floor, hrp.Position) then
                return floor
            end
        end
    end

    -- Fallback: floor gần nhất
    local nearest = nil
    local nearestDistance = math.huge

    for _, floor in ipairs(dungeon:GetChildren()) do
        if floor:IsA("Model") then
            local cf = floor:GetBoundingBox()
            local distance = (hrp.Position - cf.Position).Magnitude

            if distance < nearestDistance then
                nearestDistance = distance
                nearest = floor
            end
        end
    end

    return nearest
end


--==================================================
-- MOB VALIDATION
--==================================================

local function IsValidMob(mob, hrp)
    if not mob or not mob.Parent then
        return false
    end

    if mob.Name == SHADOW_NAME then
        return false
    end

    if mob.Name == PRIORITY_NAME then
        return false
    end

    local hum = mob:FindFirstChildOfClass("Humanoid")
    local root = mob:FindFirstChild("HumanoidRootPart")

    if not hum or not root then
        return false
    end

    if hum.Health <= 0 then
        return false
    end

    if not hrp then
        return false
    end

    if (hrp.Position - root.Position).Magnitude > TARGET_RANGE then
        return false
    end

    return true
end


--==================================================
-- CHECK MOB BELONGS TO CURRENT FLOOR
--==================================================

local function IsMobOnCurrentFloor(mob, floor)
    if not mob or not floor then
        return false
    end

    local root = mob:FindFirstChild("HumanoidRootPart")

    if not root then
        return false
    end

    return IsInsideModelBBox(floor, root.Position)
end


--==================================================
-- SCAN MOBS
--==================================================

local function ScanDungeonMobs()
    local hrp = GetHRP()
    local floor = GetCurrentFloor()

    if not hrp or not floor then
        return nil
    end

    local enemies = workspace:FindFirstChild("Enemies")

    if not enemies then
        return nil
    end

    local bestMob = nil
    local bestDistance = math.huge

    for _, mob in ipairs(enemies:GetChildren()) do

        if IsValidMob(mob, hrp) then

            -- QUAN TRỌNG:
            -- Chỉ lấy mob thuộc floor hiện tại
            if IsMobOnCurrentFloor(mob, floor) then

                local root = mob:FindFirstChild("HumanoidRootPart")

                if root then
                    local distance =
                        (hrp.Position - root.Position).Magnitude

                    if distance < bestDistance then
                        bestDistance = distance
                        bestMob = mob
                    end
                end
            end
        end
    end

    return bestMob
end


--==================================================
-- CHECK CÒN MOB SỐNG TRÊN FLOOR
--==================================================

local function HasMobOnCurrentFloor()
    local hrp = GetHRP()
    local floor = GetCurrentFloor()

    if not hrp or not floor then
        return false
    end

    local enemies = workspace:FindFirstChild("Enemies")

    if not enemies then
        return false
    end

    for _, mob in ipairs(enemies:GetChildren()) do

        if IsValidMob(mob, hrp) then

            if IsMobOnCurrentFloor(mob, floor) then
                return true
            end

        end
    end

    return false
end


--==================================================
-- EXIT
--==================================================

local function GetExitPart(exit)
    if not exit then
        return nil
    end

    if exit:IsA("BasePart") then
        return exit
    end

    if exit:IsA("Model") then

        if exit.PrimaryPart then
            return exit.PrimaryPart
        end

        for _, obj in ipairs(exit:GetDescendants()) do
            if obj:IsA("BasePart") then
                return obj
            end
        end
    end

    return nil
end


local function GetExitFromCurrentFloor()
    local floor = GetCurrentFloor()

    if not floor then
        return nil
    end

    local exit = floor:FindFirstChild("ExitTeleporter")

    if not exit then
        return nil
    end

    return GetExitPart(exit)
end


--==================================================
-- GO NEXT FLOOR
--==================================================

local function GoNextFloor()
    if not _G.Dungeonh then
        return
    end

    if _G.GoingExit then
        return
    end

    if _G.DeathPause then
        return
    end

    if not IsDungeonWorld() then
        return
    end

    _G.GoingExit = true

    local exitPart = GetExitFromCurrentFloor()

    if not exitPart then
        _G.GoingExit = false
        return
    end

    local hrp = GetHRP()

    if not hrp then
        _G.GoingExit = false
        return
    end

    -- Đi tới cửa
    _tp(exitPart.CFrame * CFrame.new(0, 3, 0))

    local timeout = tick() + 6

    repeat
        task.wait(0.1)

        hrp = GetHRP()

        if not hrp then
            break
        end

        if (hrp.Position - exitPart.Position).Magnitude <= EXIT_DISTANCE then
            break
        end

    until tick() > timeout

    -- Chờ Dungeon chuyển floor
    task.wait(1)

    -- Chờ floor mới load
    local floorTimeout = tick() + 5

    repeat
        task.wait(0.15)
    until GetCurrentFloor() or tick() > floorTimeout

    -- Cho mob mới thời gian spawn
    task.wait(MOB_SPAWN_WAIT)

    _G.GoingExit = false
end


--==================================================
-- DEATH
--==================================================

local diedConnection

local function HookDeath()
    if diedConnection then
        pcall(function()
            diedConnection:Disconnect()
        end)

        diedConnection = nil
    end

    local hum = GetHum()

    if not hum then
        return
    end

    diedConnection = hum.Died:Connect(function()

        if not _G.Dungeonh then
            return
        end

        _G.DeathPause = true

        pcall(function()
            StopTween(true)
        end)
    end)
end


LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.5)

    HookDeath()

    if not _G.Dungeonh then
        return
    end

    if not IsDungeonWorld() then
        return
    end

    task.spawn(function()

        _G.DeathPause = true

        local hrpTimeout = tick() + 10

        repeat
            task.wait(0.2)
        until GetHRP() or tick() > hrpTimeout

        task.wait(0.5)

        _G.DeathPause = false
    end)
end)


task.spawn(function()
    task.wait(1)
    HookDeath()
end)


--==================================================
-- MAIN DUNGEON FARM
--==================================================

task.spawn(function()

    local emptySince = 0

    while task.wait(0.1) do

        if not _G.Dungeonh then
            continue
        end

        if _G.GoingExit then
            continue
        end

        if _G.DeathPause then
            continue
        end

        if _G.Recovering then
            continue
        end

        if not IsDungeonWorld() then
            continue
        end

        if not IsInDungeon() then
            continue
        end

        pcall(function()

            local hrp = GetHRP()

            if not hrp then
                return
            end

            --==================================================
            -- BƯỚC 1: QUÉT MOB
            --==================================================

            local mob = ScanDungeonMobs()

            --==================================================
            -- BƯỚC 2: CÓ MOB
            --==================================================

            if mob then

                emptySince = 0

                local hum = mob:FindFirstChildOfClass("Humanoid")

                if not hum then
                    return
                end

                -- Đánh cho tới khi mob chết
                while
                    _G.Dungeonh
                    and not _G.GoingExit
                    and not _G.DeathPause
                    and mob.Parent
                    and hum
                    and hum.Health > 0
                do

                    hrp = GetHRP()

                    if not hrp then
                        break
                    end

                    -- Kiểm tra mob còn đúng floor không
                    local floor = GetCurrentFloor()

                    if not floor then
                        break
                    end

                    if not IsMobOnCurrentFloor(mob, floor) then
                        break
                    end

                    -- Kiểm tra lại target
                    if not IsValidMob(mob, hrp) then
                        break
                    end

                    AutoHaki()

                    EquipWeapon(_G.SelectWeapon)

                    -- Đánh Dungeon
                    if type(Attack) == "table"
                        and type(Attack.dungeon) == "function"
                    then

                        Attack.dungeon(mob, true)

                    else

                        break
                    end

                    task.wait(
                        tonumber(_G.Fast_Delay)
                        or 0.06
                    )

                    hum = mob:FindFirstChildOfClass("Humanoid")
                end

                return
            end

            --==================================================
            -- BƯỚC 3: KHÔNG THẤY MOB
            --==================================================

            if not HasMobOnCurrentFloor() then

                if emptySince == 0 then
                    emptySince = tick()
                end

                -- Chờ mob spawn
                if tick() - emptySince < MOB_SPAWN_WAIT then
                    return
                end

                --==================================================
                -- BƯỚC 4:
                -- SAU KHI CHỜ VẪN KHÔNG CÓ MOB
                --==================================================

                if not HasMobOnCurrentFloor() then

                    emptySince = 0

                    GoNextFloor()
                end

            else
                emptySince = 0
            end

        end)
    end
end)