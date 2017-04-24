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
		local speedMult = animData["movspeed"] or 1 ---= Spring.GetUnitMoveTypeData(unitID).currentSpeed+0.01
		
		
		while( 1 ) do
			CustomEmitter( modelParts["leftFoot"], animData["dirt"])	
            
			Turn(modelParts["rightFoot"], x_axis, math.rad(-60), math.rad(70 * speedMult))
			Turn(modelParts["leftFoot"], x_axis, math.rad(30), math.rad(70 * speedMult))
				
			Turn(modelParts["Trunk"], z_axis, math.rad(0), math.rad(10 * speedMult))
			
			Move(modelParts["Trunk"], y_axis, 2.2, 60)
			Sleep(650/speedMult)
			
			Turn(modelParts["Trunk"], z_axis, math.rad(-6), math.rad(10 * speedMult))
			
			Move(modelParts["Trunk"], y_axis, 0.4, 0)				
			Sleep(500/speedMult)	
							
			Turn(modelParts["Trunk"], z_axis, math.rad(6), math.rad(10 * speedMult))
			
			Turn(modelParts["leftFoot"], x_axis, math.rad(-60), math.rad(70 * speedMult))
			Turn(modelParts["rightFoot"], x_axis, math.rad(30), math.rad(70 * speedMult))
			

			Move(modelParts["Trunk"], y_axis, 2.5, 60)			--if(isMoving == true) then
			Sleep(658/speedMult)

			Move(modelParts["Trunk"], y_axis, 0.4, 0)					
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
		
		Turn(modelParts["Trunk"], x_axis, math.rad(-5), math.rad(395))

		Sleep(50)
		Move(modelParts["Trunk"], y_axis, -2.8)
	end,
	
	getMovePieces = function ()
		local moveData		= { ["signalmask"] = {} }
		local modelParts		= {} 
		
		local pieces		= Spring.GetUnitPieceMap(unitID)
		
		moveData["dirt"]	= "dirt"
		
		local partsList		= {	-- torso
								'Trunk',	'leftFoot', 'rightFoot',}	
								
		
		
		for k,v in pairs(partsList) do
			if pieces[v] then
				modelParts[v]	= piece (v)
			end
		end

		return modelParts, moveData
	end,
}

return animations