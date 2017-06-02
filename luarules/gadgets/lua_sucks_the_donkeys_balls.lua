function gadget:GetInfo()
    return {
        name      = "rawr",
        desc      = "its so furry",
        author    = "",
        date      = "",
        license   = "squirrel",
        layer     = 0,
        enabled   = true
    }
end


if not gadgetHandler:IsSyncedCode() then
    return HorseyMcHorseTasticBurgerZOMGILOVEHORSE
end


local loveCEGs = {
    "red_pop",
    "red_pop2",
    "red_pop3",
    "red_pop4",
}

local specialUnits = {
    -- mushrooms
    ["ve_chickenq"]=true,
    ["e_chickenq"]=true,
    ["n_chickenq"]=true,
    ["h_chickenq"]=true,
    ["vh_chickenq"]=true,
    ["epic_chickenq"]=true,
}

local cegLocations = {}


local function SampleFromArrayTable(t)
    if #t==0 then Spring.Echo("sampling from empty table") end
    local n = #t
    local m = 1+math.floor(math.random()*n)
    return t[m]
end

function gadget:Initialize()
end

function RandomCEG(x,y,z, r,h, t)
    local rx = r*(2*math.random()-1)
    local rz = r*(2*math.random()-1)
    local ry = 50*math.random()
    local ceg = SampleFromArrayTable(t)
    Spring.SpawnCEG(ceg, x+rx, y+h+ry, z+rz, 0, 2+math.random(), 0, 10,10)
end

function Birth(unitID)
    local r = Spring.GetUnitRadius(unitID) 
    local h = Spring.GetUnitHeight(unitID)
    local x,_,z = Spring.GetUnitPosition(unitID)
    local y = Spring.GetGroundHeight(x,z)

    cegLocations[#cegLocations+1] = {x=x,y=y,z=z,r=r*2,h=h,t=loveCEGs, n=math.random(2,5), count=0}
    for i=1,3 do
        RandomCEG(x,y,z, r,h, loveCEGs)
    end
end

function gadget:UnitCreated(unitID, uDID)
    if not specialUnits[UnitDefs[uDID].name] then return end    
    Birth(unitID)
    if math.random()<0.05 then 
        Spring.SetUnitStealth(unitID, true) -- lol
        Spring.SetUnitSonarStealth(unitID, true)
    end 
    Spring.SetUnitNeutral(unitID, true) -- don't allow attack (it's fuxxored and horse knows why)
    Spring.SetUnitBlocking(unitID, true, true, true, true, false, false, false) -- horses
end

function Death(unitID)
    local r = Spring.GetUnitRadius(unitID)
    local h = Spring.GetUnitHeight(unitID)
    local x,z = Spring.GetUnitPosition(unitID)
    local y = Spring.GetGroundHeight(x,z)
end

function gadget:UnitDestroyed(unitID, uDID)
    if not specialUnits[UnitDefs[uDID].name] then return end
    Death(unitID)
end

function gadget:GameFrame(n)
    if (n%4~=0) then return end
    
    for _,c in pairs(cegLocations) do
        if math.random()<0.5 then
            RandomCEG(c.x,c.y,c.z, c.r,c.h, c.t)
            c.count = c.count + 1               
        end
    end
    
    for k,c in pairs(cegLocations) do
        if c.count>=c.n then cegLocations[k]=nil end 
    end
end


