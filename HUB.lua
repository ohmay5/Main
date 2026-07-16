-- ========================================
-- Dungeon Hub
-- PlaceId: 73902483975735
-- ========================================

repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local plr = Players.LocalPlayer

-- ========================================
-- Dungeon Check
-- ========================================

local placeId = game.PlaceId
local Dungeon = false

if placeId == 73902483975735 then
    Dungeon = true
end

if not Dungeon then
    warn("Not Dungeon:", placeId)
    return
end

print("Dungeon Loaded:", placeId)


-- ========================================
-- Services
-- ========================================

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")


-- ========================================
-- Character
-- ========================================

local function GetRoot()
    local Char = plr.Character or plr.CharacterAdded:Wait()
    return Char:WaitForChild("HumanoidRootPart")
end


-- Simple TP Function
function _tp(cf)
    local Root = GetRoot()
    if Root then
        Root.CFrame = cf
    end
end


-- ========================================
-- Variables
-- ========================================

_G.BringMobsDungeon = false
_G.AutoFarmDungeon = false
_G.GoingToExit = false
_G.DeathPause = false

local BringMobsThread = nil
local FarmDungeonThread = nil


-- ========================================
-- Load UI
-- ========================================

local Library = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/ohmay5/Main/refs/heads/main/xRedzLib.lua.txt"
))():MakeWindow({

    Title = "青龙脚本 | Dungeon Hub",
    SubTitle = "Dungeon",
    SaveFolder = "Dungeon_Settings.json"
})


-- ========================================
-- Floating Button
-- ========================================

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DungeonControlGUI"
screenGui.Parent = game.CoreGui


local imageButton = Instance.new("ImageButton")
imageButton.Size = UDim2.new(0,35,0,35)
imageButton.Position = UDim2.new(0.15,0,0.15,0)
imageButton.Image = "rbxassetid://114476175638281"
imageButton.BackgroundTransparency = 1
imageButton.Parent = screenGui


local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0,8)
uiCorner.Parent = imageButton


local uiStroke = Instance.new("UIStroke", imageButton)
uiStroke.Thickness = 2
uiStroke.Color = Color3.fromRGB(255,0,0)


-- Drag System

local dragging = false
local dragInput
local dragStart
local startPos


local function update(input)

    local delta = input.Position - dragStart

    imageButton.Position = UDim2.new(
        startPos.X.Scale,
        startPos.X.Offset + delta.X,
        startPos.Y.Scale,
        startPos.Y.Offset + delta.Y
    )

end


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


imageButton.InputChanged:Connect(function(input)

    if input.UserInputType == Enum.UserInputType.MouseMovement
    or input.UserInputType == Enum.UserInputType.Touch then

        dragInput = input

    end

end)


UserInputService.InputChanged:Connect(function(input)

    if dragging and input == dragInput then
        update(input)
    end

end)



-- Minimize

local isOpen = true

imageButton.MouseButton1Click:Connect(function()

    isOpen = not isOpen

    if isOpen then
        Library:Minimize(false)
    else
        Library:Minimize(true)
    end

end)



-- ========================================
-- Tabs
-- =======================================

local Main = Library:MakeTab({
    Title = "Dungeon",
    Icon = "rbxassetid://7040410130"
})


Main:AddSection({"Dungeon Info"});
Main:AddLabel("PlaceID: "..tostring(placeId))
Main:AddLabel("Dungeon Hub Loaded")
-- ========================================
-- Bring Mobs Dungeon
-- ========================================

Main:AddSection({"Bring Mobs"});


local ScanRadius = 1000
local MaxBring = 5
local HoldHeight = 1


local function GetLocalCharacterRoot()

    local Char = plr.Character
    return Char and Char:FindFirstChild("HumanoidRootPart")

end


local function GetEnemiesFolder()

    return workspace:FindFirstChild("Enemies")

end



local function GetMobsInRadius(Position, Radius)

    local EnemiesFolder = GetEnemiesFolder()

    if not EnemiesFolder then
        return {}
    end


    local Mobs = {}


    for _, Mob in ipairs(EnemiesFolder:GetChildren()) do

        local Humanoid = Mob:FindFirstChild("Humanoid")
        local Root = Mob:FindFirstChild("HumanoidRootPart")


        if Humanoid and Root and Humanoid.Health > 0 then

            local Distance = (Root.Position - Position).Magnitude

            if Distance <= Radius then
                table.insert(Mobs, Mob)
            end

        end

    end


    return Mobs

