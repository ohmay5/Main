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

-- ========================================
-- Tabs
-- ========================================

local Main = Library:MakeTab({
    Title = "Dungeon",
    Icon = "rbxassetid://7040410130"
})


-- Dungeon Info
Main:AddSection({"Dungeon Info"})

Main:AddParagraph({
    "Dungeon Info",
    "PlaceID: "..tostring(placeId).."\nDungeon Hub Loaded"
})


-- ========================================
-- Bring Mobs Dungeon
-- ========================================

Main:AddSection({"Bring Mobs"})


local ScanRadius = 1000
local MaxBring = 5
local HoldHeight = 1


local function GetLocalCharacterRoot()
    local Char = plr.Character or plr.CharacterAdded:Wait()
    return Char:FindFirstChild("HumanoidRootPart")
end


local function GetEnemiesFolder()
    return workspace:FindFirstChild("Enemies")
end


local function GetMobsInRadius(Position, Radius)

    local Folder = GetEnemiesFolder()

    if not Folder then
        return {}
    end

    local Mobs = {}

    for _,Mob in pairs(Folder:GetChildren()) do

        local Humanoid = Mob:FindFirstChild("Humanoid")
        local Root = Mob:FindFirstChild("HumanoidRootPart")

        if Humanoid and Root and Humanoid.Health > 0 then

            if (Root.Position - Position).Magnitude <= Radius then
                table.insert(Mobs,Mob)
            end

        end
    end

    return Mobs
end


local BringThread


Main:AddToggle({

    Name = "Bring Mobs Dungeon",

    Description = "Bring enemies",

    Default = false,


    Callback = function(Value)

        _G.BringMobsDungeon = Value


        if Value then

            BringThread = task.spawn(function()

                while _G.BringMobsDungeon do

                    task.wait(.2)


                    local Root = GetLocalCharacterRoot()


                    if Root then

                        local Mobs =
                            GetMobsInRadius(
                                Root.Position,
                                ScanRadius
                            )


                        for i = 1, math.min(#Mobs,MaxBring) do

                            local MobRoot =
                                Mobs[i]:FindFirstChild("HumanoidRootPart")


                            if MobRoot then

                                MobRoot.CFrame =
                                    Root.CFrame *
                                    CFrame.new(
                                        math.random(-5,5),
                                        0,
                                        math.random(-5,5)
                                    )

                            end
                        end
                    end
                end
            end)

        else

            _G.BringMobsDungeon = false

        end

    end

})



-- ========================================
-- Auto Farm Dungeon
-- ========================================

Main:AddSection({"Auto Farm"})


local FarmThread


Main:AddToggle({

    Name = "Auto Farm Dungeon",

    Description = "Auto kill dungeon",

    Default = false,


    Callback = function(Value)

        _G.AutoFarmDungeon = Value


        if Value then


            FarmThread = task.spawn(function()


                while _G.AutoFarmDungeon do


                    task.wait(.3)


                    local Enemies =
                        workspace:FindFirstChild("Enemies")


                    if Enemies then


                        for _,Enemy in pairs(Enemies:GetChildren()) do


                            local Humanoid =
                                Enemy:FindFirstChild("Humanoid")


                            local Root =
                                Enemy:FindFirstChild("HumanoidRootPart")


                            local MyRoot =
                                GetLocalCharacterRoot()


                            if Humanoid
                            and Root
                            and MyRoot
                            and Humanoid.Health > 0 then


                                MyRoot.CFrame =
                                    Root.CFrame *
                                    CFrame.new(0,20,0)

                                break

                            end
                        end
                    end

                end

            end)


        else

            _G.AutoFarmDungeon = false

        end

    end

})