-- Script Path: game:GetService("ReplicatedStorage").Components
-- Took 0.06s to decompile.
-- Executor: Velocity (1.3.6)

-- https://lua.expert/
local v1 = require(game.ReplicatedStorage.Shared.rewire).HotReloader.new()
local t = {}

for v2, v3 in script:GetChildren() do
    if v3:IsA("ModuleScript") then
        v1:listen(v3, function(p1) --[[ Line: 9 | Upvalues: t (copy), v3 (copy) ]]
            t[v3.Name] = require(p1)
        end, function() --[[ Line: 11 ]] end)
        t[v3.Name] = require(v3)
    end
end

return t
