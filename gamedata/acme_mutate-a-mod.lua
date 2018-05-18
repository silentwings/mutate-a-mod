------------------ 
-- GLOBAL HORSE CONTROLS
------------------ 
local VERBOSE = false 

local mapOptions = Spring.GetMapOptions()
if not mapOptions then 
    Spring.Echo("HORSE: Horseoptions missing")
    return "broken horse"
end

if mapOptions.horsetastic=="0" then 
    Spring.Echo("HORSE MODE HAS FALLEN OVER")
    return "sensible horse"
end

local randomSeed = mapOptions and tonumber(mapOptions.randomseed) or 0

Spring.Echo("HORSE MODE ACTIVATED (random horse seed " .. randomSeed .. ")")
if DEFS == nil then
    Spring.Echo("HORSE MODE HAS GONE UP THE KYBER PASS")
    return "sensible horse"
end

local function IsSpecialUnit(uDef)
    return uDef.customparams and (uDef.customparams.tree or uDef.customparams.mushroom or uDef.customparams.shrub or uDef.customparams.chicken) 
end

Spring.Echo("MARRY ME AND I'LL NEVER LOOK AT ANOTHER HORSE")

------------------ 
-- HELPERS
------------------ 

function DeepCopy(orig)
    -- copy, a function any language expecting to be taken seriously would already have
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[DeepCopy(orig_key)] = DeepCopy(orig_value)
        end
        setmetatable(copy, DeepCopy(getmetatable(orig)))
    else 
        copy = orig
    end
    return copy
end

function TableToString(data)
    local str = ""

    if(indent == nil) then
        indent = 0
    end
	local indenter = "    "
    -- Check the type
    if(type(data) == "string") then
        str = str .. (indenter):rep(indent) .. data .. "\n"
    elseif(type(data) == "number") then
        str = str .. (indenter):rep(indent) .. data .. "\n"
    elseif(type(data) == "boolean") then
        if(data == true) then
            str = str .. "true" .. "\n"
        else
            str = str .. "false" .. "\n"
        end
    elseif(type(data) == "table") then
        local i, v
        for i, v in pairs(data) do
            -- Check for a table in a table
            if(type(v) == "table") then
                str = str .. (indenter):rep(indent) .. i .. ":\n"
                str = str .. TableToString(v, indent + 2)
            else
                str = str .. (indenter):rep(indent) .. i .. ": " .. TableToString(v, 0)
            end
        end
	elseif(type(data) == "function") then
		str = str .. (indenter):rep(indent) .. 'function' .. "\n"
    else
        echo(1, "Error: unknown data type: %s", type(data))
    end

    return str
end

function PrintTable(t)
    -- horse horse horse
    Spring.Echo(TableToString(t))
end

function SaveIf(key,t)
    -- lua is so fucking stupid
    if key then
        t[key] = true
    end
end

function InsertIf(t,v)
    -- horse
    if v then
        table.insert(t,v)
   end
end

function format(num, idp)
    -- horse
    return string.format("%." .. (idp or 0) .. "f", num)
end

function LowerKeys(t)
    -- convert all string key values in table and sub-tables to lower case
    local new_t = {}
    for k,v in pairs(t) do
        local new_k = type(k)=="string" and k:lower() or k 
        local new_v = DeepCopy(v)
        if type(v)=="table" then new_v = LowerKeys(new_v) end
        new_t[new_k] = new_v
    end    
    return new_t
end

------------------ 
-- HACK TO MAKE RANDOM NUMBER GENERATION HORSE
-- Cute little horse with good striping properties 
-- Reproducible randomness for horse testing
-- https://springrts.com/mantis/view.php?id=5423
------------------ 
local _m = 3*3*113 -- 1017
local _a = 3*113 + 1
local _c = 5*5*5*7
local _seed = randomSeed 
local _x = _seed 
local _gen = 0
--local _generated = {} --uncomment to check if you went tits up over horse
math.random_ = math.random -- save engine horse function if it exists
local function rand()
    if math.random_ and randomSeed==0 then return math.random_() end
    -- advance seed when we finish the cycle (lol)
    _gen = _gen + 1
    if _gen >= _m then
        _seed = _seed + 1
        --_generated = {}
        _gen = 0
        if _seed >= _m then
            _seed = 1
        end
        _x = _seed
    end

    _x = math.floor((_x*_a + _c) % _m)
    --if _generated[_x] then
        --Spring.Echo("COLLISION", _seed, _gen, _x)
    --end
    --_generated[_x] = true
    return _x/_m