end



local function CalculateRingPosition(Number, Radius)

    local Angle = Number * 2.3999632297287

    return Vector3.new(
        math.cos(Angle) * Radius,
        0,
        math.sin(Angle) * Radius
    )

end



Main:AddToggle({

    Name = "Bring Mobs Dungeon",

    Description = "Bring dungeon enemies",

    Default = false,


    Callback = function(Value)


        _G.BringMobsDungeon = Value


        if Value then


            BringMobsThread = task.spawn(function()


                while _G.BringMobsDungeon and Dungeon do


                    task.wait(0.2)


                    local Root = GetLocalCharacterRoot()


                    if Root then


                        local Mobs = GetMobsInRadius(
                            Root.Position,
                            ScanRadius
                        )


                        table.sort(Mobs,function(a,b)

                            return (
                                a.HumanoidRootPart.Position - Root.Position
                            ).Magnitude <
                            (
                                b.HumanoidRootPart.Position - Root.Position
                            ).Magnitude

                        end)



                        local Base =
                            Vector3.new(
                                Root.Position.X,
                                Root.Position.Y + HoldHeight,
                                Root.Position.Z
                            )


                        for i = 1, math.min(#Mobs,MaxBring) do


                            local MobRoot =
                                Mobs[i]:FindFirstChild("HumanoidRootPart")


                            if MobRoot then

                                MobRoot.CFrame =
                                    CFrame.new(
                                        Base +
                                        CalculateRingPosition(i,6)
                                    )

                            end

                        end


                    end


                end


            end)


        else


            _G.BringMobsDungeon = false


            if BringMobsThread then

                task.cancel(BringMobsThread)

                BringMobsThread = nil

            end


        end


    end

})





-- ========================================
-- Auto Farm Dungeon
-- ========================================


Main:AddSection({"Auto Farm"});

local function GetBestTarget()


    local Root = GetLocalCharacterRoot()

    if not Root then
        return nil
    end



    local Target
    local Distance = math.huge



    for _,Enemy in ipairs(workspace.Enemies:GetChildren()) do


        local Humanoid = Enemy:FindFirstChild("Humanoid")
        local EnemyRoot = Enemy:FindFirstChild("HumanoidRootPart")


        if Humanoid and EnemyRoot and Humanoid.Health > 0 then


            local Dist =
                (EnemyRoot.Position - Root.Position).Magnitude


            if Dist < Distance then

                Distance = Dist
                Target = Enemy

            end


        end


    end


    return Target

end




local function HasTarget()


    for _,Enemy in ipairs(workspace.Enemies:GetChildren()) do


        local Humanoid = Enemy:FindFirstChild("Humanoid")


        if Humanoid and Humanoid.Health > 0 then
            return true
        end


    end


    return false

end




local function GetExit()


    local Map = workspace:FindFirstChild("Map")


    if not Map then
        return nil
    end



    local DungeonMap =
        Map:FindFirstChild("Dungeon")


    if not DungeonMap then
        return nil
    end



    for _,Room in ipairs(DungeonMap:GetChildren()) do


        local Exit =
            Room:FindFirstChild("ExitTeleporter")


        if Exit then

            return Exit

        end


    end


end





Main:AddToggle({

    Name = "Auto Farm Dungeon",

    Description = "Kill mobs and move floor",

    Default = false,


    Callback = function(Value)


        _G.AutoFarmDungeon = Value



        if Value then



            FarmDungeonThread =
            task.spawn(function()



                while _G.AutoFarmDungeon and Dungeon do



                    task.wait(0.3)



                    local Root =
                        GetLocalCharacterRoot()



                    if Root then



                        local Target =
                            GetBestTarget()



                        if Target then


                            local EnemyRoot =
                                Target:FindFirstChild("HumanoidRootPart")


                            if EnemyRoot then


                                _tp(
                                    EnemyRoot.CFrame *
                                    CFrame.new(0,25,0)
                                )


                            end



                        else



                            if not HasTarget() then


                                local Exit =
                                    GetExit()


                                if Exit then


                                    _tp(
                                        Exit.CFrame *
                                        CFrame.new(0,3,0)
                                    )


                                end


                            end


                        end



                    end



                end



            end)



        else



            _G.AutoFarmDungeon = false



            if FarmDungeonThread then

                task.cancel(FarmDungeonThread)

                FarmDungeonThread = nil

            end



        end



    end

})