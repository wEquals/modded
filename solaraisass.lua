-- Box esp

local lplr = game.Players.LocalPlayer
local camera = game:GetService("Workspace").CurrentCamera
local CurrentCamera = workspace.CurrentCamera
local worldToViewportPoint = CurrentCamera.worldToViewportPoint

local HeadOff = Vector3.new(0, 0.5, 0)
local LegOff = Vector3.new(0, 3, 0)
local ArmOffset = Vector3.new(0, 2.5, 0) -- Offset for the arms

local BoxEnabled = false -- Boolean to control whether the ESP is enabled or not
local BoxInvisibleCheck = false -- Boolean to control whether the ESP ignores players with transparent heads
local BoxTeamCheck = false -- Boolean to control whether the ESP checks for team colors

for _, v in ipairs(game.Players:GetPlayers()) do
    local BoxOutline = Drawing.new("Square")
    BoxOutline.Visible = false
    BoxOutline.Color = Color3.new(0, 0, 0)
    BoxOutline.Thickness = 3
    BoxOutline.Transparency = 1
    BoxOutline.Filled = false

    local Box = Drawing.new("Square")
    Box.Visible = false
    Box.Color = Color3.new(1, 1, 1)
    Box.Thickness = 1
    Box.Transparency = 1
    Box.Filled = false

    function boxesp()
        game:GetService("RunService").RenderStepped:Connect(function()
            if BoxEnabled then -- Check if ESP is enabled
                if v.Character and v.Character:FindFirstChild("Humanoid") and v.Character:FindFirstChild("HumanoidRootPart") and v ~= lplr and v.Character.Humanoid.Health > 0 then
                    local Vector, onScreen = camera:worldToViewportPoint(v.Character.HumanoidRootPart.Position)

                    local RootPart = v.Character.HumanoidRootPart
                    local Head = v.Character.Head
                    local RightArm = v.Character:FindFirstChild("Right Arm")
                    local LeftArm = v.Character:FindFirstChild("Left Arm")
                    local RootPosition, RootVis = worldToViewportPoint(CurrentCamera, RootPart.Position)
                    local HeadPosition = worldToViewportPoint(CurrentCamera, Head.Position + HeadOff)
                    local LegPosition = worldToViewportPoint(CurrentCamera, RootPart.Position - LegOff)
                    local RightArmPosition = worldToViewportPoint(CurrentCamera, RightArm.Position + ArmOffset)
                    local LeftArmPosition = worldToViewportPoint(CurrentCamera, LeftArm.Position + ArmOffset)

                    if onScreen then
                        if BoxInvisibleCheck and Head.Transparency == 1 then
                            -- Check if BoxInvisibleCheck is true and head transparency is 1
                            BoxOutline.Visible = false
                            Box.Visible = false
                        else
                            local topY = math.min(HeadPosition.Y, RightArmPosition.Y, LeftArmPosition.Y) -- Find the highest point (head or arms)
                            local bottomY = math.max(LegPosition.Y, RightArmPosition.Y, LeftArmPosition.Y) -- Find the lowest point (legs or arms)

                            BoxOutline.Size = Vector2.new(2000 / RootPosition.Z, topY - bottomY) -- Adjusted width and length
                            BoxOutline.Position = Vector2.new(RootPosition.X - BoxOutline.Size.X / 2, bottomY) -- Align to the bottom
                            BoxOutline.Visible = true

                            Box.Size = Vector2.new(2000 / RootPosition.Z, topY - bottomY) -- Adjusted width and length
                            Box.Position = Vector2.new(RootPosition.X - Box.Size.X / 2, bottomY) -- Align to the bottom
                            Box.Visible = true

                            if BoxTeamCheck then
                                if v.TeamColor == lplr.TeamColor then
                                    BoxOutline.Visible = false
                                    Box.Visible = false
                                else
                                    BoxOutline.Visible = true
                                    Box.Visible = true
                                end
                            end
                        end
                    else
                        BoxOutline.Visible = false
                        Box.Visible = false
                    end
                else
                    BoxOutline.Visible = false
                    Box.Visible = false
                end
            else
                BoxOutline.Visible = false
                Box.Visible = false
            end
        end)
    end
    coroutine.wrap(boxesp)()
end