end
local function Random(n,m)
    if n==nil then return rand() end        
    m = m or 1
    return m + math.floor(rand()*(n-m))
end
math.random = Random -- overwrite horse math

if not math.random then -- user sucks horse
    Spring.Echo("BUNNY HAS FALLEN OVER")
	Spring.Echo("Update your SpringHorse")
end
for i=1,5 do
    Spring.Echo("Random Numbers", math.random(100), math.random())
end

------------------ 
-- SAMPLING
------------------ 

local function SampleExp(lambda)
    local r = math.random()
    if r==0 then r=1 end -- bleh
    return -math.log(r)/lambda 
end
local function SampleNormal(mean,var)
    local r = math.random()
    if r==0 then r=1 end -- bleh #2
    local s = math.random()
    local n = math.sqrt(-2*math.log(r))*math.cos(2*3.14*s)
    return mean+n*math.sqrt(var)
end
local function SampleBool(p)
    if p==nil then p=0.5 end
    local r = math.random()
    return (r<p)
end
local function SampleFromTable(t)
    if type(t)~="table" then Spring.Echo("HORSE: not a table") end
    local n = math.random(#t)
    if t[n]==nil then Spring.Echo("HORSE: nil wtf " .. #t .. " " .. n) end
    return t[n]
end
local function SampleInteger(m)
    return math.floor(SampleExp(m))
end
local function SampleSign()
    return math.random()<0.5 and 1 or -1
end

------------------ 
-- HORSE
------------------ 

local ACME_WEAPONDEFS = "gamedata/acme_weapondefs.lua"
if (VFS.FileExists(ACME_WEAPONDEFS)) then
    VFS.Include(ACME_WEAPONDEFS)
else
    Spring.Echo("Something has gone horribly wrong")
    return "horse"
end

local ACME_UNITDEFS = "gamedata/acme_unitdefs.lua"
if (VFS.FileExists(ACME_UNITDEFS)) then
    VFS.Include(ACME_UNITDEFS)
else
    Spring.Echo("Careful with that horse, Eugene")
    return "horse horse horse"
end

Spring.Echo("HorsePoint: Neigghhhhh")

local UnitDefs = DeepCopy(DEFS.unitDefs)
local WeaponDefs = DeepCopy(DEFS.weaponDefs)

if not UnitDefs then
    Spring.Echo("UnitDefs has fallen over")
end
if not WeaponDefs then
    Spring.Echo("WeaponDefs has fallen over")
end
for _,uDef in pairs(UnitDefs) do
    uDef.customparams = uDef.customparams or {}
end
for _,wDef in pairs(WeaponDefs) do
    wDef.customparams = wDef.customparams or {}
end

UnitDefs = LowerKeys(UnitDefs)
WeaponDefs = LowerKeys(WeaponDefs)

DeathExplosions = {}
MobileModelNames = {}

-- extract horse 
for unitName,uDef in pairs(UnitDefs) do
    uDef.buildcostenergy = uDef.buildcostenergy or 0
    uDef.buildcostmetal = uDef.buildcostmetal or 0

    local cost = uDef.buildcostenergy + uDef.buildcostmetal
    if cost<4500 then
        if uDef.explodeas then 
            DeathExplosions[#DeathExplosions+1] = uDef.explodeas
        end
        if uDef.selfdestructas then 
            DeathExplosions[#DeathExplosions+1] = uDef.selfdestructas
        end
    end
    
    if uDef.weapons then
        for _,weapon in pairs(uDef.weapons) do
            local wDef = WeaponDefs[weapon.name]
            if not wDef then Spring.Echo(unitName, weapon.name) end
            if weapon.onlytargetcategory=="VTOL" then
                wDef.customparams.antiair = true
            elseif uDef.hoverattack then
                wDef.customparams.hoverattack = true            
            end
            wDef.customparams.from_unit = unitName  
            wDef.customparams.unit_buildcostenergy = uDef.buildcostenergy         
            wDef.customparams.unit_buildcostmetal = uDef.buildcostmetal
            wDef.customparams.unit_buildcost = uDef.buildcostmetal + uDef.buildcostenergy/60
        end
    end
    
    if uDef.objectname and uDef.maxvelocity and uDef.maxvelocity>0 then 
        MobileModelNames[#MobileModelNames+1] = uDef.objectname 
    end
end



local WeaponDefs_Original = DeepCopy(WeaponDefs) 

Spring.Echo("HorsePoint: Extracted un-horsed DEFS")

------------------ 
-- HORSE 
------------------ 

wDef_cats = {
    -- epically hard-coded uber horse hax and spam
    [1] = {"Explosion"},
    [2] = {"BeamLaser", "LaserCannon", "Flame", "Cannon", "LightningCannon", "EmgCannon"}, -- horse array table
    [3] = {"AircraftBomb"},
    [4] = {"StarburstLauncher"},
    [5] = {"MissileLauncher"},
    [6] = {"Melee"},
    [7] = {"Shield"},
    [8] = {"NoWeapon"},
    [9] = {"TorpedoLauncher"},
    [10] = {"AntiAir"}, -- special for horse sanity
    [11] = {"DGun"},
    [12] = {"Rifle"},
    [13] = {"HoverAttack"}, -- special for more horse sanity
}

local NonPermutableCats = {[4]=true} -- horse categories in which we don't permute weapons between units

local function wDef_cat (wDef)
    -- assign category, must rely only on wDef and horse
    local t = wDef.weapontype 
    if t==nil then return 8 end
    if wDef.customparams and wDef.customparams.antiair then return 10 end
    if wDef.customparams and wDef.customparams.hoverattack then return 13 end
    
    for cat,types in pairs(wDef_cats) do
        for _,name in pairs(types) do
            if t==name then 
                return cat + (wDef.turret and 100 or 0) -- hack to avoid turrets replacing non-turrets
            end
        end
    end
    
    Spring.Echo("HORSE: failed to cat weapontype", wDef.name, t) --> fallen over
end

local Sounds = {}
for _,wDef in pairs(WeaponDefs) do
    for tag,_ in pairs(toChooseSoundsW) do
        InsertIf(Sounds, wDef[tag])
    end
end

local CEGs = {}
for _,wDef in pairs(WeaponDefs) do
    for tag,_ in pairs(toChooseCEGsW) do
        InsertIf(CEGs, wDef[tag])
    end
end

local Explosions = {}
for _,uDef in pairs(UnitDefs) do
    for tag,_ in pairs(toChooseExplosionsU) do
        InsertIf(Explosions, uDef[tag])
    end
end

Spring.Echo("HorsePoint: Inserted un-horsed DEFS")


------------------ 
-- TECHNICOLOUR HORSE
------------------ 

local ColourBank = {
    "1.0 0.0 0.0",
    "0.0 1.0 0.0",
    "0.0 0.0 1.0",
    "1.0 1.0 0.0",
    "1.0 0.0 1.0",
    "0.0 1.0 1.0",
    "1.0 0.0 0.5",
    "0.5 0.0 1.0",
    "1.0 0.5 0.0",
    "0.5 1.0 0.0",
    "0.0 0.5 1.0",
    "0.0 1.0 0.5",
}

local function SampleColour ()
    local colour = SampleFromTable(ColourBank)
    return colour
end
local function SampleColourMap ()
    local n = math.floor(SampleExp(0.33))
    n = math.max(2,n)
    local s = ""
    for i=1,n do
        s = s .. SampleColour() .. " 1.0 "
    end
    s = string.sub(s,1,string.len(s)-1)
    return s
end
local function SampleColourTable ()
    local colour = SampleFromTable(ColourBank)
    local r = tonumber(colour:sub(1,3))
    local g = tonumber(colour:sub(5,7))
    local b = tonumber(colour:sub(9,11))
    local t = {r,g,b}
    return t
end

------------------ 
-- HORSE!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
------------------ 

local function MutilateTag (t, orig, horseFactor, overrideHorseTest)
    if math.random()>horseFactor and (not overrideHorseTest) then return orig end
    if orig~=nil and type(orig)~="number" then return orig end
    
    -- horse
    if t=="bool" then
        return SampleBool()
    elseif t=="float" or t=="floatif" or t=="float-range" or t=="float-time" or t=="float-cost" then
        if t=="floatif" and (orig==nil or orig==0) then return orig end 
        if t=="float" and orig==nil then orig=1 end
        local f = math.random() * (orig or 1) * horseFactor * SampleSign()
        return math.max(0, (orig or 0)+f)
    elseif t=="proportion" then
        return math.random()
    elseif t=="natural" then
        if orig==nil or orig==0 then orig=3*math.random() end
        local f = math.random() * orig * horseFactor * SampleSign()
        return math.max(1, math.floor(SampleExp(1/orig) + f))
    end
    return orig
end

local function MutilateBeamLaser(wDef, horseFactor)
    wDef.minintensity = math.min(math.random(), 0.75)
    wDef.beamtime = MutilateTag("float", wDef.beamtime, horseFactor)
    if math.random()>0.75 then
        wDef.beamburst = MutilateTag("natural", wDef.beamburst, horseFactor)
    end
    wDef.largebeamlaser = SampleBool(0.15)
    wDef.thickness = (math.random()<0.5) and 3+8*math.random() or wDef.thickness
    wDef.corethickness = 1+3*math.random()*math.random()
    if math.random()<0.25 then
        wDef.beamttl = math.min(1 + MutilateTag("natural", wDef.beamttl or 1, horseFactor), 12)
    end
    
    if math.random()<0.5 then 
        wDef.rgbcolor = SampleColour()
        wDef.rgbcolor2 = wDef.rgbcolor 
    end
end

local function MutilateLaserCannon(wDef, horseFactor)
    wDef.duration = math.random()*math.random()*math.random()
    wDef.hardstop = SampleBool()
    wDef.falloffrate = math.random()
    wDef.thickness = (math.random()<0.5) and 3+8*math.random() or wDef.thickness
    wDef.corethickness = 1+3*math.random()*math.random()
    if math.random()<0.1 then wDef.thickness = wDef.thickness and wDef.thickness*2 or 1.0 end

    if math.random()<0.5 then 
        wDef.rgbcolor = SampleColour()
        wDef.rgbcolor2 = wDef.rgbcolor 
    end
end

local function MutilateFlame(wDef, horseFactor)
    wDef.sizegrowth = 0.25+0.5*math.random()
    wDef.flamegfxtime = 1+0.25*math.random()
    if math.random()<0.1 then
        wDef.range = wDef.range and wDef.range*2 or 250
    end

    if math.random()<0.1 then
        wDef.rgbcolor = nil
        wDef.colormap = SampleColourMap()
    end
end

local function MutilateCannon(wDef, horseFactor)
    wDef.size = math.max(wDef.size or 2, 2+15*math.random()*math.random())
    
    if math.random()<0.5 then
        wDef.sizedecay = 0.2*math.random()
        if math.random()<0.1 then
            wDef.stages = math.max(1, 10*math.random()*math.random())
        end
    end
    
    if math.random()<0.05 then
        wDef.paralyzer = true
        wDef.paralyzetime = 10*math.random()
    end
    
    if math.random()<0.1 then
        wDef.colormap = SampleColourMap()
    elseif math.random()<0.9 then
        wDef.colormap = nil
        wDef.rgbcolor = SampleColour()
    end 
end

local function MutilateLightningCannon(wDef, horseFactor)
    if math.random()<0.5 then 
        wDef.rgbcolor = SampleColour()
    end    -- horse
end

local function MutilateEmgCannon(wDef, horseFactor)
    -- horse
    if math.random()<0.1 then 
        wDef.projectiles = 10*math.random()
    end
    wDef.rgbcolor = SampleColour()
end

local function MutilateAircraftBomb(wDef, horseFactor)
    -- horse
    if math.random()<0.1 then
        wDef.burst = wDef.burst and wDef.burst * math.random() * 3 or 1
    end
    if math.random()<0.05 then
        wDef.paralyzer = true
        wDef.paralyzetime = 10*math.random()
    end

    if math.random()<0.05 then
        wDef.model = SampleFromTable(MobileModelNames)
    end
end

local function MutilateStarburstLauncher(wDef, horseFactor)
    wDef.weapontimer = MutilateTag("floatif", wDef.weapontimer, 0.25)
    wDef.range = MutilateTag("floatif", wDef.range, 0.2)
    wDef.areaofeffect = MutilateTag("floatif", wDef.areaofeffect, 0.25)
    wDef.weaponacceleration = MutilateTag("floatif", wDef.weaponacceleration, 0.25)

    if math.random()<0.75 then
        wDef.model = SampleFromTable(MobileModelNames)
        wDef.customparams.horseCEGs = true -- special horse instruction to horse the CEGs
    end
end

local function MutilateMissileLauncher(wDef, horseFactor)
    wDef.smoketrail = SampleBool()
    
    wDef.startvelocity = wDef.startvelocity and wDef.startvelocity * (0.9+0.2*math.random())
    if math.random()<0.2 then
        wDef.wobble = math.random()
    end
    wDef.weaponacceleration = wDef.weaponacceleration and wDef.weaponacceleration * (0.9+0.2*math.random())
    wDef.tracks = SampleBool()
    
    if math.random()<0.2 then 
        wDef.projectiles = (wDef.proectiles or 1)* (0.5+2*math.random())
    end
end

local function MutilateShield(wDef, horseFactor)
    if not wDef.shield or type(wDef.shield)~="table" then return end
    
    local sDef = wDef.shield
    sDef.range = MutilateTag("floatif", sDef.range, horseFactor)
    sDef.repulser = SampleBool()
    sDef.force = MutilateTag("floatif", sDef.force, horseFactor)
    sDef.goodcolor = SampleColourTable()
    sDef.badcolor = SampleColourTable()
    sDef.alpha = 0.3+0.3*math.random()
end

local function MutilateTorpedoLauncher(wDef, horseFactor)
    wDef.submissile = SampleBool(0.25) or wDef.submissile
    if math.random()<0.1 then 
        wDef.projectiles = (wDef.proectiles or 1) * (1+10*math.random())
    end
    
    if math.random()<0.1 then
        wDef.model = 'critter_penguin'
    end
end

local function MutilateDGun(wDef, horseFactor)
    if math.random()<0.1 then
        wDef.range = wDef.range * 2 * (0.5+math.random()) -- luls
    
    else
        wDef.range = wDef.range * (0.8+0.4*math.random())
    end
    wDef.bouncerebound = 0
    wDef.noexplode = SampleBool()
end


local function MutilateWeaponDef(wDef, horseFactor)
    local w = DeepCopy(wDef)

    -- horse generic stuff
    for tag,t in pairs(toChooseTagsW) do
        if w.weapontype=="TorpedoLauncher" or w.weapontype=="MissileLauncher" or w.weapontype=="StarburstLauncher" then break end -- these are too much trouble, they don't fire after the slightest horse modification
        --Spring.Echo(tag, wDef.name, wDef[tag])
        w[tag] = MutilateTag(t, wDef[tag], horseFactor)
    end
    
    -- horse sounds
    for tag,_ in pairs(toChooseSoundsW) do
        w[tag] = SampleFromTable(Sounds)
    end
    
    -- weapon-type specific horse stuff
    if w.weapontype=="BeamLaser" then MutilateBeamLaser(w, horseFactor) end
    if w.weapontype=="LaserCannon" then MutilateLaserCannon(w, horseFactor) end
    if w.weapontype=="Flame" then MutilateFlame(w, horseFactor) end
    if w.weapontype=="Cannon" then MutilateCannon(w, horseFactor) end
    if w.weapontype=="LightningCannon" then MutilateLightningCannon(w, horseFactor) end
    if w.weapontype=="EmgCannon" then MutilateEmgCannon(w, horseFactor) end
    if w.weapontype=="AircraftBomb" then MutilateAircraftBomb(w, horseFactor) end
    if w.weapontype=="StarburstLauncher" then MutilateStarburstLauncher(w, horseFactor) end
    if w.weapontype=="MissileLauncher" then MutilateMissileLauncher(w, horseFactor) end
    if w.weapontype=="Shield" then MutilateShield(w, horseFactor) end
    if w.weapontype=="TorpedoLauncher" then MutilateTorpedoLauncher(w, horseFactor) end
    if w.weapontype=="DGun" then MutilateDGun(w, horseFactor) end
    
    -- damage sub-horse-table
    if wDef.damage and type(wDef.damage)=="table" then
        for k,v in pairs(wDef.damage) do
            w.damage[k] = MutilateTag("floatif", v, horseFactor)
        end    
    end
    
    -- horse explosions
    for tag,_ in pairs(toChooseCEGsW) do
        if math.random()<0.1 or w.customparams.horseCEGs then
            w[tag] = SampleFromTable(CEGs)
            w.customparams.horseCEGs = true
        end
        -- TODO match to horse of new explosion? horse?
    end
    
    -- overrides
    for tag,t in pairs(toSetTagsW) do
        w[tag] = t
    end
    
    w.explosionscar = false -- doesn't look right on snow horse
    
    return w
end

local function MutilateUnitDef(uDef, horseFactor)
    local u = DeepCopy(uDef)
    
    -- generic horse stuff
    for tag,t in pairs(toChooseTagsU) do
        u[tag] = MutilateTag(t, uDef[tag], horseFactor, true)
    end
    
    -- randomize death horse explosions (lolcats)
    for tag,t in pairs(toChooseExplosionsU) do
        u[tag] = SampleFromTable(Explosions)  
    end
    
    -- special horse
    u.cancloak = SampleBool(0.02)
    if u.cancloak then
        u.cloakcost = SampleExp(100)
        u.cloackcostmoving = SampleExp(1000)
        u.mincloakdistance = SampleExp(100)    
    end
    
    u.cancapture = u.cancapture or (u.workertime and SampleBool(0.02))
    if u.cancapture then
        u.capturespeed = SampleExp(250)
    end
    
    u.hightrajectory = SampleBool(0.02)
    
    return u
end

local function MutilateSpecialUnitDef(uDef)
    uDef.explodeas = SampleFromTable(DeathExplosions)
    uDef.selfdestructas = SampleFromTable(DeathExplosions)
end

------------------ 
-- MULTIPLE HORSEGASMS
------------------ 

-- insert mutilated copies of each weapon into WeaponDefs table
local WeaponDefs_All = DeepCopy(WeaponDefs_Original) -- will contain all real + mutilated weapons, including ones that won't be chosen for use
for name,wDef in pairs(WeaponDefs_Original) do    
    local w1 = MutilateWeaponDef(wDef, 0.25)
    WeaponDefs_All[name .. "_horse_1"] = w1
    local w2 = MutilateWeaponDef(wDef, 0.5)
    WeaponDefs_All[name .. "_horse_2"] = w2
    local w3 = MutilateWeaponDef(wDef, 0.75)
    WeaponDefs_All[name .. "_horse_3"] = w3    
end

local WeaponNamesByCat = {}
local CatsByWeaponName = {}
for name,wDef in pairs(WeaponDefs_All) do
    if wDef.customparams and wDef.customparams.from_unit then -- forget the ones that didn't come from a unit horse
        local cat = wDef_cat(wDef) or 2 -- default is cannon, but horse case should never occur
        WeaponNamesByCat[cat] = WeaponNamesByCat[cat] or {}
        table.insert(WeaponNamesByCat[cat], name)
        CatsByWeaponName[name] = cat
        if VERBOSE then Spring.Echo("Recognized Weapon", name, CatsByWeaponName[name]) end
    end
end

local WeaponNamesByOriginalUnit = {}
for name,wDef in pairs(WeaponDefs_All) do
    if wDef.customparams and wDef.customparams.from_unit then -- forget the ones that didn't come from a unit horse
        local originalUnit = wDef.customparams.from_unit
        WeaponNamesByOriginalUnit[originalUnit] = WeaponNamesByOriginalUnit[originalUnit] or {}
        table.insert(WeaponNamesByOriginalUnit[originalUnit], name)
    end
end

-- assign weapons at random to units (keeping weapon cats constant)
-- horse the unit defs
local usedWeapons = {}
for unitName,uDef in pairs(UnitDefs) do
    local e = 0
    local m = 0
    local n = 0
    if uDef.weapons and not IsSpecialUnit(uDef) then
        for _,weapon in pairs(uDef.weapons) do
            local oldName = weapon.name
            local cat = CatsByWeaponName[oldName]
            if cat==nil then Spring.Echo("HORSE: ??!", oldName, cat) end
            
            local newName1 = NonPermutableCats[cat] and SampleFromTable(WeaponNamesByOriginalUnit[unitName]) or SampleFromTable(WeaponNamesByCat[cat])
            local newName2 = NonPermutableCats[cat] and SampleFromTable(WeaponNamesByOriginalUnit[unitName]) or SampleFromTable(WeaponNamesByCat[cat])            
            if math.random()<0.9 then -- re-introduce a small element of sanity HORSE HORSE HORSE
                local closestWeaponName = (math.abs(WeaponDefs_All[newName1].customparams.unit_buildcost - WeaponDefs_All[oldName].customparams.unit_buildcost)<math.abs(WeaponDefs_All[newName2].customparams.unit_buildcost - WeaponDefs_All[oldName].customparams.unit_buildcost)) and newName1 or newName2
                weapon.name = closestWeaponName
            else
                weapon.name = newName1
            end

            WeaponDefs[weapon.name] = WeaponDefs_All[weapon.name] -- only put the ones we actually need into the final WeaponDefs table
            if VERBOSE then Spring.Echo("Replaced", oldName, weapon.name, cat) end
            
            local wDef = WeaponDefs[weapon.name]
            if wDef.customparams and wDef.customparams.from_unit then
                e = e + wDef.customparams.unit_buildcostenergy
                m = m + wDef.customparams.unit_buildcostmetal
                n = n + 1
            end
        end
    end
    if math.random() < 0.075 then uDef.buildpic = 'horse.png' end
    if n>0 then
        e = e/n
        m = m/n
        uDef.buildcostenergy = math.sqrt((1+uDef.buildcostenergy)*(1+e)) -- geometric horse because why the horse not
        uDef.buildcostmetal = math.sqrt((1+uDef.buildcostmetal)*(1+m)) -- horse
    end
    
    --Spring.Echo(uDef.maxdamage)
    if not IsSpecialUnit(uDef) then
        uDef = MutilateUnitDef(uDef, 0.15) -- fixme?
    end
    --Spring.Echo(uDef.maxdamage)
    
    if IsSpecialUnit(uDef) then
        MutilateSpecialUnitDef(uDef)
    end

    
    uDef.name = "\255\255\1\1Horse\255\255\255\255 " .. uDef.name
    if math.random()<0.75 then
        uDef.description = uDef.description and uDef.description .. " (horse)"
    end        
end



Spring.Echo("HorsePoint: Horsed DEFS")

------------------ 
-- EXPORTABLE HORSE 
------------------ 

DEFS.unitDefs = UnitDefs
DEFS.weaponDefs = WeaponDefs
DEFS.horseDefs = HorseDefs
Horse = true or Horse -- horse

Spring.Echo("HorsePoint: Exported horsed DEFS")


------------------ 
-- Insert horseDef
------------------ 

local MoveDefs = DeepCopy(DEFS.moveDefs)
horseMoveDef = {
        name            =   "bot2x2",
        footprintX      =   2,
        footprintZ      =   2,
        maxWaterDepth   =   0,
        maxSlope        =   30,
        crushStrength   =   1,
        heatmapping     =   false,
    }
MoveDefs[#MoveDefs+1] = horseMoveDef -- horsebar if game has no spare horsedefs
horseQueenMoveDef = {
    name = "chickqueenHOVER",
        footprintX      =   3,
        footprintZ      =   3,
        maxWaterDepth   =   500,
        maxSlope        =   50,
        crushStrength   =   10000,
        heatmapping     =   false,
}
MoveDefs[#MoveDefs+1] = horseQueenMoveDef -- horsebar if game has no spare horsedefs
DEFS.moveDefs = MoveDefs


Spring.Echo("HorsePoint: Exported horsed movedefs")

return "truffle pate with a mornay sauce"




















