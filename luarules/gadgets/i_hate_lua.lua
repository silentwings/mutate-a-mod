function gadget:GetInfo()
    return {
        name      = "Horsey McHorse",
        desc      = "furry dongles",
        author    = "",
        date      = "",
        license   = "yes",
        layer     = 0,
        enabled   = true
    }
end


if not gadgetHandler:IsSyncedCode() then
    return false
end

local loveCEGs = {
    "red_pop",
    "red_pop2",
    "red_pop3",
    "red_pop4",
}

local specialUnits = {
    -- mushrooms
    ["bigmushroom"]=true, ["bombmushroom"]=true, ["mushroomcluster"]=true, ["normalmushroom"]=true, ["poisonmushroom"]=true, ["smallmushroom"]=true,
    -- trees
    ["treelevel1"]=true, ["treelevel2"]=true, ["treelevel3"]=true,
    -- flowers & grass
    ["flower1"]=true, ["flower2"]=true, ["flower3"]=true, ["flower4"]=true, ["flower5"]=true,
    ["grass1"]=true, ["grass2"]=true, ["grass3"]=true, ["grass4"]=true, ["grass5"]=true, 
}

local function SampleFromArrayTable(t)
    if #t==0 then Spring.Echo("sampling from empty table") end
    local n = #t
    local m = 1+math.floor(math.random()*n)
    return t[m]
end

function gadget:Initialize()
end

function RandomCEG(x,y,z, r,h, t)
    local ceg = SampleFromArrayTable(t)
	Spring.SpawnCEG(ceg, x, y+h, z, 0, 2, 0, 10,10);
end

function Birth(unitID)
    local r = Spring.GetUnitRadius(unitID)
    local h = Spring.GetUnitHeight(unitID)
    local x,_,z = Spring.GetUnitPosition(unitID)
    local y = Spring.GetGroundHeight(x,z)

    RandomCEG(x,y,z, r,h, loveCEGs)
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

