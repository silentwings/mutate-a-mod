common = {
	GeneraleAnimationData = function (	weaponDesignation, weaponUnitDef, 
										weaponDefCustom, mountDesignation,
										weaponBarrelAxis, weaponRecoildir,
										emitterAxel, emitterRotation, 
										emitterBackRotation)
		local pieceList 	= {}
		local weaponData	= {}		
		local counter		= 1
		local weapoDefId	= weaponUnitDef.weaponDef
		
		local burst			= WeaponDefs[weapoDefId].salvoSize
		local burstRate		= WeaponDefs[weapoDefId].salvoDelay
		local projectiles	= WeaponDefs[weapoDefId].projectiles	
		local shotCount		= tonumber(weaponDefCustom.count)
		

		-- setup emitters tables, 
		pieceList["emitters"]			= {}
		-- backblast is used for recoilless weapons
		pieceList["weaponBackblast"]	= {}
		-- how many total shots
		weaponData["shotCount"]		= 1
		-- how many shots per volley
		weaponData["barrelCount"]	= 1	
		-- how many shots per volley
		weaponData["volleyCount"]	= 1	
		-- how many shots per volley
		weaponData["emitterResetCounter"]	= 1			
		-- default axis of rotation
		weaponData["barrelAxis"]		= weaponBarrelAxis
		-- direction of weapon recoil. 
		-- Most will be -1
		weaponData["recoilDirection"]	= weaponRecoildir
		
		--Spring.Echo(weaponData["barrelAxis"], weaponBarrelAxis, weaponRecoildir,
		--			emitterAxel, emitterRotation, 
		--			emitterBackRotation)
		-- linked covers when we are firing from 
		-- several guns/barrels as part of 1 weapon
		--
		-- Ex: double barrel shotgun
		-- linked		= 2, 
		-- projectiles	= 10
		--
		-- Ex: missile pod
		-- linked 		= 2,
		-- burst		= 4,
		-- burstrate 	= 0.1,
		
		-- if the weapon has a really fast burstfire  this will
		-- take priority over projectiles count
		if shotCount then
			weaponData.shotCount	= shotCount
		elseif burst > projectiles then
			weaponData.shotCount	= burst			
		elseif projectiles then
			weaponData.shotCount	= projectiles
			weaponData.volleyCount	= burst
		end
		
		-- linked fire property
		local linkedCount	= tonumber(weaponDefCustom.linked)			
		if linkedCount then
			if linkedCount >  weaponData.shotCount then
				Spring.Echo("weapon is set as linked but shot count is too low."..
							"\n check your projectiles or burst values in the unit definition file")
			else
				--Spring.Echo("weaponDefCustom.linked", weaponData["shotCount"],linkedCount, weaponData["shotCount"]/linkedCount)
				weaponData.barrelCount = math.floor(weaponData.shotCount/linkedCount)
			end
		else
			weaponData.shotCount = weaponData.shotCount	
		end
		
		--Spring.Echo(weaponData.shotCount)
		
		-- set how long until we need to reset our emitter id
		weaponData.emitterResetCounter = (weaponData.shotCount* weaponData.volleyCount)/weaponData.barrelCount
		--Spring.Echo(weaponData.shotCount, burst, projectiles)
			
			
		-- gather effect emmiter point data
		--Spring.Echo("emmiter count" , weaponData.emitterResetCounter)
		while ( counter-1 < weaponData.emitterResetCounter) do
			pieceList.emitters[counter]	= piece (weaponDesignation .. "_a_" .. counter)
			--Spring.Echo(weaponDesignation .. "_a_" .. counter)
			if (weaponDefCustom.recoilless)then
				local backBlastPart = piece (weaponDesignation .. "_b_" .. counter)
				pieceList.weaponBackblast[counter]	= backBlastPart
			end
			
			--Spring.Echo("emitters", counter, 
			--			weaponDesignation .. "_a_" .. counter, 
			--			piece (weaponDesignation .. "_a_" .. counter))
			
			counter = counter + 1
		end
				
		if(pieceList.emitters)then											
			for _,v in pairs(pieceList.emitters) do
				Turn(v, emitterAxel, emitterRotation, 10)
			end
		end
		
		if(pieceList.weaponBackblast)then											
			for _,v in pairs(pieceList.weaponBackblast) do
				Turn(v, emitterAxel, emitterBackRotation, 10)
			end
		end
		
		-- muzzle flare effect
		if weaponDefCustom.effect1 then
			weaponData["flare"] = weaponDefCustom.effect1
		elseif weaponDefCustom.effect1 == nil then
			Spring.Echo("Warning!!!: Weapon: ".. weaponDesignation ..
						" missing defined effect for shot!")
		end
		
		-- backblast effect(s) for recoilless weapon
		if weaponDefCustom.recoilless then
			weaponData["recoilless"]	= true
			if weaponDefCustom.effect2 then
				weaponData["backblast"] = weaponDefCustom.effect2
			elseif weaponData["flare"] ~= nil then
				weaponData["backblast"] = weaponData["flare"]
			else
				Spring.Echo("Warning!!!: Weapon: ".. weaponDesignation ..
							" missing defined effect for shot backblast!")
			end
		end	
		return pieceList, weaponData
	end,
}
return common