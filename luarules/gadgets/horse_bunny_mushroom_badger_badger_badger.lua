function gadget:GetInfo()
    return {
        name      = "Ape Ape McGiblet",
        desc      = "fur balls",
        author    = "",
        date      = "",
        license   = 42,
        layer     = "horse",
        enabled   = false
    }
end


if not gadgetHandler:IsSyncedCode() then
    return false
end

local minProximity = 50
local maxUnits = 60 -- hard limit
local midUnits = maxUnits/2
local minUnits = 1
local resampleWantedUnits = (30*60)*8 -- in gameframes 

local mushroomIdleFrames = (30*60)*0.5 
local unitCreationIdleFrames = (30)*10 

local initialUnits = maxUnits * (0.5*math.random + 0.75)
local wantedUnits = 0

local units = {}
local mushrooms = {}
-- units[unitID] = {dynamic=, x=,y=,z=, explosion=}


local unitTypes = {
    -- mushrooms
    "bigmushroom", "bombmushroom", "mushroomcluster", "normalmushroom", "poisonmushroom", "smallmushroom",
}
local treeTypes = {
    -- trees
    "treelevel1", "treelevel2", "treelevel3",
}
local grassTypes = {
    -- flowers & grass
    "flower1", "flower2", "flower3", "flower4", "flower5",
    "grass1", "grass2", "grass3", "grass4", "grass5", 
}

local pGrass = 0.5
local pTree = 0.25
local pMushroom = 0.25
local function SampleUnitType()
    local p = math.random()
    if p<pGrass then return "grass"
    elseif p<pGrass+pTree then return "tree"
    else return "mushroom" end
end

local function SampleFromArrayTable(t)
    local n = #t
    local m = 1+math.floor(math.random()*n)
    return t[m]
end

local function countTable(t)
    local n = 0
    for k,_ in pairs(t) do
        n = n + 1
    end
    return n
end


-------------------------
-- mushroom motion


local function RunAway(uID)
    local eID = Spring.GetUnitNearestEnemy(uID)
    if eID then
        local cx,cy,cz = Spring.GetUnitPosition(cID)
        local x,y,z = Spring.GetUnitPosition(eID)
        local r = math.sqrt((x-cx)^2+(y-cy)^2+(z-cz)^2)
        local nx, ny, nz = (cx-x)/r, (cy-y)/r, (cz-z)/r --unit normal vector in perpendicular direction to eID
        local s = 200
        local px, py, pz = nx*s, ny*s, nz*s
        Spring.GiveOrderToUnit(cID, CMD.MOVE, {px,py,pz}, {})
    end
    return
end

function gadget:UnitDamaged(unitID, unitDefID, unitTeam, damage, paralyzer, weaponDefID, projectileID, attackerID, attackerDefID, attackerTeam)
    if mushrooms[unitID] and Spring.ValidUnitID(unitID) and math.random()<0.5 then
        RunAway(unitID)
        return
    end
end

local function GoForAWalk(cID)
    local x,y,z = Spring.GetUnitPosition(cID)
    local theta = math.random(1,360) / 360 * (2*math.pi)
    local dx, dz = 512*math.sin(theta), 512*math.cos(theta)
    local nx, ny, nz = x+dx, Spring.GetGroundHeight(x+dx,z+dz), z+dz
    Spring.GiveOrderToUnit(cID, CMD.MOVE, {nx,ny,nz}, {})    
end

local function MushroomMotion()
    for unitID,_ in pairs(mushrooms) do
        if math.random()<1/(mushroomIdleFrames) and Spring.ValidUnitID(unitID) then
            GoForAWalk(unitID)
        end    
    end    
end

-------------------------
-- create new units

local function PlaceUnit(uDID, x,y)
    -- effects and unit creation
    -- TODO
end

local function PlaceGrass(x, y)
    local unitName = SampleFromArrayTable(grass)
    local uDID = UnitDefNames[unitName].id
    PlaceUnit(uDID, x, y)
end

local function PlaceStaticCluster(n, r, cx, cy)
    -- todo
end

local function PlaceMushroom(x, y)
    local unitName = SampleFromArrayTable(mushroom)
    local uDID = UnitDefNames[unitName].id
    PlaceUnit(uDID, x, y)
end

local function PlaceTree(x, y)
    local unitName = SampleFromArrayTable(tree)
    local uDID = UnitDefNames[unitName].id
    PlaceUnit(uDID, x, y)
end

local function SampleLocation ()
    -- TODO
    return x,y
end

local function PlaceRandom(cx, cy)
    unitType = SampleUnitType()
    local x,y = SampleLocation()
    if unitType=="grass" then 
        local n = math.random(3,6)
        PlaceStateCluster(n, 100, x, y)
    elseif unitType=="tree" then PlaceTree()
    elseif unitType=="mushroom" then PlaceMushroom() end
end

function CheckCreateUnits() 
    if countTable(units) > wantedUnits then return end
    
    if math.random()<1/unitCreationIdleFrames then
        PlaceRandom() 
    end
end

function CreateInitial()

end

local function ResampleWantedUnits = {}
    if math.random()<0.5 then 
        wantedUnits = midUnits + math.random()*(maxUnits-midUnits)
    else
        wantedUnits = minUnits + math.random()*(midUnits-minUnits)
    end
end

-------------------------

function gadget:Initialize()
end

function gadget:UnitDestroyed()
    units[unitID]=nil
    mushrooms[unitID]=nil
end

function gadget:GameFrame(n)
    if n%30~=0 then return end
    
    if n%resampleWantedUnits==0 then ResampleWantedUnits() end
    
    CreateNew()
    MushroomMotion()
end