game.Players.PlayerAdded:Connect(function(v)
    local BoxOutline = Drawing.new("Square")
    BoxOutline.Visible = false
    BoxOutline.Color = Color3.new(0, 0, 0)
    BoxOutline.Thickness = 3
    BoxOutline.Transparency = 1
    BoxOutline.Filled = false

    local Box = Drawing.new("Square")
    Box.Visible = false
    Box.Color = Color3.new(1, 1, 1)
    Box.Thickness = 1
    Box.Transparency = 1
    Box.Filled = false

    function boxesp()
        game:GetService("RunService").RenderStepped:Connect(function()
            if BoxEnabled then -- Check if ESP is enabled
                if v.Character and v.Character:FindFirstChild("Humanoid") and v.Character:FindFirstChild("HumanoidRootPart") and v ~= lplr and v.Character.Humanoid.Health > 0 then
                    local Vector, onScreen = camera:worldToViewportPoint(v.Character.HumanoidRootPart.Position)

                    local RootPart = v.Character.HumanoidRootPart
                    local Head = v.Character.Head
                    local RightArm = v.Character:FindFirstChild("Right Arm")
                    local LeftArm = v.Character:FindFirstChild("Left Arm")
                    local RootPosition, RootVis = worldToViewportPoint(CurrentCamera, RootPart.Position)
                    local HeadPosition = worldToViewportPoint(CurrentCamera, Head.Position + HeadOff)
                    local LegPosition = worldToViewportPoint(CurrentCamera, RootPart.Position - LegOff)
                    local RightArmPosition = worldToViewportPoint(CurrentCamera, RightArm.Position + ArmOffset)
                    local LeftArmPosition = worldToViewportPoint(CurrentCamera, LeftArm.Position + ArmOffset)

                    if onScreen then
                        if BoxInvisibleCheck and Head.Transparency == 1 then
                            -- Check if BoxInvisibleCheck is true and head transparency is 1
                            BoxOutline.Visible = false
                            Box.Visible = false
                        else
                            local topY = math.min(HeadPosition.Y, RightArmPosition.Y, LeftArmPosition.Y) -- Find the highest point (head or arms)
                            local bottomY = math.max(LegPosition.Y, RightArmPosition.Y, LeftArmPosition.Y) -- Find the lowest point (legs or arms)

                            BoxOutline.Size = Vector2.new(2000 / RootPosition.Z, topY - bottomY) -- Adjusted width and length
                            BoxOutline.Position = Vector2.new(RootPosition.X - BoxOutline.Size.X / 2, bottomY) -- Align to the bottom
                            BoxOutline.Visible = true

                            Box.Size = Vector2.new(2000 / RootPosition.Z, topY - bottomY) -- Adjusted width and length
                            Box.Position = Vector2.new(RootPosition.X - Box.Size.X / 2, bottomY) -- Align to the bottom
                            Box.Visible = true

                            if BoxTeamCheck then
                                if v.TeamColor == lplr.TeamColor then
                                    BoxOutline.Visible = false
                                    Box.Visible = false
                                else
                                    BoxOutline.Visible = true
                                    Box.Visible = true
                                end
                            end
                        end
                    else
                        BoxOutline.Visible = false
                        Box.Visible = false
                    end
                else
                    BoxOutline.Visible = false
                    Box.Visible = false
                end
            else
                BoxOutline.Visible = false
                Box.Visible = false
            end
        end)
    end
    coroutine.wrap(boxesp)()
end)

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "pluh",
    LoadingTitle = "Rayfield Interface Suite",
    LoadingSubtitle = "by equaks :3",
    ConfigurationSaving = {
       Enabled = true,
       FolderName = nil, -- Create a custom folder for your hub/game
       FileName = "idk"
    },
    Discord = {
       Enabled = false,
       Invite = "noinvitelink", -- The Discord invite code, do not include discord.gg/. E.g. discord.gg/ABCD would be ABCD
       RememberJoins = true -- Set this to false to make them join the discord every time they load it up
    },
    KeySystem = false, -- Set this to true to use our key system
    KeySettings = {
       Title = "Untitled",
       Subtitle = "Key System",
       Note = "No method of obtaining the key is provided",
       FileName = "Key", -- It is recommended to use something unique as other scripts using Rayfield may overwrite your key file
       SaveKey = true, -- The user's key will be saved, but if you change the key, they will be unable to use your script
       GrabKeyFromSite = false, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
       Key = {"Hello"} -- List of keys that will be accepted by the system, can be RAW file links (pastebin, github etc) or simple strings ("hello","key22")
    }
 })

 loadstring(game:HttpGet("https://raw.githubusercontent.com/wEquals/modded/main/aimbot.lua"))()

