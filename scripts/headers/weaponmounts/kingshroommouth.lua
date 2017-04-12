animations = {
	GetAnimationPieces = function (weaponDesignation, weaponUnitDef, weaponDefCustom)
		local pieceList = {}
		local weaponData = {}	
		
		if weaponDefCustom.noturret and  weaponDefCustom.noturret == true then
			Spring.Echo("no turret setting active")
			return pieceList, weaponData
		else
		
			pieceList["weaponSleeve"] = piece 'KingHead'
			
			if weaponUnitDef.slavedTo ~= 0 then
				weaponDesignation = "weapon".. weaponUnitDef.slavedTo
			end	
			
			pieceList["weaponTurret"] = pieceList["weaponSleeve"]
			
			if (weaponUnitDef.mainDirZ < 0) then		
				weaponData["rotationy"] = math.rad(180)	
			else
				weaponData["rotationy"] = 0
			end

			return pieceList, weaponData
		end
	end,
	
	StartAnim = function (animationPieces, weaponData)
	end,
	
	RestoreAnim = function (animationPieces, weaponData)
	end,

	AimAnim = function (animationPieces, data, heading, pitch)

	end,
}

return animations
