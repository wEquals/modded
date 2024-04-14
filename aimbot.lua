--// Cache
local select = select
local pcall, getgenv, next, Vector2, mathclamp, type, mousemoverel = select(1, pcall, getgenv, next, Vector2.new, math.clamp, type, mousemoverel or (Input and Input.MouseMove))

local notificationLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/laagginq/ui-libraries/main/xaxas-notification/src.lua"))();
local notifications = notificationLibrary.new({            
    NotificationLifetime = 3, 
    NotificationPosition = "Middle",
    
    TextFont = Enum.Font.Code,
    TextColor = Color3.fromRGB(255, 255, 255),
    TextSize = 15,
    
    TextStrokeTransparency = 0, 
    TextStrokeColor = Color3.fromRGB(0, 0, 0)
});

notifications:BuildNotificationUI();

--// Preventing Multiple Processes
pcall(function()
    getgenv().Aimbot.Functions:Exit()
end)

--// Environment
getgenv().Aimbot = {}
local Environment = getgenv().Aimbot

--// Services
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

--// Variables
local RequiredDistance, Typing, Running, Animation, ServiceConnections = 2000, false, false, nil, {}
local Whitelisted = { "", "" } -- Add usernames here that the aimbot will not aim onto

--// Script Settings
Environment.Settings = {
    Enabled = false,
    TeamCheck = false,
    AliveCheck = false,
    WallCheck = false, -- Laggy
    Sensitivity = 0, -- Animation length (in seconds) before fully locking onto target
    ThirdPerson = false, -- Uses mousemoverel instead of CFrame to support locking in third person (could be choppy)
    ThirdPersonSensitivity = 3, -- Boundary: 0.1 - 5
    TriggerKey = "MouseButton2",
    Toggle = false,
    LockPart = "Head", -- Body part to lock on
    Invisible_Check = false, -- Check for players with 1 transparency
    ForceField_Check = false, -- Check for players with forcefield
    VisibilityCheck = false,
    Notify_Target = false -- Set to true to enable printing the target's username
}
Environment.FOVSettings = {
    Enabled = false,
    Visible = false,
    Amount = 90,
    Color = Color3.fromRGB(255, 255, 255),
    LockedColor = Color3.fromRGB(255, 70, 70),
    Transparency = 0.5,
    Sides = 60,
    Thickness = 1,
    Filled = false
}
Environment.FOVCircle = Drawing.new("Circle")

--// Functions
local function IsWhitelisted(player)
    for _, username in ipairs(Whitelisted) do
        if player.Name == username then
            return true
        end
    end
    return false
end

local function CheckWall(targetPosition)
    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = {Camera, LocalPlayer.Character}
    raycastParams.IgnoreWater = true

    local raycastHit = workspace:Raycast(Camera.CFrame.Position, targetPosition - Camera.CFrame.Position, raycastParams)
    return not raycastHit or raycastHit.Instance:IsDescendantOf(LocalPlayer.Character)
end

local function CheckObscuring(targetPosition)
    local parts = Camera:GetPartsObscuringTarget({LocalPlayer.Character.Head.Position, targetPosition}, {Camera, LocalPlayer.Character})
    for _, part in ipairs(parts) do
        if part.Transparency == 0 then
            return true
        end
    end
    return false
end

local function CancelLock()
    Environment.Locked = nil
    if Animation then Animation:Cancel() end
    Environment.FOVCircle.Color = Environment.FOVSettings.Color
end

local function GetClosestPlayer()
    if not Environment.Locked and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid").Health > 0 then
        RequiredDistance = (Environment.FOVSettings.Enabled and Environment.FOVSettings.Amount or 2000)

        for _, v in next, Players:GetPlayers() do
            if v ~= LocalPlayer and not IsWhitelisted(v) then -- Check if player is not whitelisted
                if v.Character and v.Character:FindFirstChild(Environment.Settings.LockPart) and v.Character:FindFirstChildOfClass("Humanoid") then
                    if Environment.Settings.TeamCheck and v.Team == LocalPlayer.Team then continue end
                    if Environment.Settings.AliveCheck and v.Character:FindFirstChildOfClass("Humanoid").Health <= 0 then continue end
                    if Environment.Settings.Invisible_Check and v.Character.Head and v.Character.Head.Transparency == 1 then continue end -- Check for transparency
                    if Environment.Settings.ForceField_Check and v.Character:FindFirstChildOfClass("ForceField") then continue end -- Check for forcefield
                    if Environment.Settings.WallCheck and not CheckWall(v.Character[Environment.Settings.LockPart].Position) then continue end -- Check for walls if WallCheck is enabled
                    if Environment.Settings.VisibilityCheck and CheckObscuring(v.Character[Environment.Settings.LockPart].Position) then continue end -- Check for obscuring if VisibilityCheck is enabled

                    local targetPartPosition = v.Character[Environment.Settings.LockPart].Position

                    local Vector, OnScreen = Camera:WorldToViewportPoint(targetPartPosition)
                    local Distance = (Vector2(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y) - Vector2(Vector.X, Vector.Y)).Magnitude

                    if Distance < RequiredDistance and OnScreen then
                        RequiredDistance = Distance
                        Environment.Locked = v
                        if Environment.Settings.Notify_Target then
                            notifications:Notify("Locked onto " .. v.Name);
                        end
                    end
                end
            end
        end
    elseif Environment.Locked and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid").Health > 0 then
        if (Vector2(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y) - Vector2(Camera:WorldToViewportPoint(Environment.Locked.Character[Environment.Settings.LockPart].Position).X, Camera:WorldToViewportPoint(Environment.Locked.Character[Environment.Settings.LockPart].Position).Y)).Magnitude > RequiredDistance then
            CancelLock()
        end
    else
        -- If the local player's health is zero or below, cancel the lock
        CancelLock()
    end
