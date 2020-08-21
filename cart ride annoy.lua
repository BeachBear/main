local function hook(cart)
    pcall(function()
        cart:WaitForChild("On")
        cart.On:WaitForChild("Click")

        cart:WaitForChild("Configuration")
        local onValue = cart.Configuration:WaitForChild("CarOn")

        if onValue.Value == true then
            fireclickdetector(cart.On.Click, math.random(50,100) / 100)
        end
        onValue:GetPropertyChangedSignal("Value"):Connect(function()
            if onValue.Value == true then
                fireclickdetector(cart.On.Click, math.random(50,100) / 100)
            end
        end)
    end)
end

local cartFolder
for _,v in pairs(workspace:GetChildren()) do if v.Name == "Carts" and not v:FindFirstChildOfClass("Part") then cartFolder = v end end

for _,cart in pairs(cartFolder:GetChildren()) do
    if string.find(cart.Name:lower(), "cart") then hook(cart) end
end
cartFolder.ChildAdded:Connect(function(child)
    if string.find(child.Name:lower(), "cart") then hook(child) end
end)