local Aimbot = getgenv().Aimbot
local Settings, FOVSettings, Functions = Aimbot.Settings, Aimbot.FOVSettings, Aimbot.Functions

 local Tab = Window:CreateTab("main", 4483362458) -- Title, Image

 local Section = Tab:CreateSection("main")

 local AimbotEnable = Tab:CreateToggle({
    Name = "enable",
    CurrentValue = false,
    Flag = "Toggle1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(Value)
        Settings.Enabled = Value
    end,
 })

 local MouseEnable = Tab:CreateToggle({
    Name = "mouse",
    CurrentValue = false,
    Flag = "Toggle2", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(Value)
        Settings.ThirdPerson = Value
    end,
 })


 local lockpart = Tab:CreateDropdown({
    Name = "lockpart",
    Options = {'Head', 'HumanoidRootPart', 'Left Arm', 'Right Arm', 'Left Leg', 'Right Leg'},
    CurrentOption = {"Head"},
    MultipleOptions = false,
    Flag = "Dropdown1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(Option)
        Settings.LockPart = Option
    end,
 })
 
 local CameraSmoothness = Tab:CreateSlider({
    Name = "camera smoothness",
    Range = {0, 100},
    Increment = 0.5,
    Suffix = "",
    CurrentValue = 0,
    Flag = "Slider1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(Value)
        Settings.Sensitivity = Value
    end,
 })

 local MouseSmoothness = Tab:CreateSlider({
    Name = "mouse smoothness",
    Range = {0, 100},
    Increment = 0.5,
    Suffix = "",
    CurrentValue = 0,
    Flag = "Slider2", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(Value)
        Settings.ThirdPersonSensitivity = Value
    end,
 })

 local Wallcheckenableaimbot = Tab:CreateToggle({
    Name = "wall",
    CurrentValue = false,
    Flag = "wall", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(Value)
        Settings.VisibilityCheck = Value
    end,
 })

 local AliveCheckaim = Tab:CreateToggle({
    Name = "alive",
    CurrentValue = false,
    Flag = "alive", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(Value)
        Settings.AliveCheck = Value
    end,
 })

 local teamcheckaimbot = Tab:CreateToggle({
    Name = "team",
    CurrentValue = false,
    Flag = "team", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(Value)
        Settings.TeamCheck = Value
    end,
 })

 local forcefieldcheckaimbot = Tab:CreateToggle({
    Name = "forcefield",
    CurrentValue = false,
    Flag = "forcefield", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(Value)
        Settings.ForceField_Check = Value
    end,
 })

 local invisiblecheckaimbot = Tab:CreateToggle({
    Name = "invisible",
    CurrentValue = false,
    Flag = "invisible", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(Value)
        Settings.Invisible_Check = Value
    end,
 })

 
 local fovenableaimbot = Tab:CreateToggle({
    Name = "fov",
    CurrentValue = false,
    Flag = "fov", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(Value)
        FOVSettings.Enabled = Value
        FOVSettings.Visible = Value
    end,
 })
 
 local fovsizeaimbot = Tab:CreateSlider({
    Name = "fov size",
    Range = {0, 100},
    Increment = 10,
    Suffix = "Bananas",
    CurrentValue = 10,
    Flag = "Slider1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(Value)
        FOVSettings.Amount = Value
    end,
 })
 
 local Tab2 = Window:CreateTab("visuals", 4483362458) -- Title, Image

 local Section = Tab2:CreateSection("main")
 
 local boxespenable = Tab2:CreateToggle({
    Name = "box esp",
    CurrentValue = false,
    Flag = "box", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(Value)
        BoxEnabled = Value
    end,
 })

 local teamcheckenablebox = Tab2:CreateToggle({
    Name = "team",
    CurrentValue = false,
    Flag = "team", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(Value)
        BoxTeamCheck = Value
    end,
 })

 local invisiblecheckbox = Tab2:CreateToggle({
    Name = "invisible",
    CurrentValue = false,
    Flag = "invisible", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(Value)
        BoxInvisibleCheck = Value
    end,
 })
 
