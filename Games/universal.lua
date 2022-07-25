--[Load UI]
loadstring(game:HttpGet("https://raw.githubusercontent.com/DemoExists/Oblivious/main/universal.lua", true))()

--[Load ESP]
loadstring(game:HttpGet("https://raw.githubusercontent.com/DemoExists/Oblivity-2.0/main/Modules/ESP.lua", true))()

local plrs = game["Players"]
local ws = game["Workspace"]
local uis = game["UserInputService"]
local rs = game["RunService"]
local hs = game["HttpService"]
local cgui = game["CoreGui"]
local lighting = game["Lighting"]
local GuiService = game["GuiService"]
local repStorage = game["ReplicatedStorage"]

local plr = plrs.LocalPlayer
local mouse = plr:GetMouse()
local camera = ws.CurrentCamera
local worldToViewportPoint = camera.worldToViewportPoint

local Drawingnew = Drawing.new
local Color3new = Color3.new
local Color3fromRGB = Color3.fromRGB
local Vector3new = Vector3.new
local Vector2new = Vector2.new
local mathhuge = math.huge
local mathfloor = math.floor
local mathceil = math.ceil
local GetGuiInset = GuiService.GetGuiInset
local Raynew = Ray.new

VisualsTab = library:AddTab("Visuals", 1)
VisualsColumn1 = VisualsTab:AddColumn()
ESPSection = VisualsColumn1:AddSection("ESP")

ESPSection:AddToggle({text = "Toggle", flag = "ESP_Toggle", state = false, callback = function(bool)
    esp.enabled = bool
end})

ESPSection:AddToggle({text = "Name", flag = "ESP_NameToggle", state = false, callback = function(bool)
    esp.settings.name.enabled = bool
end}):AddColor({flag = "ESP_NameColor", color = Color3fromRGB(255, 255, 255), callback = function(color)
    esp.settings.name.color = color
end})

ESPSection:AddToggle({text = "Box", flag = "ESP_BoxToggle", state = false, callback = function(bool)
    esp.settings.box.enabled = bool
end}):AddColor({flag = "ESP_BoxColor", color = Color3fromRGB(255, 255, 255), callback = function(color)
    esp.settings.box.color = color
end})

ESPSection:AddToggle({text = "Health Bar", flag = "ESP_HealthBarToggle", state = false, callback = function(bool)
    esp.settings.healthbar.enabled = bool
end})

ESPSection:AddToggle({text = "Health Text", flag = "ESP_HealthTextToggle", state = false, callback = function(bool)
    esp.settings.healthtext.enabled = bool
end}):AddColor({flag = "ESP_HealthTextColor", color = Color3fromRGB(255, 255, 255), callback = function(color)
    esp.settings.healthtext.color = color
end})

ESPSection:AddToggle({text = "Distance", flag = "ESP_DistanceToggle", state = false, callback = function(bool)
    esp.settings.distance.enabled = bool
end}):AddColor({flag = "ESP_DistanceColor", color = Color3fromRGB(255, 255, 255), callback = function(color)
    esp.settings.distance.color = color
end})

ESPSection:AddToggle({text = "View Angle", flag = "ESP_ViewAngleToggle", state = false, callback = function(bool)
    esp.settings.viewangle.enabled = bool
end}):AddColor({flag = "ESP_ViewAngleColor", color = Color3fromRGB(255, 255, 255), callback = function(color)
    esp.settings.viewangle.color = color
end})

ESPSection:AddDivider("Settings")

ESPSection:AddToggle({text = "Display Names", flag = "ESP_DisplayNames", state = false, callback = function(bool)
    esp.settings.name.displaynames = bool
end})

ESPSection:AddToggle({text = "Outlines", flag = "ESP_Outlines", state = false, callback = function(bool)
    for i,v in pairs(esp.settings) do
        v.outline = bool
    end
end})

ESPSection:AddToggle({text = "Team Check", flag = "ESP_TeamCheck", state = false, callback = function(bool)
    esp.teamcheck = bool
end})

ESPSection:AddSlider({text = "Font Size", flag = "ESP_FontSize", min = 0, max = 100, value = 13, callback = function(integer)
    esp.fontsize = integer
end})

ESPSection:AddList({text = "Font", flag = "ESP_Font", max = 4, values = {"UI", "System", "Plex", "Monospace"}, value = "Plex", callback = function(item)
    if item == "UI" then
        esp.font = 0
    elseif item == "System" then
        esp.font = 1
    elseif item == "Plex" then
        esp.font = 2
    elseif item == "Monospace" then
        esp.font = 3
    end
end})

