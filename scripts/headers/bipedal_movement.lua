animations = {
	moveAnim = function (mechParts, animData, stopAnimation)
		-- if inMovment then
			-- return
		-- end
		-- Sleep(10)
		
		
		-- cover odd micro move calls of spring
		-- I should not have to do this but meh
		--if(isMoving ~= true) then
		--	return
		--end
		
		Signal(animData["signalmask"])
		SetSignalMask(animData["signalmask"])
		inMovment	= true
		local speedMult = animData["movspeed"]---= Spring.GetUnitMoveTypeData(unitID).currentSpeed+0.01
		
		Turn(mechParts["thigh_r"], z_axis, 0, math.rad(135))
		Turn(mechParts["thigh_l"], z_axis, 0, math.rad(130))
		Turn(mechParts["foot_l"], y_axis, 0, math.rad(130))
		Turn(mechParts["foot_r"], y_axis, 0, math.rad(130))
		Turn(mechParts["foot_l"], x_axis, 0, math.rad(130))
		Turn(mechParts["foot_r"], x_axis, 0, math.rad(130))
		Turn(mechParts["foot_l"], z_axis, 0, math.rad(130))
		Turn(mechParts["foot_r"], z_axis, 0, math.rad(130))
			
		Turn(mechParts["thigh_r"], y_axis, 0, math.rad(135))
		Turn(mechParts["thigh_l"], y_axis, 0, math.rad(130))
		
		while( 1 ) do
			CustomEmitter( mechParts["foot_r"], animData["dirt"])	
			if (isAiming == false) then
				if (animData["leftArmAnim"] == true ) then
					Turn(mechParts["shoulder_l"], x_axis, math.rad(-5), math.rad(25 * speedMult))
				end
				if (animData["rightArmAnim"] == true ) then
					Turn(mechParts["shoulder_r"], x_axis, math.rad(25), math.rad(25 * speedMult))
				end
				Turn(mechParts["base"], y_axis, math.rad(-5), math.rad(20 * speedMult))
				Turn(mechParts["base"], z_axis, math.rad(2), math.rad(12 * speedMult))
			end
			Turn(mechParts["shin_r"], x_axis, math.rad(85), math.rad(137.5 * speedMult))	
			Turn(mechParts["thigh_r"], x_axis, math.rad(-60), math.rad(70 * speedMult))
			Turn(mechParts["thigh_l"], x_axis, math.rad(30), math.rad(70 * speedMult))
			
			Move(mechParts["cod"], y_axis, 1, 40)
			Sleep(650/speedMult)

			Move(mechParts["cod"], y_axis, -0.4, 20)				
			Sleep(500/speedMult)	
				
			Turn(mechParts["shin_r"], x_axis, math.rad(10), math.rad(185 * speedMult))
			
			CustomEmitter( mechParts["foot_l"], animData["dirt"])		
			if (isAiming == false) then
				if (animData["rightArmAnim"] == true ) then
					Turn(mechParts["shoulder_r"], x_axis, math.rad(-5), math.rad(25 * speedMult))
				end

				if (animData["leftArmAnim"] == true ) then
					Turn(mechParts["shoulder_l"], x_axis, math.rad(25), math.rad(25 * speedMult)) 
				end
				Turn(mechParts["base"], y_axis, math.rad(5), math.rad(20 * speedMult))
				Turn(mechParts["base"], z_axis, math.rad(-2), math.rad(12 * speedMult))
			end
			Turn(mechParts["shin_l"], x_axis, math.rad(85), math.rad(137.5 * speedMult))
			Turn(mechParts["thigh_l"], x_axis, math.rad(-60), math.rad(70 * speedMult))
			Turn(mechParts["thigh_r"], x_axis, math.rad(30), math.rad(70 * speedMult))
			

			Move(mechParts["cod"], y_axis, 1, 40)			--if(isMoving == true) then
			Sleep(658/speedMult)

			Move(mechParts["cod"], y_axis, -0.4, 20)					
			Sleep(500/speedMult)

			Turn(mechParts["shin_l"], x_axis, math.rad(10), math.rad(185 * speedMult))

				-- Sleep(50)
			if(isMoving ~= true) then
				--prevents infinite loop, put in an else because otherwise it will cause a skate
				stopAnimation(mechParts, animData)
				inMovment	= false
				return--Sleep(50)
			end
		end
	end,

	stopAnim = function (mechParts, animData)
		
		Turn(mechParts["cod"], x_axis, math.rad(-5), math.rad(395))
		
		if (isAiming == false) then
			Turn(mechParts["base"], x_axis, math.rad(5), math.rad(395))
			if (animData["leftArmAnim"] == true ) then
				Turn(mechParts["shoulder_l"], x_axis, math.rad(15), math.rad(395))
				Turn(mechParts["shoulder_l"], y_axis, math.rad(5), math.rad(395))
				Turn(mechParts["arm_l"], z_axis, math.rad(10), math.rad(395))
				Turn(mechParts["forearm_l"], x_axis, math.rad(-50), math.rad(395))
			end
			if (animData["rightArmAnim"] == true ) then
				Turn(mechParts["shoulder_r"], x_axis, math.rad(15), math.rad(395))
				Turn(mechParts["shoulder_r"], y_axis, math.rad(-5), math.rad(395))
				Turn(mechParts["arm_r"], z_axis, math.rad(-10), math.rad(395))
				Turn(mechParts["forearm_r"], x_axis, math.rad(-50), math.rad(395))
			end
		end
		
		Turn(mechParts["thigh_r"], x_axis, math.rad(-10), math.rad(235))
		Turn(mechParts["thigh_r"], y_axis, math.rad(-6), math.rad(135))	
		Turn(mechParts["thigh_r"], z_axis, math.rad(-15), math.rad(135))
		
		Turn(mechParts["thigh_l"], x_axis, math.rad(-10), math.rad(235))
		Turn(mechParts["thigh_l"], y_axis, math.rad(6), math.rad(135))	
		Turn(mechParts["thigh_l"], z_axis, math.rad(15), math.rad(135))
		
		Turn(mechParts["shin_l"], x_axis, math.rad(45), math.rad(235))
		Turn(mechParts["shin_r"], x_axis, math.rad(45), math.rad(230))

		Turn(mechParts["foot_l"], x_axis, math.rad(-30), math.rad(395))
		CustomEmitter( mechParts["foot_l"], animData["dirt"])	
		Turn(mechParts["foot_l"], y_axis, math.rad(5), math.rad(130))
		Turn(mechParts["foot_l"], z_axis, math.rad(-14), math.rad(130))
		
		Turn(mechParts["foot_r"], x_axis, math.rad(-30), math.rad(395))
		CustomEmitter( mechParts["foot_r"], animData["dirt"])	
		Turn(mechParts["foot_r"], y_axis, math.rad(-5), math.rad(130))
		Turn(mechParts["foot_r"], z_axis, math.rad(14), math.rad(130))
		Sleep(50)
		Move(mechParts["cod"], y_axis, -2.8)
	end,
	
	getMovePieces = function ()
		local moveData		= { ["signalmask"] = {} }
		local mechParts		= {} 
		
		local pieces		= Spring.GetUnitPieceMap(unitID)
		
		moveData["leftArmAnim"]		= true
		moveData["rightArmAnim"]	= true
		
		moveData["dirt"]	= "dirt"
		
		local partsList		= {	-- torso
								'base',	'cod',
								-- legs
								'thigh_r', 'thigh_l', 'shin_l', 
								'shin_r', 'foot_r', 'foot_l', }	
								
		local leftList		= {	'shoulder_l', 'forearm_l', 'arm_l',}	
		
		local rightList		= {	'shoulder_r', 'forearm_r', 'arm_r',}
		
		
		for k,v in pairs(partsList) do
			if pieces[v] then
				mechParts[v]	= piece (v)
			end
		end
		
		for k,v in pairs(leftList) do
			if pieces[v] then
				mechParts[v]	= piece (v)
			else
				--	if i am missing a single arm piece
				--	disable arm animation
				moveData["leftArmAnim"]		= false
			end
		end		
		
		for k,v in pairs(rightList) do
			if pieces[v] then
				mechParts[v]	= piece (v)
			else
				--	if i am missing a single arm piece
				--	disable arm animation
				moveData["rightArmAnim"]	= false
			end
		end				
			
		return mechParts, moveData
	end,
}

return animations