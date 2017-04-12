--common = VFS.Include("scripts/headers/weapons/commonAnimationFunctions.lua")
--Spring.Echo(common)

animations = {
	--------------------------------------------------------------------
	-- returns all our data and pieces for the animation script
	--------------------------------------------------------------------
	GetAnimationData = function (weaponDesignation, weaponUnitDef, weaponDefCustom, 
								mountDesignation, weaponDirection)
			
		local weaponData	= {}
		local pieceList 	= {}		
		pieceList["emitters"]		= {}
		
		-- default axis of rotation
		local weaponBarrelAxis		= z_axis
		-- direction of weapon recoil. 
		local weaponRecoildir	= -1
			
		if weaponDirection and weaponDirection == "y_axis" then
			weaponBarrelAxis			= y_axis
		end

		
		weaponData["flare"]	= piece 'KingHead'
		pieceList["e"]		= weaponData["flare"]
		
		return pieceList, weaponData
	end,
	
	--------------------------------------------------------------------
	-- animation to on each "fire" of the weapon
	--------------------------------------------------------------------
	FireAnim = function (animationPieces, weaponData)
	end,
	
	--------------------------------------------------------------------
	-- animation to on each "shot" of the weapon "fire"
	--------------------------------------------------------------------
	ShotAnim = function (pieces, data, emitterId)
		--Spring.Echo(shotNumber, "(shotNumber) ShotAnim")
		local shotEmitter		= data["flare"]
		CustomEmitter( shotEmitter, data["flare"])
				
		--Spring.Echo("ShotAnim", shotEmitter, shotNumber)
	end,
	
	--------------------------------------------------------------------
	-- animation to do after shots have been fired.
	--------------------------------------------------------------------
	--RestoreAnim = function (animationPieces)

	--end,
		
	--------------------------------------------------------------------
	-- animation to do while aiming
	--------------------------------------------------------------------
	--AimAnim = function (animationPieces, weaponData, heading, pitch)

	--end,
}

return animations
