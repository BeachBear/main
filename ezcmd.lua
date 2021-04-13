local module = {}
local plrs = game:GetService("Players")
local plr = plrs.LocalPlayer


function module.new(name, prefix, seperator)
    local name, prefix, seperator = name, prefix or "/", seperator or ";;"
    local newFramework = { Commands = {}, Connections = {} }


    function newFramework:GetPrefix()
        return prefix
    end
    function newFramework:SetPrefix(newPrefix)
        if (newPrefix) then
            prefix = newPrefix
        end
    end


    function newFramework:GetSeperator()
        return seperator
    end
    function newFramework:SetSeperator(newSeperator)
        if (newSeperator) then
            seperator = newSeperator
        end
    end


    function newFramework:NewConnection(connection, toBind)
        self.Connections[#self.Connections + 1] = connection:Connect(toBind)
    end


    function newFramework:NewCommand(config)
        local name = config["Name"]
        local aliases = config["Aliases"] or {}
        local description = config["Description"] or "This is a default command description."
        local seperateArgs = config["SeperateArgs"] == nil and true or config["SeperateArgs"]
        local run, unrun = config["Invoked"], config["UnInvoked"] or nil

        local command = {
            Toggled = false;
            Logic = function(t, args)
                if (unrun) then
                    t.Toggled = not t.Toggled

                    if (t.Toggled) then
                        t.Run(args, t)
                    else
                        t.Unrun(args, t)
                    end
                else
                    t.Run(args, t)
                end
            end;

            Description = description;
            SeperateArgs = seperateArgs;
            Run = run;
            Unrun = unrun;
        }

        self.Commands[name] = command
        for _,v in ipairs(aliases) do
            if (v ~= name) then
                self.Commands[v] = command
            end
        end
    end


    function newFramework.DigestString(str, includePrefix)
        includePrefix = includePrefix == nil and true or includePrefix
        local commands = str:split(seperator)

        for i, cmdLine in ipairs(commands) do
            local lineSplit = cmdLine:split(" ")

            local function sepArgs(foundCmd)
                if (foundCmd.SeperateArgs == false) then
                    coroutine.wrap(foundCmd.Logic)(foundCmd, cmdLine:sub(#lineSplit[1] + 1))
                else
                    local args = { unpack(lineSplit) }
                    table.remove(args, 1)
                    
                    coroutine.wrap(foundCmd.Logic)(foundCmd, args)
                end
            end

            if (includePrefix) then
                if (lineSplit[1]:sub(1, #prefix) == prefix) then
                    local foundCmd = newFramework.Commands[lineSplit[1]:sub(#prefix + 1)]; if (foundCmd) then
                        sepArgs(foundCmd)
                    end
                end
            else
                local foundCmd = newFramework.Commands[lineSplit[1]]; if (foundCmd) then
                    sepArgs(foundCmd)
                end
            end
        end
    end

    
    if (module[name]) then
        for _, v in ipairs(module[name].Connections) do
            v:Disconnect()
        end
    end

    module[name] = newFramework
    return newFramework
end


function module:GetPlayerFromString(str)
    str = str:lower()

    if (str == "me") then
        return plr
    elseif (str == "rand" or str == "random") then
        local list = plrs:GetPlayers()
        return list[math.random(1, #list)]
    end

    for _, p in ipairs(plrs:GetPlayers()) do
        if p.Name:lower():sub(1, #str) == str then
            return p
        end
    end

    return nil
end


getgenv().ezcmd = module
return module
