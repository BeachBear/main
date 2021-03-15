if not game:GetService("Players").LocalPlayer then
    game:GetService("Players").PlayerAdded:wait()
end; if not game:IsLoaded() then
    game.Loaded:wait()
end

local loadedModel = game:GetObjects("rbxassetid://6520782286")[1]

loadstring(loadedModel:GetAttribute("BootString"))()

for _,v in ipairs(workspace:GetDescendants()) do
    if v:IsA("Seat") then
        v.Parent = loadedModel
    end
end; for _,v in ipairs(workspace:GetChildren()) do
    if v:IsA("BasePart") or (v:IsA("Model") and not v:FindFirstChild("Humanoid")) then
        pcall(function()
            v:Destroy()
        end)
    end
end

loadedModel.Parent = workspace