end



--// Typing Check
ServiceConnections.TypingStartedConnection = UserInputService.TextBoxFocused:Connect(function()
    Typing = true
end)

ServiceConnections.TypingEndedConnection = UserInputService.TextBoxFocusReleased:Connect(function()
    Typing = false
end)

--// Main
local function Load()
    ServiceConnections.RenderSteppedConnection = RunService.RenderStepped:Connect(function()
        if Environment.FOVSettings.Enabled and Environment.Settings.Enabled then
            Environment.FOVCircle.Radius = Environment.FOVSettings.Amount
            Environment.FOVCircle.Thickness = Environment.FOVSettings.Thickness
            Environment.FOVCircle.Filled = Environment.FOVSettings.Filled
            Environment.FOVCircle.NumSides = Environment.FOVSettings.Sides
            Environment.FOVCircle.Color = Environment.FOVSettings.Color
            Environment.FOVCircle.Transparency = Environment.FOVSettings.Transparency
            Environment.FOVCircle.Visible = Environment.FOVSettings.Visible
            Environment.FOVCircle.Position = Vector2(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y)
        else
            Environment.FOVCircle.Visible = false
        end

        if Running and Environment.Settings.Enabled then
            GetClosestPlayer()

            if Environment.Locked then
                if Environment.Settings.ThirdPerson then
                    Environment.Settings.ThirdPersonSensitivity = mathclamp(Environment.Settings.ThirdPersonSensitivity, 0.1, 5)
                    local Vector = Camera:WorldToViewportPoint(Environment.Locked.Character[Environment.Settings.LockPart].Position)
                    mousemoverel((Vector.X - UserInputService:GetMouseLocation().X) * Environment.Settings.ThirdPersonSensitivity, (Vector.Y - UserInputService:GetMouseLocation().Y) * Environment.Settings.ThirdPersonSensitivity)
                else
                    if Environment.Settings.Sensitivity > 0 then
                        Animation = TweenService:Create(Camera, TweenInfo.new(Environment.Settings.Sensitivity, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {CFrame = CFrame.new(Camera.CFrame.Position, Environment.Locked.Character[Environment.Settings.LockPart].Position)})
                        Animation:Play()
                    else
                        Camera.CFrame = CFrame.new(Camera.CFrame.Position, Environment.Locked.Character[Environment.Settings.LockPart].Position)
                    end
                end
                Environment.FOVCircle.Color = Environment.FOVSettings.LockedColor
            end
        end
    end)

    ServiceConnections.InputBeganConnection = UserInputService.InputBegan:Connect(function(Input)
        if not Typing then
            pcall(function()
                if Input.KeyCode == Enum.KeyCode[Environment.Settings.TriggerKey] then
                    if Environment.Settings.Toggle then
                        Running = not Running
                        if not Running then
                            CancelLock()
                        end
                    else
                        Running = true
                    end
                end
            end)

            pcall(function()
                if Input.UserInputType == Enum.UserInputType[Environment.Settings.TriggerKey] then
                    if Environment.Settings.Toggle then
                        Running = not Running
                        if not Running then
                            CancelLock()
                        end
                    else
                        Running = true
                    end
                end
            end)
        end
    end)

    ServiceConnections.InputEndedConnection = UserInputService.InputEnded:Connect(function(Input)
        if not Typing then
            if not Environment.Settings.Toggle then
                pcall(function()
                    if Input.KeyCode == Enum.KeyCode[Environment.Settings.TriggerKey] then
                        Running = false; CancelLock()
                    end
                end)

                pcall(function()
                    if Input.UserInputType == Enum.UserInputType[Environment.Settings.TriggerKey] then
                        Running = false; CancelLock()
                    end
                end)
            end
        end
    end)
end

--// Functions
Environment.Functions = {}

function Environment.Functions:Exit()
    for _, v in next, ServiceConnections do
        v:Disconnect()
    end

    if Environment.FOVCircle.Remove then Environment.FOVCircle:Remove() end

    getgenv().Aimbot.Functions = nil
    getgenv().Aimbot = nil
    
    Load = nil; GetClosestPlayer = nil; CancelLock = nil
end

function Environment.Functions:Restart()
    for _, v in next, ServiceConnections do
        v:Disconnect()
    end

    Load()
end

function Environment.Functions:ResetSettings()
    Environment.Settings = {
        Enabled = true,
        TeamCheck = false,
        AliveCheck = true,
        WallCheck = false,
        Sensitivity = 0, -- Animation length (in seconds) before fully locking onto target
        ThirdPerson = false, -- Uses mousemoverel instead of CFrame to support locking in third person (could be choppy)
        ThirdPersonSensitivity = 3, -- Boundary: 0.1 - 5
        TriggerKey = "MouseButton2",
        Toggle = false,
        LockPart = "Head", -- Body part to lock on
        Invisible_Check = false, -- Check for players with 1 transparency
        ForceField_Check = false, -- Check for players with forcefield
        Notify_Target = false -- Set to true to enable printing the target's username
    }

    Environment.FOVSettings = {
        Enabled = true,
        Visible = true,
        Amount = 90,
        Color = Color3.fromRGB(255, 255, 255),
        LockedColor = Color3.fromRGB(255, 70, 70),
        Transparency = 0.5,
        Sides = 60,
        Thickness = 1,
        Filled = false
    }
end

--// Load
Load()

--// Listen for local player health changes
LocalPlayer.CharacterAdded:Connect(function(character)
    local humanoid = character:WaitForChildOfClass("Humanoid")
    humanoid.HealthChanged:Connect(function(health)
        if health <= 0 then
            Running = false
            CancelLock()
        elseif health >= 100 then
            Running = true
        end
    end)
end)
