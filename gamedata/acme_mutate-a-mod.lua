Spring.Echo("YOU MUST CONSTRUCT ADDITIONAL PYLONS")

UnitDefs = DEFS.unitDefs
WeaponDefs = DEFS.weaponDefs

------------------ 
-- GLOBAL CONTROLS
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
-- HORSE
------------------ 

local ACME_WEAPONDEFS = "gamedata/acme_weapondefs.lua"
if (VFS.FileExists(ACME_WEAPONDEFS)) then
    VFS.Include(ACME_WEAPONDEFS)
else
    Spring.Echo("Something has gone horribly wrong")
    return "poo"
end





DEFS.unitDefs = UnitDefs
DEFS.weaponDefs = WeaponDefs




















