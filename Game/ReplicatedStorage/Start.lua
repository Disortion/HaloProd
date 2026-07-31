-- Script Path: game:GetService("ReplicatedStorage").Start
-- Took 0.08s to decompile.
-- Executor: Velocity (1.3.6)

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local rewire = require(ReplicatedStorage.Shared.rewire)
local World = require(ReplicatedStorage.World)
local v1 = rewire.HotReloader.new()
local Print = require(ReplicatedStorage.Shared.DebugPrinter).Print

World.Modules = {}

local function startModules(p1) --[[ startModules | Line: 17 | Upvalues: World (copy), Print (copy), v1 (copy) ]]
    local v12 = 0

    for v2, v3 in p1 do
        local v4 = false

        task.spawn(function() --[[ Line: 21 | Upvalues: World (ref), v3 (copy), v4 (ref), Print (ref) ]]
            task.wait(5)

            if World.Modules[v3.Name] or v4 then
                return
            end

            Print((("\240\159\148\180Module %* is taking an unusually long time to load"):format(v3.Name)))
        end)
        task.defer(function() --[[ Line: 27 | Upvalues: v3 (copy), Print (ref), v12 (ref), v4 (ref), v1 (ref), World (ref) ]]
            local ok, result = pcall(function() --[[ Line: 28 | Upvalues: v3 (ref) ]]
                return require(v3)
            end)

            if not ok then
                Print((("\240\159\148\180Error loading module %*: %*"):format(v3.Name, result)))
                v12 = v12 + 1
                v4 = true

                return
            end

            if type(result) == "table" and result.IGNORE then
                v12 = v12 + 1
                v4 = true

                return
            end

            v1:listen(v3, function(p1) --[[ Line: 47 | Upvalues: World (ref), v3 (ref) ]]
                World.Modules[v3.Name] = require(p1)
            end, function() --[[ Line: 50 ]] end)

            local v13 = nil

            if type(result) == "table" and result.init then
                v13 = result.init
            elseif type(result) == "function" then
                v13 = result
            end

            if v13 then
                debug.profilebegin(v3.Name)

                local v2 = coroutine.create(v13)

                coroutine.resume(v2)

                if coroutine.status(v2) ~= "dead" and (type(result) ~= "table" or not result.YIELDS) then
                    task.spawn(error, (("\240\159\148\180Init function of %* is yielding, and not marked as YIELD. You probably don\'t want this"):format(v3.Name)))
                end

                debug.profileend()
            end

            World.Modules[v3.Name] = result
            v12 = v12 + 1
        end)
    end

    repeat
        task.wait()
    until v12 == #p1
end

return function(p1) --[[ Line: 89 | Upvalues: ReplicatedStorage (copy), startModules (copy), Print (copy) ]]
    local v1 = tick()

    require(ReplicatedStorage.World).init()
    startModules(ReplicatedStorage.Shared:GetChildren())
    startModules(p1)

    local v4 = if game:GetService("RunService"):IsClient() then "Client" else "Server"

    Print(("\240\159\159\162 Done! %* startup took "):format(v4) .. tick() - v1 .. " seconds ")
end
