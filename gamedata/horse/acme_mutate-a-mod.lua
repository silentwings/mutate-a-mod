Spring.Echo("YOU MUST CONSTRUCT ADDITIONAL PYLONS")

UnitDefs = DEFS.unitDefs
WeaponDefs = DEFS.weaponDefs

------------------ 
-- GLOBAL CONTROLS THAT SHOULD PROBABLY BE MOD OPTIONS IF I WAS LESS LAZY
------------------ 

local randomSeed = 1
local EtoM = 60


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

function format(num, idp)
  return string.format("%." .. (idp or 0) .. "f", num)
end

------------------ 
-- HACK TO MAKE RANDOM NUMBER GENERATION "WORK" 
------------------ 
local _m = 3*3*113 -- 1017
local _a = 3*113 + 1
local _c = 5*5*5*7
local _seed = 1 
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
local function SampleFloat(lambda)
    -- example exp var with mean lambda
    local r = math.random()
    if r==0 then r=1 end -- bleh
    local val = -math.log(r)*lambda 
    return val
end
local function SampleBool(p)
    local r = math.random()
    return (r<p)
end
local function SampleFromTable(t)
    local n = math.random(#t)
    return t[n]
end
local function SampleInteger(m)
    return math.floor(SampleFloat(m))
end
local function SampleUniform()
    return math.random()
end

------------------ 
-- INFO EXTRACTION
------------------ 

local energyToMetal = 60 -- TODO: make this a modoption
local costInfo = {}
costInfo.sumSq = 0
costInfo.sum = 0
costInfo.n = 0

-- extract costInfo from the unit def
for uDID,t in pairs(UnitDefs) do
    local cost = (t.buildCostEnergy or 0)*energyToMetal + (t.buildCostMetal or 0)
    costInfo.n = costInfo.n + 1
    costInfo.sum = costInfo.sum + cost
    costInfo.sumSq = costInfo.sumSq + cost*cost    
end
costInfo.avg = costInfo.sum/costInfo.n
costInfo.avgSq = costInfo.sumSq/costInfo.n
costInfo.stdDev = costInfo.avgSq - costInfo.avg*costInfo.avg

local weaponInfo = {}
local models = {}
local sounds = {}
local textures = {}
local colors = {}
local ignoredWeapons = {
    ["Melee"] = true,
    ["Rifle"] = true,
    ["DGun"] = true,
}

weaponInfo.n = 0
for _,wDef in pairs(WeaponDefs) do
    local weaponType = wDef.weaponType
    if not ignoredWeapons[weaponType] then
        -- record average stats for each weapon def
        for k,v in pairs(wDef) do
            if type(v)=="number" and v<10e4 and v>0 then
                weaponInfo[string.lower(k)] = weaponInfo[string.lower(k)] or 0 
                weaponInfo[string.lower(k)] = weaponInfo[string.lower(k)] + v
            end
        end
        weaponInfo.n = weaponInfo.n + 1
        
        -- record models, sounds, textures    
        SaveIf(wDef.model,models)  
        SaveIf(wDef.soundTrigger, sounds)
        SaveIf(wDef.soundHitDry, sounds)
        SaveIf(wDef.soundHitWet, sounds)
        SaveIf(wDef.soundStart, sounds)
        SaveIf(wDef.texture1, textures) 
        SaveIf(wDef.texture2, textures)
        SaveIf(wDef.texture3, textures)
        SaveIf(wDef.texture4, textures)   
        
        colors[#colors+1] = wDef.rgbcolor or wDef.rgbColor
    end
end

for k,_ in pairs(weaponInfo) do
    if k~="n" then
        weaponInfo[k] = weaponInfo[k] / weaponInfo.n
    end
    Spring.Echo("Average", k, weaponInfo[k])
end

------------------ 
-- WEAPONDEF GENERATION
------------------ 
-- write function for each weapon type (+ mines gadget?) to randomly sample additional tags 
-- write function to analyse "cost" of weapons

local ACME_WEAPONDEFS = "gamedata/acme_weapondefs.lua"
if (VFS.FileExists(ACME_WEAPONDEFS)) then
    VFS.Include(ACME_WEAPONDEFS)
else
    Spring.Echo("Something has gone horribly wrong")
    return "poo"
end

local function ImposeDefaults(wDef)
    for k,v in pairs(toSet) do
        wDef[k] = v
    end
end
local function SampleNormalStuff()
    local wDef = {}
    ImposeDefaults(wDef)
    for k,v in pairs(toChoose) do
        if v=="float" then
            wDef[k] = SampleFloat(weaponInfo[string.lower(k)] or 1)
        elseif v=="integer" then 
            wDef[k] = SampleInteger(weaponInfo[string.lower(k)] or 1)
        elseif v=="1+integer" then 
            wDef[k] = 1+SampleInteger(weaponInfo[string.lower(k)] or 1)
        elseif v=="proportion" then     
            wDef[k] = SampleUniform() --too lazy to use the beta distribution
        elseif v=="bool" then
            wDef[k] = SampleBool(weaponInfo[string.lower(k)] or 1)
        end
    end    

    wDef.damage = {default = 1000} --TODO

    return wDef
end

local function SampleColor ()
    local p = math.random()
    local r,g,b,a
    
    if p<0.1 then
        -- red ish
        r = 1.0-math.random()*0.2
        g = math.random()*0.2 
        b = math.random()*0.2 
        a = 1.0
    elseif p<0.2 then
        -- green ish
        r = math.random()*0.2
        g = 1.0-math.random()*0.2 
        b = math.random()*0.2 
        a = 1.0
    elseif p<0.3 then
        -- blue ish
        r = math.random()*0.1
        g = math.random()*0.1 
        b = 1.0-math.random()*0.1 
        a = 1.0
    elseif p<0.4 then
        -- meh
        r = 1.0-math.random()*0.2
        g = 0.8+0.2*math.random()
        b = 0.8*math.random()
        a = 1.0
    elseif p<0.5 then
        -- yellow ish
        r = 1.0-math.random()*0.2
        g = 1.0-math.random()*0.2
        b = 0.1*math.random()
        a = 1.0
    elseif p<0.6 then
        -- purple ish
        r = 1.0-math.random()*0.2
        g = 0.1*math.random()
        b = 1.0-math.random()*0.2
        a = 1.0
    else
        local col = SampleFromTable(colors)
        if type(col)=="table" then
            r = col[1] or col.r or 0
            g = col[2] or col.g or 0
            b = col[3] or col.b or 1
            a = col[4] or col.a or 1
        else        
            -- random pastelesque
            r = 1-math.pow(math.random(),1.5)
            g = (math.random()<0.5 and 0.1 or 0.9) + math.random()*0.1 
            b = math.pow(math.random(),1.5)
            a = 1.0    
        end
    end    
    return r,g,b,a
end

local function SampleColorMap(colors)
    -- todo: add configs
    local colormap = ""
    for i=1,colors do
        local r,g,b,a = SampleColor()
        colormap = colormap .. tostring(r) .. " " .. tostring(g) .. " " .. tostring(b) .. " " .. tostring(a) .. " "
    end 
    colormap = string.sub(colormap,1,string.len(colormap)-1)
    --Spring.Echo("MOOOOO", colormap) -- DEBUG RNG
    return colormap
end

local function SampleComedyCannon()
    local wDef = SampleNormalStuff()
    
    wDef.weapontype = "Cannon" 
    wDef.turret = true
    wDef.stockpile = false
    wDef.metalpershot = 0
    wDef.energypershot = 0
    wDef.range = math.min(wDef.range, weaponInfo.range*1.5)
    wDef.weaponvelocity = math.max(math.sqrt(wDef.range * 110),300)


    -- sample burst
    if math.random()<0.2 then
        local p = math.random() 
        wDef.burst = (p<0.4 or p>0.8) and math.random(2,10) or 1
        wDef.sprayAngle = math.random(100,10000)
        wDef.projectiles = (p>0.4) and math.random(2,10) or 1
        wDef.burstRate = math.min(wDef.reloadTime/wDef.burst, 0.05+0.5*math.random())
    end
    
    -- sample bounce
    
    
    -- sample impulse
    -- TODO
    
    
    local numColors = (math.random()<0.8) and 2 or 1+math.random(6)
    wDef.colormap = SampleColorMap(numColors)
    wDef.size = (math.random()<0.8) and 4 or 2+math.random(20)
    wDef.hightrajectory = SampleBool(0.25)
    
    wDef.damage.default = wDef.damage.default * wDef.burstRate / wDef.burst

    return wDef
end

local function SampleComedyBeamLaser ()
    local wDef = SampleNormalStuff()

    wDef.weapontype = "BeamLaser" 
    wDef.turret = true
    wDef.stockpile = false
    wDef.metalpershot = 0
    wDef.energypershot = math.random(1,20)
    
    wDef.beamTime = 0.1 + math.pow(math.random(),2.0)*3.0
    wDef.beamBurst = SampleBool(0.2)
    if wDef.beamBurst then
        local p = math.random() 
        wDef.burst = (p<0.4 or p>0.8) and math.random(2,10) or 1
        wDef.sprayAngle = math.random(100,10000)
        wDef.projectiles = (p>0.4) and math.random(2,10) or 1
        wDef.burstRate = math.min(wDef.reloadTime/wDef.burst, 0.05+0.5*math.random())    
    end
    
    wDef.beamDecay = 1.0 + (math.random()-0.5)/8
    wDef.thickness = 1.0 + math.pow(math.random(),2.0)*20
    wDef.coreThickness = 1.0 + math.pow(math.random(),2.0)*10
    wDef.rgbColor = math.random()<0.5 and SampleFromTable(colors) or SampleColorMap(1) 
    wDef.rgbcolor2 = (math.random()<0.25) and SampleColorMap(1) or nil

    wDef.damage.default = wDef.damage.default * (wDef.burstRate or 1) / (wDef.burst or 1)
    
    return wDef
end

local function SampleComedyLaserCannon ()
    local wDef = SampleNormalStuff()

    wDef.weapontype = "LaserCannon" 
    wDef.turret = true
    wDef.stockpile = false
    wDef.metalpershot = 0
    wDef.energypershot = math.random(1,5)

    wDef.range = math.min(wDef.range, weaponInfo.range*1.5)
    wDef.weaponvelocity = math.max(SampleFloat(math.max(math.sqrt(wDef.range * 110),300)), math.sqrt(wDef.range * 70))
    
    wDef.duration = 0.05 + math.pow(math.random(),2.0)*0.5
    wDef.hardStop = SampleBool(0.5)
    
    wDef.thickness = 1.0 + math.pow(math.random(),2.0)*8
    wDef.coreThickness = 1.0 + math.pow(math.random(),2.0)*4
    wDef.rgbColor = SampleFromTable(colors)
    wDef.rgbcolor2 = SampleFromTable(colors)
    
    wDef.damage.default = wDef.damage.default

    return wDef
end


------------------ 
-- REPLACEMENT
------------------ 
-- try to match relative unit costs onto new cost of weapons given to unit 
local weaponGenerators = {
    SampleComedyCannon,
    SampleComedyBeamLaser,
    SampleComedyLaserCannon,
}


local newWeaponNames = {}
for i=1,500 do
    local name = "acme_cannon_" .. tostring(i)
    local wDef = SampleComedyCannon() 
    wDef.name = name
    WeaponDefs[name] = wDef
    newWeaponNames[#newWeaponNames+1] = name
end
for i=1,500 do
    local name = "acme_beamlaser_" .. tostring(i)
    local wDef = SampleComedyBeamLaser() 
    wDef.name = name
    WeaponDefs[name] = wDef
    newWeaponNames[#newWeaponNames+1] = name
end
for i=1,500 do
    local name = "acme_lasercannon_" .. tostring(i)
    local wDef = SampleComedyLaserCannon() 
    wDef.name = name
    WeaponDefs[name] = wDef
    newWeaponNames[#newWeaponNames+1] = name
end


--[[
for name,wDef in pairs(WeaponDefs) do
    if string.find(wDef.name or "", "acme") then
        Spring.Echo("WeaponDef: " .. tostring(name))
        Spring.Echo(TableToString(wDef))
    end
end
]]


for uDID,uDef in pairs(UnitDefs) do
    if uDef.weapons then
        for _,weapon in pairs(uDef.weapons) do
            local oldName = weapon.name
            local newName = SampleFromTable(newWeaponNames)
            weapon.name = newName
            Spring.Echo("Replaced", oldName, newName)
        end
    end
end





DEFS.unitDefs = UnitDefs
DEFS.weaponDefs = WeaponDefs




















