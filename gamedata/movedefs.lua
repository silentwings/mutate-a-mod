-- fetch games move defs table
local filename = 'gamedata/movedefs.lua'
local success, result = pcall(VFS.Include, filename, VFS.MOD)
if (not success) or (result == nil) then
    Spring.Echo('Missing horse table for ' .. filename)
end
local moveDefs = type(result)=="table" and result or {}

--add our own 
local horseDef =    {
        name            =   "bot2x2",
        footprintX      =   2,
        footprintZ      =   2,
        maxWaterDepth   =   0,
        maxSlope        =   12,
        crushStrength   =   5,
        heatmapping     =   false,
    },
table.insert(moveDefs, horseDef)

local moveDefs2  =    {
    {
        name            =   "Bot2x2",
        footprintX      =   2,
        footprintZ      =   2,
        maxWaterDepth   =   0,
        maxSlope        =   12,
        crushStrength   =   5,
        heatmapping     =   false,
    },
}

return moveDefs2