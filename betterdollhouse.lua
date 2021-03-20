if game.PlaceId ~= 417267366 then
    return
end
if not game:GetService("Players").LocalPlayer then
    game:GetService("Players").PlayerAdded:wait()
end
if not game:IsLoaded() then
    game.Loaded:wait()
end
if getgenv().BDH_BUFFERING then
    return
end

getgenv().BDH_BUFFERING = true

local loadedModel = game:GetObjects("rbxassetid://6520782286")[1]

wait(0.06)

if BetterDollhouse then
    getgenv().BetterDollhouse.Buffering = true
    for _,save in ipairs(getgenv().BetterDollhouse.Save) do
        save.Parent = loadedModel
    end
else
    getgenv().BetterDollhouse = {
        Save = {};
        Buffering = true;
    }
    
    for _,v in ipairs(workspace:GetDescendants()) do
        if v.ClassName == "Seat" or v:FindFirstChild("TouchInterest") then
            v.Transparency = 1
            v.Parent = loadedModel
            getgenv().BetterDollhouse.Save[#getgenv().BetterDollhouse.Save+1] = v
        end
    end
end

wait(0.06)

game:GetService("Lighting"):ClearAllChildren()
for _,v in ipairs(workspace:GetChildren()) do
    if not v:FindFirstChild("Humanoid") and not (v.ClassName == "Camera" or v.ClassName == "Terrain") then
        v:Destroy()
    end
end

loadedModel.Parent = workspace
loadstring(loadedModel:GetAttribute("BootString"))()

wait()

getgenv().BDH_BUFFERING = nil