LightSection = VisualsColumn1:AddSection("Lighting")

LightSection:AddToggle({text = "Custom Ambient", flag = "Light_AmbientToggle", state = false, callback = function(bool)
    if bool == true then
        lighting.Ambient = library.flags["Light_AmbientColor"]
    elseif bool == false then
        lighting.Ambient = Color3fromRGB(70, 70, 70)
    end
end}):AddColor({flag = "Light_AmbientColor", color = Color3fromRGB(255, 255, 255), callback = function(color)
    if library.flags["Light_AmbientToggle"] then
        lighting.Ambient = library.flags["Light_AmbientColor"]
    end
end})

LightSection:AddToggle({text = "Global Shadows", flag = "Light_Shadows", state = true, callback = function(bool)
    lighting.GlobalShadows = bool
end})

if ws.Terrain:FindFirstChild("Clouds") then
    LightSection:AddToggle({text = "Clouds", flag = "Light_Clouds", state = ws.Terrain:FindFirstChild("Clouds").Enabled, callback = function(bool)
        ws.Terrain.Clouds.Enabled = bool
    end})
end

LightSection:AddToggle({text = "Grass", flag = "Light_Grass", state = gethiddenproperty(ws.Terrain, "Decoration"), callback = function(bool)
    sethiddenproperty(ws.Terrain, "Decoration", bool)
end})

local VisualsColumn2 = VisualsTab:AddColumn()
local SnaplineSection = VisualsColumn2:AddSection("Snapline")

local Snapline_Line = Drawingnew("Line")
Snapline_Line.Visible = true
Snapline_Line.Thickness = 1
Snapline_Line.Transparency = 1
Snapline_Line.From = Vector2new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
Snapline_Line.To = Vector2new(camera.ViewportSize.X /  2, camera.ViewportSize.Y / 2)
Snapline_Line.Color = Color3fromRGB(255, 255, 255)

function Snapline_Closest()
    local target = nil
    local maxDist = mathhuge

    for _,v in ipairs(plrs:GetPlayers()) do
        if v ~= plr and v.Character and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health ~= 0 and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Head") then
            local pos, onScreen = camera:WorldToViewportPoint(v.Character[library.flags["Aim_TargetPart"]].Position)
            if onScreen then
                local dist = (Vector2new(pos.X, pos.Y - GetGuiInset(GuiService).Y) - Vector2new(mouse.X, mouse.Y)).Magnitude
                if dist <= maxDist then
                    maxDist = dist 
                    target = v 
                end
            end
        end
    end
    return target
end

SnaplineSection:AddToggle({text = "Toggle", flag = "Snapline_Toggle", state = false, callback = function(bool)
    Snapline_Line.Visible = bool
end}):AddColor({flag = "Snapline_Color", color = Color3fromRGB(255, 255, 255), callback = function(color)
    Snapline_Line.Color = color
end})

SnaplineSection:AddSlider({text = "Thickness", flag = "Snapline_Thickness", min = 0.5, max = 5, value = 1, float = 0.1, callback = function(integer)
    Snapline_Line.Thickness = integer
end})

SnaplineSection:AddSlider({text = "Transparency", flag = "Snapline_Transparency", min = 0, max = 1, value = 1, float = 0.1, callback = function(integer)
    Snapline_Line.Transparency = integer
end})

SnaplineSection:AddList({text = "Snap Part", flag = "Snapline_TargetPart", max = 2, values = {"Head", "HumanoidRootPart"}, value = "Head"})

local FOVSection = VisualsColumn2:AddSection("FOV Circle")

local FOVCircle_Circle = Drawingnew("Circle")
FOVCircle_Circle.Visible = false
FOVCircle_Circle.Color = Color3fromRGB(255, 255, 255)
FOVCircle_Circle.Radius = 100
FOVCircle_Circle.Thickness = 1
FOVCircle_Circle.Filled = false
FOVCircle_Circle.Transparency = 1
FOVCircle_Circle.Position = Vector2new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)

FOVSection:AddToggle({text = "FOV Circle", flag = "FOVCircle_Toggle", state = false, callback = function(bool)
    FOVCircle_Circle.Visible = bool
end}):AddColor({flag = "FOVCircle_Color", color = Color3fromRGB(255, 255, 255), callback = function(color)
    FOVCircle_Circle.Color = color
end})

