 animations = {
	GetAnimationData = function ()
		local pieces	=	{}
		local data		=	{}
		
		pieces["cap"] = piece "Cap"

		return pieces, data
	end,
	
	DeathAnim = function (pieces, data, recentDamage, maxHealth)
		--Explode(cap,SFX.FIRE);
		
		local smallMushroomDefID   = UnitDefNames["smallmushroom"].id	
		local x,y,z = Spring.GetUnitPiecePosDir(unitID,pieces.cap);
		Spring.SpawnCEG("redpop", x, y, z, 0, 2, 0, 10,10);
		Spring.PlaySoundFile("sounds/clusterexplosion.wav", 10, x, y, z)
		
		-- spawn small mushrooms on death
		local x, y, z = Spring.GetUnitPosition(unitID)
		local teamID = Spring.GetUnitTeam(unitID)
		local radius = 300
		local height = 20
		for i = 1, 10 do
			Spring.CreateUnit(smallMushroomDefID, x + math.random() * radius - radius/2, y + height, z + math.random() * radius - radius/2, 0, teamID)
		end
		
		return 0
	end,
}

return animations