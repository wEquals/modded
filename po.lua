local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local ClosestText = Drawing.new("Text")
ClosestText.Visible = true
ClosestText.Center = true
ClosestText.Outline = true
ClosestText.Font = 2
ClosestText.Color = Color3.fromRGB(255, 255, 255)
ClosestText.Size = 13
ClosestText.Text = ""

local PotentialTargetESP_Enable = false -- Set to true to enable text display

local ClosestPlayerESPTeamCheck = false -- Set to true to enable team check

local function getClosestPlayer()
    if not PotentialTargetESP_Enable then
        ClosestText.Text = ""
        return
    end

    local closestPlayer = nil
    local closestDistance = math.huge

    local localPos = LocalPlayer.Character and LocalPlayer.Character.HumanoidRootPart and LocalPlayer.Character.HumanoidRootPart.Position
    if not localPos then
        return
    end

    local localTeam = LocalPlayer.Team

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character.Humanoid and player.Character.Humanoid.Health > 0 then
            if not ClosestPlayerESPTeamCheck or (ClosestPlayerESPTeamCheck and player.Team ~= localTeam) then
                local playerPos = player.Character.HumanoidRootPart.Position
                local distance = (playerPos - localPos).magnitude
                if distance < closestDistance then
                    closestPlayer = player
                    closestDistance = distance
                end
            end
        end
    end

    if closestPlayer then
        ClosestText.Position = Vector2.new((workspace.CurrentCamera.ViewportSize.X / 2), (workspace.CurrentCamera.ViewportSize.Y / 2) + 50)
        ClosestText.Text = "flexmusix: " .. closestPlayer.Name -- Added concatenation
    else
        ClosestText.Text = ""
    end
end

getClosestPlayer()
Players.PlayerAdded:Connect(getClosestPlayer)
Players.PlayerRemoving:Connect(getClosestPlayer)

while true do
    wait(1)
    getClosestPlayer()
end
