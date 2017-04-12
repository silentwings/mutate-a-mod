--common = VFS.Include("scripts/headers/weapons/commonAnimationFunctions.lua")
--Spring.Echo(common)

animations = {
	--------------------------------------------------------------------
	-- returns all our data and pieces for the animation script
	--------------------------------------------------------------------
	GetAnimationData = function (weaponDesignation, weaponUnitDef, weaponDefCustom, 
								mountDesignation, weaponDirection)
	
			
		local emitterRotation		= 0
		local emitterAxel			= y_axis
		local emitterBackRotation	= math.rad(180)
		
		-- default axis of rotation
		local weaponBarrelAxis		= z_axis
		-- direction of weapon recoil. 
		local weaponRecoildir	= -1
			
		if weaponDirection and weaponDirection == "y_axis" then
			weaponBarrelAxis			= y_axis
			weaponRecoildir 			= 1
			emitterAxel					= x_axis
			emitterRotation				= math.rad(90)
			emitterBackRotation			= -emitterRotation
		end

		
		-- get the common elements used by my custom tags
		local pieceList, weaponData = common.GeneraleAnimationData(	weaponDesignation, weaponUnitDef, 
																	weaponDefCustom, mountDesignation, 
																	weaponBarrelAxis, weaponRecoildir,
																	emitterAxel, emitterRotation, 
																	emitterBackRotation)
		
		-- pieces for aim animation		
		pieceList["weaponBarrel"] = piece (weaponDesignation .. "_a_barrel")
		
		return pieceList, weaponData
	end,
	
	--------------------------------------------------------------------
	-- animation to on each "fire" of the weapon
	--------------------------------------------------------------------
	FireAnim = function (animationPieces, weaponData)
		Move(animationPieces["weaponBarrel"], weaponData["barrelAxis"],  weaponData["recoilDirection"])
		Move(animationPieces["weaponBarrel"], weaponData["barrelAxis"], 0, 1)
	end,
	
	--------------------------------------------------------------------
	-- animation to on each "shot" of the weapon "fire"
	--------------------------------------------------------------------
	ShotAnim = function (pieces, data, emitterId)
		--Spring.Echo(shotNumber, "(shotNumber) ShotAnim")
		local shotEmitter		= pieces["emitters"][emitterId]
		CustomEmitter( shotEmitter, data["flare"])
				
		if data["recoilless"] then	
			CustomEmitter( pieces["weaponBackblast"][emitterId]	, data["backblast"])
		end

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