FOVSection:AddDivider("Settings")

FOVSection:AddToggle({text = "Filled", flag = "FOVCircle_Filled", state = false, callback = function(bool)
    FOVCircle_Circle.Filled = bool
end})

FOVSection:AddSlider({text = "Radius", flag = "FOVCircle_Radius", min = 0, max = 750, value = 100, callback = function(integer)
    FOVCircle_Circle.Radius = integer
end})

FOVSection:AddSlider({text = "Thickness", flag = "FOVCircle_Thickness", min = 0.5, max = 5, value = 1, float = 0.1, callback = function(integer)
    FOVCircle_Circle.Thickness = integer
end})

FOVSection:AddSlider({text = "Transparency", flag = "FOVCircle_Transparency", min = 0, max = 1, value = 1, float = 0.1, callback = function(integer)
    FOVCircle_Circle.Transparency = integer
end})

FOVSection:AddSlider({text = "Num Sides", flag = "FOVCircle_NumSides", min = 0, max = 30, value = 0, callback = function(integer)
    FOVCircle_Circle.NumSides = integer
end})

local CrossSection = VisualsColumn2:AddSection("Crosshair")

local Crosshair_Horizontal = Drawingnew("Line")
Crosshair_Horizontal.Visible = false
Crosshair_Horizontal.Thickness = 1
Crosshair_Horizontal.Transparency = 1
Crosshair_Horizontal.From = Vector2new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
Crosshair_Horizontal.To = Vector2new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
Crosshair_Horizontal.Color = Color3fromRGB(255, 255, 255)

local Crosshair_Vertical = Drawingnew("Line")
Crosshair_Vertical.Visible = false
Crosshair_Vertical.Thickness = 1
Crosshair_Vertical.Transparency = 1
Crosshair_Vertical.From = Vector2new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
Crosshair_Vertical.To = Vector2new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
Crosshair_Vertical.Color = Color3fromRGB(255, 255, 255)

CrossSection:AddToggle({text = "Crosshair", flag = "Crosshair_Toggle", state = false, callback = function(bool)
    Crosshair_Horizontal.Visible = bool
    Crosshair_Vertical.Visible = bool
end}):AddColor({flag = "Crosshair_Color", color = Color3fromRGB(255, 255, 255), callback = function(color)
    Crosshair_Horizontal.Color = color
    Crosshair_Vertical.Color = color
end})

CrossSection:AddDivider("Settings")

CrossSection:AddSlider({text = "Size", flag = "Crosshair_Size", min = 0, max = 250, value = 10, callback = function(integer)
    Crosshair_Horizontal.From = Vector2new(camera.ViewportSize.X / 2 - integer, camera.ViewportSize.Y / 2)
    Crosshair_Horizontal.To = Vector2new(camera.ViewportSize.X / 2 + integer, camera.ViewportSize.Y / 2)
    Crosshair_Vertical.From = Vector2new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2 - integer)
    Crosshair_Vertical.To = Vector2new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2 + integer)
end})

CrossSection:AddSlider({text = "Thickness", flag = "Crosshair_Thickness", min = 0.5, max = 5, value = 1, float = 0.1, callback = function(integer)
    Crosshair_Horizontal.Thickness = integer
    Crosshair_Vertical.Thickness = integer
end})

CrossSection:AddSlider({text = "Transparency", flag = "Crosshair_Transparency", min = 0, max = 1, value = 1, float = 0.1, callback = function(integer)
    Crosshair_Horizontal.Transparency = integer
    Crosshair_Vertical.Transparency = integer
end})



CombatTab = library:AddTab("Combat", 2)
CombatColumn1 = CombatTab:AddColumn()
AimSection = CombatColumn1:AddSection("Aim")

AimSection:AddToggle({text = "Toggle", flag = "Aim_BotToggle", state = false}):AddBind({nomouse = false, key = "MouseButton2", mode = "toggle", flag = "Aim_KeyDown"})

AimSection:AddDivider("Settings")

AimSection:AddToggle({text = "Team Check", flag = "Aim_TeamCheck", state = false})

AimSection:AddList({text = "Target Part", flag = "Aim_TargetPart", max = 2, values = {"Head", "HumanoidRootPart"}, value = "Head"})



PlayerTab = library:AddTab("Player", 3)
PlayerColumn1 = PlayerTab:AddColumn()
CharSection = PlayerColumn1:AddSection("Player")

