-- ========================================
-- Dungeon Hub
-- PlaceId: 73902483975735
-- ========================================

repeat task.wait() until game:IsLoaded()


local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local plr = Players.LocalPlayer


-- ========================================
-- Dungeon Check
-- ========================================

local placeId = game.PlaceId

local Dungeon = (placeId == 73902483975735)


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

pcall(function()
    game.CoreGui.DungeonControlGUI:Destroy()
end)


local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DungeonControlGUI"
screenGui.Parent = game.CoreGui


local imageButton = Instance.new("ImageButton")

imageButton.Size = UDim2.new(0,35,0,35)

imageButton.Position =
    UDim2.new(0.15,0,0.15,0)

imageButton.Image =
    "rbxassetid://114476175638281"

imageButton.BackgroundTransparency = 1

imageButton.Parent = screenGui



local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0,8)
uiCorner.Parent = imageButton



local uiStroke = Instance.new("UIStroke")
uiStroke.Thickness = 2
uiStroke.Color = Color3.fromRGB(255,0,0)
uiStroke.Parent = imageButton



-- ========================================
-- Drag Button
-- ========================================

local dragging = false
local dragStart
local startPos
local dragInput


imageButton.InputBegan:Connect(function(input)

    if input.UserInputType == Enum.UserInputType.Touch
    or input.UserInputType == Enum.UserInputType.MouseButton1 then

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

    if input.UserInputType == Enum.UserInputType.Touch
    or input.UserInputType == Enum.UserInputType.MouseMovement then

        dragInput = input

    end

end)



UserInputService.InputChanged:Connect(function(input)

    if dragging and input == dragInput then

        local delta =
            input.Position - dragStart


        imageButton.Position =
            UDim2.new(

                startPos.X.Scale,
                startPos.X.Offset + delta.X,

                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y

            )

    end

end)



-- ========================================
-- Minimize
-- ========================================

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
-- ========================================

local Main = Library:MakeTab({

    Title = "Dungeon",

    Icon = "rbxassetid://7040410130"

})



-- ========================================
-- Dungeon Info
-- ========================================

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



local function GetLocalCharacterRoot()

    local Char =
        plr.Character or plr.CharacterAdded:Wait()

    return Char:FindFirstChild("HumanoidRootPart")

end



local function GetEnemiesFolder()

    return workspace:FindFirstChild("Enemies")

end



local function GetMobsInRadius(Position,Radius)

    local Folder = GetEnemiesFolder()

    if not Folder then
        return {}
    end


    local Mobs = {}


    for _,Mob in pairs(Folder:GetChildren()) do


        local Humanoid =
            Mob:FindFirstChild("Humanoid")


        local Root =
            Mob:FindFirstChild("HumanoidRootPart")



        if Humanoid
        and Root
        and Humanoid.Health > 0 then


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

    Default = false,


    Callback = function(Value)


        _G.BringMobsDungeon = Value



        if Value then


            BringThread = task.spawn(function()


                while _G.BringMobsDungeon do


                    task.wait(0.2)



                    local Root =
                        GetLocalCharacterRoot()



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


            if BringThread then

                task.cancel(BringThread)

                BringThread = nil

            end


        end


    end

})
-- ========================================
-- Auto Farm Dungeon
-- ========================================

Main:AddSection({"Auto Farm"})


local FarmThread



local function GetBestEnemy()

    local Folder = workspace:FindFirstChild("Enemies")

    if not Folder then
        return nil
    end


    local Root = GetLocalCharacterRoot()

    if not Root then
        return nil
    end


    local Target = nil
    local Distance = math.huge



    for _,Enemy in pairs(Folder:GetChildren()) do


        local Humanoid =
            Enemy:FindFirstChild("Humanoid")


        local EnemyRoot =
            Enemy:FindFirstChild("HumanoidRootPart")



        if Humanoid
        and EnemyRoot
        and Humanoid.Health > 0 then



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





Main:AddToggle({

    Name = "Auto Farm Dungeon",

    Default = false,


    Callback = function(Value)


        _G.AutoFarmDungeon = Value



        if Value then


            FarmThread = task.spawn(function()



                while _G.AutoFarmDungeon do



                    task.wait(0.3)



                    local Target =
                        GetBestEnemy()



                    local MyRoot =
                        GetLocalCharacterRoot()



                    if Target
                    and MyRoot then



                        local EnemyRoot =
                            Target:FindFirstChild("HumanoidRootPart")



                        local Humanoid =
                            Target:FindFirstChild("Humanoid")



                        if EnemyRoot
                        and Humanoid
                        and Humanoid.Health > 0 then



                            MyRoot.CFrame =
                                EnemyRoot.CFrame *
                                CFrame.new(0,20,0)



                        end


                    end



                end



            end)



        else


            _G.AutoFarmDungeon = false



            if FarmThread then

                task.cancel(FarmThread)

                FarmThread = nil

            end


        end


    end

})