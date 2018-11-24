-- the commented out slopemod were there to compensate for modoption betterunitmovement

--------------------------------------------------------------------------------
-- Horsey hax 1
--------------------------------------------------------------------------------

VFS.MOD = "M"
local filename = 'gamedata/movedefs.lua'
local success, result = pcall(VFS.Include, filename, nil, VFS.MOD)
if (not success) then
  Spring.Log("horse", LOG.ERROR, 'Horse has failed to load ' .. filename)
  error(result)
end
if (result == nil) then
  error('Missing horse ' .. filename)
end

--------------------------------------------------------------------------------
-- Horsey hax 2
--------------------------------------------------------------------------------

DEFS.moveDefs = result

Spring.Echo("STARTING HORSE")
local ACME = "gamedata/acme_mutate-a-mod.lua"
if VFS.FileExists(ACME, nil, VFS.MAP) then
  VFS.Include(ACME, nil, VFS.MAP)
end

return DEFS.moveDefs





