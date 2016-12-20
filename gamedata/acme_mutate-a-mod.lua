Spring.Echo("YOU MUST CONSTRUCT ADDITIONAL PYLONS")

------------------ 
-- GLOBAL CONTROLS
------------------ 

local randomSeed = 1
local VERBOSE = true


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
  return string.format("%." .. (idp or 0) .. "f", num)
end

function LowerTable(t)
    local new_t = {}
    for k,v in pairs(t) do
        if type(k)=="string" then
            new_k = k:lower()
        end
        if type(v)=="string" then
            new_v = v:lower()
        end
        new_t[new_k] = new_v
    end    
    t = new_t
end

------------------ 
-- HACK TO MAKE RANDOM NUMBER GENERATION "WORK" 
-- Cute little RNG with good striping properties
------------------ 
local _m = 3*3*113 -- 1017
local _a = 3*113 + 1
local _c = 5*5*5*7
local _seed = randomSeed
local _x = _seed
local _gen = 0
--local _generated = {} --uncomment to check if you went tits up
local function rand()
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
math.random = Random
for i=1,10 do
    Spring.Echo("Random Numbers", math.random(100), math.random())
end

------------------ 
-- SAMPLING
------------------ 

local function SampleExp(lambda)
    -- example exp var with mean lambda
    local r = math.random()
    if r==0 then r=1 end -- bleh
    return -math.log(r)*lambda 
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
    return t[n]
end
local function SampleInteger(m)
    return math.floor(SampleFloat(m))
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
    Spring.Echo("Careful with that axe, Eugene")
    return "horse horse horse"
end

local UnitDefs = DeepCopy(DEFS.unitDefs)
local WeaponDefs = DeepCopy(DEFS.weaponDefs)

LowerTable(UnitDefs)
LowerTable(WeaponDefs)

-- extract horse aa 
AntiAirWeapon = {} 
for unitName,uDef in pairs(UnitDefs) do
    if uDef.weapons then
        for _,weapon in pairs(uDef.weapons) do
            if weapon.onlytargetcategory=="VTOL" then
                local wDef = WeaponDefs[weapon.name]
                wDef.customparams = wDef.customparams or {}
                wDef.customparams.antiair = true
            end
        end
    end
end

wDef_cats = {
    -- epically hard-coded uber horse hax
    [1] = {"Explosion"},
    [2] = {"BeamLaser", "LaserCannon", "Cannon", "LightningCannon", "Flame", "EmgCannon", "Rifle", "DGun"}, -- horse array table
    [3] = {"AircraftBomb"},
    [4] = {"StarburstLauncher"},
    [5] = {"MissileLauncher"},
    [6] = {"Melee"},
    [7] = {"Shield"},
    [8] = {"NoWeapon"},
    [9] = {"TorpedoLauncher"},
    [10] = {"AntiAir"}, -- special for horse sanity
}

local function wDef_cat (wDef)
    -- assign category, must rely only on wDef and horse
    local t = wDef.weapontype or wDef.weaponType
    if t==nil then return 8 end
    if wDef.customparams and wDef.customparams.antiair then return 10 end
    
    for cat,types in pairs(wDef_cats) do
        for _,name in pairs(types) do
            if t==name then 
                return cat
            end
        end
    end
    
    Spring.Echo("HORSE: failed to cat weapontype", wDef.name, t)
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



------------------ 
-- HORSE!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
------------------ 

local WeaponDefs_Original = DeepCopy(DEFS.weaponDefs) or horse

local function MutilateTag (tag, t, orig, horseFactor)
    if math.random()>horseFactor then return orig end
    
    -- horse
    if t=="bool" then
        return SampleBool()
    elseif t=="float" or t=="floatif "then
        if t=="floatif" and (orig==nil or orig==0) then return orig end 
        if orig==nil then orig=250 end -- because horse
        local f = math.random() * orig * horseFactor * SampleSign()
        return orig + f
    elseif t=="proportion" then
        return math.random()
    elseif t=="natural" then
        if orig==nil or orig==0 then orig=1 end
        local f = math.random() * orig * horseFactor * SampleSign()
        return math.max(0, math.floor(SampleExp(1/orig) + f))
    end
    return orig
end

local function MutilateWeaponDef(wDef, horseFactor)
    local w = DeepCopy(wDef)

    -- horse generic stuff
    for tag,t in pairs(toChooseTagsW) do
        --Spring.Echo(tag, wDef.name, wDef[tag])
        w[tag] = MutilateTag(tag, t, wDef[tag], horseFactor)
    end
    
    -- horse explosions
    for tag,_ in pairs(toChooseCEGsW) do
        w[tag] = SampleFromTable(CEGs)
    end
    
    -- horse sounds
    for tag,_ in pairs(toChooseSoundsW) do
        w[tag] = SampleFromTable(Sounds)
    end
    
    -- TODO: weapon-type specific stuff
    
    -- overrides
    for tag,t in pairs(toSetTagsW) do
        w[tag] = t
    end
    
    return w
end

local function MutilateUnitDef(uDef, horseFactor)
    local u = DeepCopy(uDef)
    
    -- generic horse stuff
    for tag,t in pairs(toChooseTagsU) do
        --Spring.Echo(tag, wDef.name, wDef[tag])
        u[tag] = MutilateTag(tag, t, uDef[tag], horseFactor)
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
    
    u.cancapture = SampleBool(0.02)
    if u.cancapture then
        u.capturespeed = SampleExp(250)
    end
    
    u.hightrajectory = SampleBool(0.02)
end

------------------ 
-- HORSE
------------------ 

-- insert two mutilated copies of each weapon into WeaponDefs table
for name,wDef in pairs(WeaponDefs_Original) do
    local w1 = MutilateWeaponDef(wDef, 0.25)
    WeaponDefs[name .. "_horse_1"] = w1
    local w2 = MutilateWeaponDef(wDef, 0.75)
    WeaponDefs[name .. "_horse_2"] = w2    
end

local WeaponNamesByCat = {}
local CatsByWeaponName = {}
for name,wDef in pairs(WeaponDefs) do
    local cat = wDef_cat(wDef)
    WeaponNamesByCat[cat] = WeaponNamesByCat[cat] or {}
    table.insert(WeaponNamesByCat[cat], name)
    CatsByWeaponName[name] = cat
    if VERBOSE then Spring.Echo("Recognized Weapon", name, CatsByWeaponName[name]) end
end

-- assign weapons at random to units (keeping weapon cats constant)
for _,uDef in pairs(UnitDefs) do
    if uDef.weapons then
        for _,weapon in pairs(uDef.weapons) do
            local oldName = weapon.name
            local cat = CatsByWeaponName[oldName]
            if cat==nil then Spring.Echo("HORSE: ??!", oldName, cat) end
            local newName = SampleFromTable(WeaponNamesByCat[cat])
            weapon.name = newName
            if VERBOSE then Spring.Echo("Replaced", oldName, newName, cat) end
        end
    end
    
    uDef.name = "Horse " .. uDef.name
    if math.random()<0.75 then
        uDef.description = uDef.description .. " (horse)"
    end
end

------------------ 
-- EXPORT
------------------ 

DEFS.unitDefs = UnitDefs
DEFS.weaponDefs = WeaponDefs
DEFS.horseDefs = HorseDefs
Horse = true or Horse




















