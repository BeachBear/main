local ezcmd = {}

function ezcmd.new(name, prefix, seperator)
    name = name or "DefaultCommands"
    prefix = prefix or "/"
    seperator = seperator or ";;"

    local newFramework = {
        Prefix = prefix;
        Seperator = seperator;
        Commands = {};
        CommandInfo = {};
        Connections = {};
    }

    function newFramework:CreateCommand(config)
        local name, aliases, description = config["Name"], config["Aliases"] or {}, config["Description"] or "This is a default command description."
        local run, unrun = config["OnCall"], config["UnCall"] or nil
        local seperateArgs = config["SeperateArgs"] == nil and true or config["SeperateArgs"]

        local command = {
            SeperateArgs = seperateArgs;
            Toggled = false;
            Logic = function(t, args)
                if (unrun) then
                    t.Toggled = not t.Toggled

                    if (t.Toggled) then
                        t.Run(args)
                    else
                        t.Unrun(args)
                    end
                else
                    t.Run(args)
                end
            end;

            Description = description;
            Run = run;
            Unrun = unrun;
        }

        newFramework.Commands[name] = command
        newFramework.CommandInfo[#newFramework.CommandInfo + 1] = {
            Name = name;
            Description = description;
        }
        for _,v in ipairs(aliases) do
            if (v ~= name) then
                newFramework.Commands[v] = command
            end
        end
    end

    function newFramework:NewConnection(connection, func)
        newFramework.Connections[#newFramework.Connections + 1] = connection:Connect(func)
    end

    function newFramework:SetPrefix(newPrefix)
        if (newPrefix) then
            prefix = newPrefix
            getgenv[name].Prefix = newPrefix
        end
    end

    function newFramework:GetPrefix()
        return prefix
    end

    function newFramework:SetSeperator(newSeperator)
        if (newSeperator) then
            seperator = newSeperator
            getgenv[name].Seperator = newSeperator
        end
    end

    function newFramework:GetSeperator()
        return seperator
    end

    function newFramework:ExecuteCommand(cmd, args)
        local entry = newFramework.Commands[cmd]; if (entry) then
            entry.Logic(entry, args)
        end
    end

    function newFramework.DigestString(str, includePrefix)
        includePrefix = includePrefix or true
        local commands = str:split(seperator)

        for i, cmdLine in ipairs(commands) do
            local lineSplit = cmdLine:split(" ")

            if (includePrefix) then
                if (lineSplit[1]:sub(1, #prefix) == prefix) then
                    local foundCmd = newFramework.Commands[lineSplit[1]:sub(#prefix + 1)]; if (foundCmd) then
                        if (foundCmd.SeperateArgs == false) then
                            foundCmd.Logic(foundCmd, cmdLine:sub(#lineSplit[1] + 1))
                        else
                            local args = {unpack(lineSplit)}
                            table.remove(args, 1)
                            
                            foundCmd.Logic(foundCmd, args)
                        end
                    end
                end
            else
                local foundCmd = newFramework.Commands[lineSplit[1]]; if (foundCmd) then
                    if (foundCmd.SeperateArgs == false) then
                        foundCmd.Logic(foundCmd, cmdLine:sub(#lineSplit[1] + 1))
                    else
                        local args = {unpack(lineSplit)}
                        table.remove(args, 1)
                        
                        foundCmd.Logic(foundCmd, args)
                    end
                end
            end
        end
    end

    if getgenv()[name] then
        for _, v in ipairs(getgenv()[name].Connections) do
            v:Disconnect()
        end
        table.clear(getgenv()[name])
    end
    getgenv()[name] = newFramework
    return newFramework
end

getgenv().ezcmd = ezcmd
return ezcmd
