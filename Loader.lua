if not syn then return print("sup nigger") end

function SendNotification(title, text)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = title,
        Text = text
    })
end



--// Loaded Check
do
    if getgenv().OblivityLoaded then
        if getgenv().OblivityLoaded2 then
            return game:GetService("Players").LocalPlayer:Kick("Oblivity - Too many executions, If Oblivity isn't working, Please rejoin")
        end

        getgenv().OblivityLoaded2 = true
        return SendNotification("Oblivity", "Already loaded.")
    end
    
    getgenv().OblivityLoaded = true
end



local supported_games = {
    [7353845952] = "ProjectDelta.lua",
    [7336302630] = "ProjectDelta.lua"
}

local game_supported = supported_games[game.PlaceId]



local s,e = pcall(function()
    if game_supported then
        loadstring(game:HttpGet("https://raw.githubusercontent.com/DemoExists/Oblivity-2.0/main/Games/"..game_supported))()
    else
        SendNotification("Oblivity", "Game is not supported, Launching Universal")
        loadstring(game:HttpGet("https://raw.githubusercontent.com/DemoExists/Oblivity-2.0/main/Games/Universal.lua"))()
    end
end)



if not s and e then
    setclipboard(tostring(e))
    return game:GetService("Players").LocalPlayer:Kic("Oblivity - Loader Error Occured, Copied Error to Clipboard, Please DM this to Demo.")
end
