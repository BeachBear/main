if game.PlaceId ~= 417267366 then
    return
end if not game:GetService("Players").LocalPlayer then
    game:GetService("Players").PlayerAdded:wait()
end if not game:IsLoaded() then
    game.Loaded:wait()
end

local loadedModel = game:GetObjects("rbxassetid://6520782286")[1]

if BetterDollhouse then
    for _,v in pairs(getgenv().BetterDollhouse.Seats) do
        v.Parent = loadedModel
    end
else
    getgenv().BetterDollhouse = {
        Seats = {};
    }

    for _,v in ipairs(workspace:GetDescendants()) do
        if v.ClassName == "Seat" then
            getgenv().BetterDollhouse.Seats[v] = v
            v.Parent = loadedModel
        end
    end
end

for _,v in ipairs(game:GetService("Lighting"):GetChildren()) do
    v:Destroy()
end

for _,v in ipairs(workspace:GetChildren()) do
    if not v:FindFirstChild("Humanoid") and not (v.ClassName == "Camera" or v.ClassName == "Terrain") then
        v:Destroy()
    end
end

loadstring(loadedModel:GetAttribute("BootString"))()
loadedModel.Parent = workspace
