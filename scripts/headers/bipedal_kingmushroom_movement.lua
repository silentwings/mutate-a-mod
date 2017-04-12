animations = {
	moveAnim = function (modelParts, animData, stopAnimation)
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
		local speedMult = animData["movspeed"] or 1---= Spring.GetUnitMoveTypeData(unitID).currentSpeed+0.01
		
		
		while( 1 ) do
		
			CustomEmitter( modelParts["RR"], animData["dirt"])	
			CustomEmitter( modelParts["RL"], animData["dirt"])	

			Turn(modelParts["RL"], x_axis, math.rad(-40), math.rad(40 * speedMult))
			Turn(modelParts["FR"], x_axis, math.rad(-40), math.rad(40 * speedMult))
			Turn(modelParts["FL"], x_axis, math.rad(20), math.rad(60 * speedMult))
			Turn(modelParts["RR"], x_axis, math.rad(20), math.rad(60 * speedMult))	
				
			Turn(modelParts["King"], z_axis, math.rad(0), math.rad(10 * speedMult))
			
			Move(modelParts["King"], y_axis, 4.2, 100)
			Sleep(650/speedMult)
			
			Turn(modelParts["KingHead"], x_axis, math.rad(3), math.rad(5 * speedMult))
			Turn(modelParts["KingHead"], z_axis, math.rad(7), math.rad(12 * speedMult))
			Turn(modelParts["King"], z_axis, math.rad(-6), math.rad(10 * speedMult))
			Turn(modelParts["King"], x_axis, math.rad(2), math.rad(10 * speedMult))
			
			Move(modelParts["King"], y_axis, 2.4, 0)				
			Sleep(500/speedMult)	
							
			Turn(modelParts["KingHead"], x_axis, math.rad(-4), math.rad(5 * speedMult))
			Turn(modelParts["KingHead"], z_axis, math.rad(-7), math.rad(12 * speedMult))
			Turn(modelParts["King"], z_axis, math.rad(6), math.rad(10 * speedMult))
			Turn(modelParts["King"], x_axis, math.rad(-2), math.rad(10 * speedMult))
			
			CustomEmitter( modelParts["FR"], animData["dirt"])	
			CustomEmitter( modelParts["FL"], animData["dirt"])
			Turn(modelParts["RR"], x_axis, math.rad(-40), math.rad(60 * speedMult))
			Turn(modelParts["FL"], x_axis, math.rad(-40), math.rad(60 * speedMult))
			Turn(modelParts["RL"], x_axis, math.rad(20), math.rad(40 * speedMult))
			Turn(modelParts["FR"], x_axis, math.rad(20), math.rad(40 * speedMult))
			

			Move(modelParts["King"], y_axis, 1, 100)			--if(isMoving == true) then
			Sleep(658/speedMult)

			Move(modelParts["King"], y_axis, 0, 0)					
			Sleep(500/speedMult)


				-- Sleep(50)
			if(isMoving ~= true) then
				--prevents infinite loop, put in an else because otherwise it will cause a skate
				stopAnimation(modelParts, animData)
				inMovment	= false
				return--Sleep(50)
			end
		end
	end,

	stopAnim = function (modelParts, animData)
		
		Turn(modelParts["RR"], x_axis, math.rad(0), math.rad(70))
		Turn(modelParts["FL"], x_axis, math.rad(0), math.rad(70))
		Turn(modelParts["RL"], x_axis, math.rad(0), math.rad(70))
		Turn(modelParts["FR"], x_axis, math.rad(0), math.rad(70))
		Sleep(50)
		Move(modelParts["King"], y_axis, -2.8)	
		CustomEmitter( modelParts["FR"], animData["dirt"])	
		CustomEmitter( modelParts["FL"], animData["dirt"])
		CustomEmitter( modelParts["FL"], animData["dirt"])	
		CustomEmitter( modelParts["FR"], animData["dirt"])
	end,
	
	getMovePieces = function ()
		local moveData		= { ["signalmask"] = {} }
		local modelParts		= {} 
		
		local pieces		= Spring.GetUnitPieceMap(unitID)
		
		moveData["dirt"]	= "dirt"
		
		local partsList		= {	-- torso
								'FR','FL','RR','RL','King','KingHead'}	
								
		
		
		for k,v in pairs(partsList) do
			if pieces[v] then
				modelParts[v]	= piece (v)
			end
		end

		return modelParts, moveData
	end,
}

return animations