
function gadget:GetInfo()
  return {
    name      = "Bus stop f'tang f'tang",
    desc      = "",
    author    = "Robert Ole Ole Biscuit 'the weasel' Paulson",
    date      = "0",
    license   = "",
    layer     = 0,
    enabled   = true  --  loaded by default?
  }
end

if not (gadgetHandler:IsSyncedCode()) then return end 

local limit = 20
local penguinDefID = UnitDefNames["critter_penguin"].id

function gadget:AllowUnitCreation(unitDefID, builderID, builderTeam, x, y, z, facing)
	Spring.Echo(unitDefID, builderID, builderTeam, x, y, z, facing)
	local n = Spring.GetTeamUnitDefCount(builderTeam, unitDefID)	
	
	r = 50 + 100*math.random() + Spring.GetUnitRadius(builderID) 
	if not x then
		x,_,z = Spring.GetUnitPosition(builderID)	
	end
	theta = math.random()*2*math.pi
	x = x + r*math.cos(theta)
	z = z + r*math.sin(theta)
	y = Spring.GetGroundHeight(x,z)
	
	if n > limit then
		if Spring.GetTeamUnitDefCount(builderTeam, penguinDefID) < 100 then
			Spring.Echo("\255\255\255\255The Christmas horse says you cannot have more than 20 of a single unit type! Instead you will be given a penguin.")
			unitID = Spring.CreateUnit("critter_penguin", x,y,z, "n", builderTeam)
		else
			Spring.Echo("\255\255\255\255The Christmas horse says you cannot have more than 20 of a single unit type! You already have lots of penguins.")		
		end
		
		return false
	end
	return true
end

