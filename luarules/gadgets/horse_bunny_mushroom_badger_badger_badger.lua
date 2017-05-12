function gadget:GetInfo()
    return {
        name      = "Ape Ape McGiblet",
        desc      = "furry balls",
        author    = "",
        date      = "",
        license   = 42,
        layer     = 0,
        enabled   = true
    }
end


if not gadgetHandler:IsSyncedCode() then
    return false
end

local mapOptions = Spring.GetMapOptions()
if mapOptions.horsetastic=="0" then 
    Spring.Echo("HORSE MODE HAS FALLEN OVER, AGAIN")
    return "sensible horse"
end


local VERBOSE = false
local gaiaTeamID = Spring.GetGaiaTeamID()

local minProximity = 50
local maxUnits = 110 
local midUnits = 60
local minUnits = 30
local resampleWantedUnits = (30*60)*8 -- in gameframes 

local minUnitHeight = 2
local maxUnitHeight = 85

local mushroomIdleSeconds = VERBOSE and 1 or 50 
local mushroomWalkSeconds = VEBOSE and 1 or 10 
local unitCreationIdleSeconds = VERBOSE and 1 or 4

local wantedUnits = 0

local units = {}
local mushrooms = {}

local toKill = {}


local mushroomTypes = {
    -- mushrooms
    "bigmushroom", "mushroomcluster", "normalmushroom", "poisonmushroom", "smallmushroom", -- bombmushroom, kingmushroom  
    "critter_penguin",
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
    if VERBOSE then Spring.Echo("mushroom " .. tostring(uID) .. " trying to run away from unit " .. tostring(eID)) end
    if eID then
        local cx,cy,cz = Spring.GetUnitPosition(uID)
        local x,y,z = Spring.GetUnitPosition(eID)
        local r = math.sqrt((x-cx)^2+(y-cy)^2+(z-cz)^2)
        local nx, ny, nz = (cx-x)/r, (cy-y)/r, (cz-z)/r --unit normal vector in perpendicular direction to eID
        local s = 200
        local px, py, pz = nx*s, ny*s, nz*s
        local gy = Spring.GetGroundHeight(px,pz)
        if not gy or gy<0 then 
            if VERBOSE then Spring.Echo("mushroom " .. tostring(uID) .. " is not running", px, gy, pz) end
            return 
        end
        Spring.GiveOrderToUnit(uID, CMD.MOVE, {px,gy,pz}, {})
        mushrooms[uID] = "run"
    end
    return
end

function gadget:UnitDamaged(unitID, unitDefID, unitTeam, damage, paralyzer, weaponDefID, projectileID, attackerID, attackerDefID, attackerTeam)
    if mushrooms[unitID] and mushrooms[unitID]~="run" and Spring.ValidUnitID(unitID) and math.random()<0.9 then
        RunAway(unitID)
        return
    end
end

local function GoForAWalk(uID)
    if VERBOSE then Spring.Echo("mushroom " .. tostring(uID) .. " going for a walk") end
    local x,y,z = Spring.GetUnitPosition(uID)
    local theta = math.random(1,360) / 360 * (2*math.pi)
    local dx, dz = 512*math.sin(theta), 512*math.cos(theta)
    local nx, ny, nz = x+dx, Spring.GetGroundHeight(x+dx,z+dz), z+dz
    if ny==nil or ny<0 then  
        if VERBOSE then Spring.Echo("mushroom " .. tostring(uID) .. " is not going for a walk", nx, ny, nz) end
        return
    end
    if VERBOSE then Spring.Echo("mushroom " .. tostring(uID) .. " is going for a walk", nx, ny, nz) end
    Spring.GiveOrderToUnit(uID, CMD.MOVE, {nx,ny,nz}, {})    
end

local function GoForASaunter(uID)
    if VERBOSE then Spring.Echo("mushroom " .. tostring(uID) .. " going for a saunter") end
    local x,y,z = Spring.GetUnitPosition(uID)
    local theta = math.random()*2*math.pi
    local r = math.random()*250
    local dx, dz = r*math.sin(theta), r*math.cos(theta)
    local nx, ny, nz = x+dx, Spring.GetGroundHeight(x+dx,z+dz), z+dz
    if ny==nil or ny<0 then  
        if VERBOSE then Spring.Echo("mushroom " .. tostring(uID) .. " is not going for a saunter", nx, ny, nz) end
        return
    end
    if VERBOSE then Spring.Echo("mushroom " .. tostring(uID) .. " is going for a saunter", nx, ny, nz) end
    Spring.GiveOrderToUnit(uID, CMD.MOVE, {nx,ny,nz}, {})    
end

local function DoALittleJump(uID)
    -- might help them get unstuck sometimes, probably not but wth
    -- does hilarious things to penguins
    if VERBOSE then Spring.Echo("mushroom " .. tostring(uID) .. " is jumping for the skies") end
    local dx = 0
    local dz = 0
    local dy = math.random()*math.random()*9
    Spring.AddUnitImpulse(uID, dx,dy,dz, 0.05)
end

local function AlluhaAkbar(uID)
    Spring.DestroyUnit(uID, true, false)
end

local function ChaseAfterSomething(uID)
    local eID = Spring.GetUnitNearestEnemy(uID)
    if VERBOSE then Spring.Echo("mushroom " .. tostring(uID) .. " trying to chase unit " .. tostring(eID)) end
    if eID then
        local cx,cy,cz = Spring.GetUnitPosition(uID)
        local x,y,z = Spring.GetUnitPosition(eID)
        local r = math.min(200, math.sqrt((x-cx)^2+(y-cy)^2+(z-cz)^2))
        local theta = math.random()*2*math.pi
        local px,pz = x+r*math.sin(theta),y+r*math.cos(theta)
        local gy = Spring.GetGroundHeight(px,pz)
        if not gy  or gy<0 then 
            if VERBOSE then Spring.Echo("mushroom " .. tostring(uID) .. " is not running", px, gy, pz) end
            return 
        end
        Spring.GiveOrderToUnit(uID, CMD.MOVE, {px,gy,pz}, {})
        mushrooms[uID] = "chase"    
    end
    return
end

local function MushroomMotion(n)
    if VERBOSE then Spring.Echo("mushroom walkies") end
    for unitID,state in pairs(mushrooms) do
        if math.random()<1/6 and Spring.ValidUnitID(unitID) then
            -- we reach here on avg once per sec per mushroom
            if state=="walk" then
                GoForAWalk(unitID)
                if math.random()<1/mushroomWalkSeconds then mushrooms[unitID]="idle" end
            elseif state=="chase" then
                ChaseAfterSomething(unitID)
                if math.random()<1/mushroomWalkSeconds then mushrooms[unitID]="idle" end   
            else
                if math.random()<1/mushroomIdleSeconds then 
                    mushrooms[unitID] = (math.random()<0.1) and "chase" or "walk" 
                end
                if math.random()<2/mushroomWalkSeconds then
                    GoForASaunter(unitID)
                end
                if math.random()<1/mushroomIdleSeconds then
                    DoALittleJump(unitID)
                end
            end
        end    
        local _,y,_ = Spring.GetUnitPosition(unitID)
        if y<5 and math.random()<1/6 then
            toKill[unitID] = true
        end
    end    
end

local function Explosions(n)
    for unitID,_ in pairs(units) do
        if math.random()<1/6 and Spring.ValidUnitID(unitID) then
            if math.random()<1/150 then --/(4*mushroomWalkSeconds) then
                toKill[unitID] = true -- avoid removal during transversal because lua is massively hairy shit 
            end
        end
    end
    for unitID,_ in pairs(toKill) do
        AlluhaAkbar(unitID)
    end
    toKill = {}
end

-------------------------
-- create new units

local function RandomFacing()
	local n = math.random(4)
	if n==1 then return "north" end
	if n==2 then return "east" end
	if n==3 then return "west" end
	if n==4 then return "south" end
end

local function PlaceUnit(uDID, x,z, isMushroom)
    local f = RandomFacing()
    local y = Spring.GetGroundHeight(x,z)
    local unitID
    if y>0 then 
        unitID = Spring.CreateUnit(uDID, x, y, z, f, gaiaTeamID)
    end
    
    if unitID then
        units[unitID] = true
        if isMushroom then mushrooms[unitID]="idle" end
        if VERBOSE then Spring.Echo("created", uDID, x, z) end
    else
        if VERBOSE then Spring.Echo("unit creation failed") end
    end    
end

local function PlaceGrass(x, z)
    local unitName = SampleFromArrayTable(grassTypes)
    local uDID = UnitDefNames[unitName].id
    if VERBOSE then Spring.Echo("trying to place grass") end
    PlaceUnit(uDID, x, z)
end

local function PlaceMushroom(x, z)
    local unitName = SampleFromArrayTable(mushroomTypes)
    local uDID = UnitDefNames[unitName].id
    if VERBOSE then Spring.Echo("trying to place mushroom") end
    PlaceUnit(uDID, x, z, true)
end

local function PlaceTree(x, z)
    local unitName = SampleFromArrayTable(treeTypes)
    local uDID = UnitDefNames[unitName].id
    if VERBOSE then Spring.Echo("trying to place tree") end
    PlaceUnit(uDID, x, z)
end

local function PlaceGrassCluster(n, r, cx, cy)
    if VERBOSE then Spring.Echo("trying to place grass cluster") end
    for i=1,n do
        local theta = math.random()*2*math.pi
        local s = r * (1-0.9*math.random())
        local x = cx + s*math.cos(theta)
        local y = cy + s*math.sin(theta)
        PlaceGrass(x,y)
    end
    if math.random()<0.25 then
        PlaceTree(cx,cy)
    end 
 end

local function SampleLocation ()
    local maxTries = 20
    for i=1,maxTries do
        x = math.random() * Game.mapX * 512
        z = math.random() * Game.mapY * 512
        y = Spring.GetGroundHeight(x,z)
        if y>minUnitHeight and y< maxUnitHeight then
            local closeUnits = Spring.GetUnitsInCylinder(x,z,100)
            if #closeUnits==0 then
                return x,z
            end               
        end
    end
end

local function PlaceRandom(cx, cy)
    unitType = SampleUnitType()
    local x,z = SampleLocation()
    if not x or not z then return end
    if unitType=="grass" then 
        local n = math.random(3,6)
        PlaceGrassCluster(n, 100, x, z)
    elseif unitType=="tree" then PlaceTree(x,z)
    elseif unitType=="mushroom" then PlaceMushroom(x,z) end
end

function CheckCreateUnits() 
    if countTable(units) > wantedUnits then return end
    if VERBOSE then Spring.Echo("unit creation check: have " .. tostring(countTable(units)) .. ", want " .. tostring(wantedUnits)) end 
    
    if math.random()<1/unitCreationIdleSeconds then
        if VERBOSE then Spring.Echo("trying to create random unit") end
        PlaceRandom() 
    end
end

local function ResampleWantedUnits ()
    if math.random()<0.5 then 
        wantedUnits = midUnits + math.random()*(maxUnits-midUnits)
    else
        wantedUnits = minUnits + math.random()*(midUnits-minUnits)
    end
    if VERBOSE then Spring.Echo("new wanted units: " .. tostring(wantedUnits)) end
end

-------------------------

function gadget:Initialize()
end

function gadget:UnitCreated(unitID, unitDefID)
    if not UnitDefs[unitDefID].customParams.mushroom then return end
    units[unitID] = true
    mushrooms[unitID]="idle"
    if VERBOSE then Spring.Echo("adopted", unitDefID, x, z) end
end

function gadget:UnitDestroyed(unitID)
    units[unitID]=nil
    mushrooms[unitID]=nil
end

function gadget:GameFrame(n)
    if n%5==0 then
        MushroomMotion()
        Explosions()
    end
    
    if n%30~=0 then return end    
    if n%resampleWantedUnits==0 then ResampleWantedUnits() end

    CheckCreateUnits()
end