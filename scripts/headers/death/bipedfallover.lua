 animations = {
	GetAnimationData = function ()
		local pieces	=	{}
		local data		=	{}
		 
		local piecelist		= Spring.GetUnitPieceMap(unitID)
		
		data["explosion"]	= "bigbulletimpact"
		
		local partsList		= {	-- torso
								'base',	'cod',
								-- legs
								'thigh_r', 'thigh_l', 'shin_l', 
								'shin_r', 'foot_r', 'foot_l', }	
								
		local leftList		= {	'shoulder_l', 'forearm_l', 'arm_l',}	
		
		local rightList		= {	'shoulder_r', 'forearm_r', 'arm_r',}
		
		for k,v in pairs(partsList) do
			if piecelist[v] then
				pieces[v]	= piece (v)
			end
		end
		
		for k,v in pairs(leftList) do
			if piecelist[v] then
				pieces[v]	= piece (v)
			end
		end		
		
		for k,v in pairs(rightList) do
			if piecelist[v] then
				pieces[v]	= piece (v)
			end
		end				
		return pieces, data
	end,
	
	DeathAnim = function (pieces, data, recentDamage, maxHealth)
		-- fall over
		Turn(pieces["cod"],			x_axis, math.rad(270), 5)	
		-- reset parts
		Turn(pieces["base"],		y_axis, 0,	8)	
		
		VerifiedTurn(pieces["arm_r"],		z_axis, 4,	3)
		VerifiedTurn(pieces["arm_l"],		z_axis, -4,	3)
		
		-- fall
		Move(pieces["cod"],			y_axis, 10,	100)
		Turn(pieces["base"],		x_axis, 0.5,	8)
		Turn(pieces["thigh_r"],		x_axis, -0.5,	8)
		Turn(pieces["thigh_l"],		x_axis, -0.5,	8)			
		WaitForMove(pieces["cod"],	y_axis)
		
		Sleep(200)

		CustomEmitter( pieces["base"], data["explosion"])	
		
		-- land
		VerifiedTurn(pieces["forearm_r"],	x_axis, 0,		5)
		VerifiedTurn(pieces["forearm_l"],	x_axis, 0,		5)
		
		Move(pieces["cod"],			y_axis, -35,	200)	
		Turn(pieces["base"],		x_axis, 0,		10)
		Turn(pieces["thigh_r"],		x_axis, 0,		10)
		Turn(pieces["thigh_l"],		x_axis, 0,		10)
		WaitForMove(pieces["cod"],	y_axis)
		
		local severity = recentDamage/maxHealth
		if (severity <= 99) then
			VerifiedExplode(pieces["shoulder_l"], 	SFX.FALL)
			VerifiedExplode(pieces["shoulder_r"],	SFX.FALL)
			VerifiedExplode(pieces["arm_l"],		SFX.FALL)
			VerifiedExplode(pieces["forearm_l"],	SFX.FALL)
			VerifiedExplode(pieces["arm_r"],		SFX.FALL)
			VerifiedExplode(pieces["forearm_r"],	SFX.FALL)
			return 3
		else
			return 0
		end
	end,
}

return animations