CharSection:AddToggle({text = "Toggle Speed", flag = "Player_SpeedToggle", state = false}):AddSlider({flag = "Player_SpeedValue", min = 0, max = 150, value = originalWs})

CharSection:AddToggle({text = "Toggle Jump", flag = "Player_JumpToggle", state = false}):AddSlider({flag = "Player_JumpValue", min = 0, max = 500, value = originalJp})

CharSection:AddToggle({text = "Toggle FOV", flag = "Player_FOVToggle", state = false, callback = function(bool)
    if bool == true then
        camera.FieldOfView = library.flags["Player_FOVValue"]
    elseif bool == false then
        camera.FieldOfView = 70.000004553459
    end
end}):AddSlider({flag = "Player_FOVValue", min = 0, max = 120, value = 70, callback = function(integer)
    if library.flags["Player_FOVToggle"] then
        camera.FieldOfView = integer
    end
end})

library:Init();
library:selectTab(library.tabs[1]); 



function closestToMouse()
    local target = nil
    local maxDist = mathhuge

    for _,v in ipairs(plrs:GetPlayers()) do
        if v ~= plr and v.Character and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health ~= 0 and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Head") then
            local pos, onScreen = camera:WorldToViewportPoint(v.Character[library.flags["Aim_TargetPart"]].Position)
            if onScreen then
                local dist = (Vector2new(pos.X, pos.Y - GetGuiInset(GuiService).Y) - Vector2new(mouse.X, mouse.Y)).Magnitude
                if dist <= maxDist then
                    if library.flags["FOVCircle_Toggle"] then
                        if library.flags["Aim_TeamCheck"] then
                            if dist < library.flags["FOVCircle_Radius"] and plr.TeamColor ~= v.TeamColor then
                                maxDist = dist
                                target = v
                            end
                        else
                            if dist < library.flags["FOVCircle_Radius"] then
                                maxDist = dist
                                target = v
                            end
                        end
                    else
                        if library.flags["Aim_TeamCheck"] then
                            if dist <= maxDist and plr.TeamColor ~= v.TeamColor then
                                maxDist = dist
                                target = v
                            end
                        else
                            if dist <= maxDist then
                                maxDist = dist 
                                target = v 
                            end
                        end
                    end
                end
            end
        end
    end
    return target
end

local mainLoop = rs.RenderStepped:Connect(function()
    if library.flags["Aim_BotToggle"] and not library.flags["Aim_SilentToggle"] then 
        if library.flags["Aim_KeyDown"] then
            local targetPlr = closestToMouse()
            if targetPlr ~= nil then
                camera.CFrame = CFrame.new(camera.CFrame.Position, targetPlr.Character[library.flags["Aim_TargetPart"]].Position)
            end
        end
    end
    
    if library.flags["Snapline_Toggle"] then
        local ClosestPlayer = Snapline_Closest()
        
        if ClosestPlayer ~= nil and ClosestPlayer.Character and ClosestPlayer.Character:FindFirstChild("HumanoidRootPart") and ClosestPlayer.Character:FindFirstChild("Head") then
            local snapVector, snapOnScreen = camera:worldToViewportPoint(ClosestPlayer.Character[library.flags["Snapline_TargetPart"]].Position)
            if snapOnScreen then
                Snapline_Line.From = Vector2new(uis:GetMouseLocation().X, uis:GetMouseLocation().Y)
                Snapline_Line.To = Vector2new(snapVector.X, snapVector.Y)
                Snapline_Line.Visible = true
            else
                Snapline_Line.Visible = false
            end
        else
            Snapline_Line.Visible = false
        end
    end

    if library.flags["Light_AmbientToggle"] then
        lighting.Ambient = library.flags["Light_AmbientColor"]
    end

    if library.flags["Player_SpeedToggle"] then
        if plr.Character and plr.Character:FindFirstChild("Humanoid") then
            plr.Character.Humanoid.WalkSpeed = library.flags["Player_SpeedValue"]
        end
    end

    if library.flags["Player_JumpToggle"] then
        if plr.Character and plr.Character:FindFirstChild("Humanoid") then
            plr.Character.Humanoid.JumpPower = library.flags["Player_JumpValue"]
        end
    end
end)

camera:GetPropertyChangedSignal("FieldOfView"):Connect(function()
    if library.flags["Player_FOVToggle"] then
        camera.FieldOfView = library.flags["Player_FOVValue"]
    end
end)
