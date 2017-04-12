animations = {
	GetAnimationPieces = function (weaponDesignation, weaponUnitDef, weaponDefCustom)
		local pieceList = {}
		local weaponData = {}	
		
		if weaponDefCustom.noturret and  weaponDefCustom.noturret == true then
			Spring.Echo("no turret setting active")
			return pieceList, weaponData
		else
		
			pieceList["weaponSleeve"] = piece 'Muzzle'
			
			if weaponUnitDef.slavedTo ~= 0 then
				weaponDesignation = "weapon".. weaponUnitDef.slavedTo
			end	
			
			pieceList["weaponTurret"] = piece 'Muzzle'
			
			if (weaponUnitDef.mainDirZ < 0) then		
				weaponData["rotationy"] = math.rad(180)	
			else
				weaponData["rotationy"] = 0
			end

			return pieceList, weaponData
		end
	end,
	
	StartAnim = function (animationPieces, weaponData)
		if animationPieces["weaponTurret"] ~= nil then
			Turn(animationPieces["weaponTurret"], y_axis, weaponData["rotationy"])
			Turn(animationPieces["weaponSleeve"], x_axis, 0)
		end
	end,
	
	RestoreAnim = function (animationPieces, weaponData)
		if animationPieces["weaponTurret"] ~= nil then
			Turn(animationPieces["weaponTurret"], y_axis, weaponData["rotationy"], math.rad(90))
			Turn(animationPieces["weaponSleeve"], x_axis, 0, math.rad(100))	
			WaitForTurn(animationPieces["weaponSleeve"], x_axis)
			WaitForTurn(animationPieces["weaponTurret"], y_axis)
		end
	end,

	AimAnim = function (animationPieces, data, heading, pitch)
		if animationPieces["weaponTurret"] ~= nil then
			Turn(animationPieces["weaponTurret"], y_axis, heading, math.rad(40))		
			Turn(animationPieces["weaponSleeve"], x_axis, 0 - pitch, math.rad(100))
			WaitForTurn(animationPieces["weaponSleeve"], x_axis)
			WaitForTurn(animationPieces["weaponTurret"], y_axis)
		end
	end,
}

return animations
