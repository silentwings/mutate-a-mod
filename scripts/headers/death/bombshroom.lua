 animations = {
	GetAnimationData = function ()
		local pieces	=	{}
		local data		=	{}
		
		pieces["cap"] = piece "Trunk"

		return pieces, data
	end,
	
	DeathAnim = function (pieces, data, recentDamage, maxHealth)
		local x,y,z = Spring.GetUnitPiecePosDir(unitID,pieces.cap);
		local h = Spring.GetUnitHeight(unitID)
        Spring.SpawnCEG("red_pop", x, y+h, z, 0, 2, 0, 10,10);
		return 0
	end,
}

return animations