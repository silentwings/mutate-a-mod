-------------------------------------------------------
-- License:	Public Domain
-- Author:	Steve (Smoth) Smith
-- Date:	11/27/2012
-------------------------------------------------------
-- utility variables
local spSpawnCEG			= Spring.SpawnCEG
local spGetUnitDefID		= Spring.GetUnitDefID
local spGetUnitPiecePosDir	= Spring.GetUnitPiecePosDir

axisLookup			= {	["x_axis"] = 1,	["y_axis"] = 2,	["z_axis"] = 3,	}

-- Signal definitions
local SIG_AIM	=	{} 

for i=1,	32 do 
	SIG_AIM[i] = {} 
end
			
-- State variables
isMoving	= false
inMovment	= false
isAiming	= false
myUnitDef	= UnitDefs[spGetUnitDefID(unitID)]

-- Piece names
local base
--Spring.Echo(myUnitDef.customParams, myUnitDef.customParams.basepiece)

if myUnitDef.customParams.basepiece then
	--Spring.Echo("base",	myUnitDef.customParams.basepiece)
	base = 	piece (myUnitDef.customParams.basepiece)
else
	base = piece 'base'
end
			
-- animation tables
local startingAnimation		= {}
local aimingAnimation		= {}
local resetAimAnimation		= {}
local fireAnimation			= {}
local shotAnimation			= {}
local deathAnimation		= {}

local moveData				= {}
local weaponData			= {}
local deathData				= {}
local weaponMountData		= {}

local stopAnimation
local moveAnimation			
local mountAimingAnimation	= {}
local mountResetAnimation	= {}
local mountStartAnimation	= {}

local moveAnimationPieces	= {}
local mountAnimationPieces	= {}
local weaponAnimationPieces	= {}
local weaponEmitterId		= {}
local weaponCurrentShot		= {}
local weaponQueryPiece		= {}
local deathAnimationPieces	= {}

	
function CustomEmitter(pieceName, effectName)
	--Spring.Echo(unitID, pieceName, effectName)
	local x,y,z,dx,dy,dz	= spGetUnitPiecePosDir(unitID,pieceName)
			
	Spring.SpawnCEG(effectName, x,y,z, dx, dy, dz)
end

-- use when you are unsure of a piece existing.
function VerifiedMove(piece, axis, direction, speed)
	if piece then
		Move(piece, axis, direction, speed)
	end
end	

-- use when you are unsure of a piece existing.
function VerifiedTurn(piece, axis, rotation, speed)
	if piece then
		Turn(piece, axis, rotation, speed)
	end
end

-- use when you are unsure of a piece existing.
function VerifiedExplode(piece, specialEffects)
	if piece then
		Explode(piece, specialEffects)
	end
end

local function getWeaponData()
	weapons	= myUnitDef.weapons
	
	for weaponNum, weaponUnitDef in pairs(weapons) do
		local weaponDesignation 		= "weapon".. weaponNum
		local mountDesignation 			= "mount".. weaponNum
		local weaponDefCustom			= WeaponDefs[weaponUnitDef.weaponDef].customParams
		local weaponDirection			= myUnitDef.customParams[mountDesignation .."dir"]
		weaponData[weaponNum]			= {}
		weaponQueryPiece[weaponNum]		= base
		
		if weaponDefCustom.abilityweapon then
			weaponData[weaponNum]["abilityWeapon"]				= weaponDefCustom.abilityweapon
			weaponAnimationPieces[weaponNum]					= {}
			weaponAnimationPieces[weaponNum]["emitters"]		= { [1]	= base}
			weaponAnimationPieces[weaponNum]["weaponBarrel"]	= base
			weaponData[weaponNum]["shotCount"]					= 1
		else
			
			local mountAnim
			 
			if myUnitDef.customParams["mount".. weaponNum .."anim"] then
				mountAnim = 	myUnitDef.customParams["mount".. weaponNum .."anim"]
			else
				mountAnim = 	myUnitDef.customParams.mountanimdefaultto
			end
			
			if mountAnim then
				local mountAnimations = include(mountAnim)
				
				if mountAnimations.GetAnimationPieces then
					mountAnimationPieces[weaponNum], weaponMountData[weaponNum] = 
					mountAnimations.GetAnimationPieces(weaponDesignation, weaponUnitDef, weaponDefCustom)
				end
				
				if mountAnimations.StartAnim then
					mountAnimations.StartAnim(mountAnimationPieces[weaponNum], weaponMountData[weaponNum])
				end
				
				if mountAnimations.RestoreAnim then
					mountResetAnimation[weaponNum] = mountAnimations.RestoreAnim
				end
				
				if	mountAnimations.AimAnim then
					mountAimingAnimation[weaponNum] = mountAnimations.AimAnim
				end
				
				if	mountAnimations.FireAnim then 
					mountFireAnimation[weaponNum] = mountAnimations.FireAnim
				end		
			end
			
			-- unit has a special animation			
			local weaponAnim = 	weaponDefCustom.animation
			
			if weaponAnim then
				local weaponAnimations = include(weaponAnim)
				if weaponAnimations.GetAnimationData then
					--Spring.Echo("got animation data")
					common = include("headers/weapons/commonAnimationFunctions.lua")
					--Spring.Echo(common)
					weaponAnimationPieces[weaponNum], weaponData[weaponNum] = 
					weaponAnimations.GetAnimationData(	weaponDesignation, weaponUnitDef, 
														weaponDefCustom, mountDesignation,
														weaponDirection)

					-- grab intial piece for each weapon
					--Spring.Echo("weaponAnimationPieces[weaponNum].emitters[1]",
					--			weaponAnimationPieces[weaponNum].emitters[1])
					weaponQueryPiece[weaponNum] = weaponAnimationPieces[weaponNum].emitters[1]
					weaponCurrentShot[weaponNum] = 1
				end
				
				if weaponAnimations.RestoreAnim then
					resetAimAnimation[weaponNum] = weaponAnimations.RestoreAnim	
				end
				
				if weaponAnimations.StartingAnim then
					weaponAnimations.StartingAnim(weaponAnimationPieces[weaponNum], weaponData[weaponNum])
				-- if we have no start anim, use the reset animation
				elseif resetAimAnimation[weaponNum] then
					weaponAnimations.RestoreAnim(weaponAnimationPieces[weaponNum], weaponData[weaponNum])
				end
				
				if	weaponAnimations.AimAnim then
					aimingAnimation[weaponNum] = weaponAnimations.AimAnim
				end
				if	weaponAnimations.FireAnim then
					fireAnimation[weaponNum] = weaponAnimations.FireAnim
				end	
				if	weaponAnimations.ShotAnim then
					shotAnimation[weaponNum] = weaponAnimations.ShotAnim
				end		
			end

			-- allow units to use a single specific piece for aiming
			if myUnitDef.customParams.centeraim and weaponAnimationPieces[weaponNum]then
				weaponAnimationPieces[weaponNum]["centeraim"] = piece (myUnitDef.customParams.centeraim)
			end
			
		end
	end
end

function script.StartMoving()
	
	isMoving = true
	--Spring.Echo("startMoving", isMoving)
	if moveAnimation ~= nil then
		StartThread(moveAnimation,moveAnimationPieces, moveData, stopAnimation)
	end
	return
end

function script.StopMoving()
	isMoving = false
	--Spring.Echo("stopMoving", isMoving)
	return
end	

--------------------------------------------------------
--start ups :)
--------------------------------------------------------
function script.Create()
-- setup animation pieces
	-- load move anim lua file
	local moveAnim = myUnitDef.customParams.moveanim
	
	if moveAnim then
		local moveAnimations = include(moveAnim)
		
		if moveAnimations.getMovePieces then
			moveAnimationPieces, moveData = moveAnimations.getMovePieces()
		end
							
		if moveAnimations.moveAnim then
			moveAnimation = moveAnimations.moveAnim
		end		
					
		if moveAnimations.stopAnim then			
			stopAnimation = {}
			stopAnimation = moveAnimations.stopAnim
			stopAnimation(moveAnimationPieces, moveData)
		end	
		
		moveData["movspeed"] = (Spring.GetUnitMoveTypeData(unitID)).maxSpeed/30
		
		--Spring.Echo(moveData["movspeed"])
	end
	--Spring.Echo("got move data")
	
	-- unit has a special animation	for death		
	local deathAnim = myUnitDef.customParams.deathanim

	if deathAnim then
		local deathAnimations = include(deathAnim)
		if deathAnimations and deathAnimations.GetAnimationData then
			deathAnimationPieces, deathData = deathAnimations.GetAnimationData()
		end
				
		if deathAnimations and deathAnimations.DeathAnim then
			deathAnimation = deathAnimations.DeathAnim
		end	
	end
			
	getWeaponData()
	--Spring.Echo("got weapon data")
end
		
-----------------------------------------------------------------------
-- ability functions;
-- to be modularized.
-----------------------------------------------------------------------	
function Ability()
	--EmitSfx(piece 'smoke', 2049)
end

-----------------------------------------------------------------------
-- gun functions;
-----------------------------------------------------------------------	
function script.AimFromWeapon(weaponID)
	if weaponAnimationPieces[weaponID] then
		if weaponAnimationPieces[weaponID]["centeraim"] then
			return weaponAnimationPieces[weaponID]["centeraim"]
		else
			return weaponAnimationPieces[weaponID]["weaponBarrel"]
		end
	else
		return base
	end	
end

function script.QueryWeapon(weaponID)
	--Spring.Echo("weaponQueryPiece", weaponQueryPiece[weaponID])
	-- adding tonumber because it is supposed to be a num, not a val...
	
	-- because now this gets called before create() is done... stupid.
	-- was like, version 99/98, more testing needed but IDGAF!
	if weaponQueryPiece[weaponID] then
		return weaponQueryPiece[weaponID]
	else
		--Spring.Echo(base)
		return base
	end
end

-----------------------------------------------------------------------
-- This coroutine is restarted with each time a unit reaims, 
-- not the most efficient and should be optimized. Possible
-- augmentation needed to lus.
-----------------------------------------------------------------------
local function RestoreAfterDelay(weaponID)
	Sleep(1000)
	local turretDirection = 0	
	
	if resetAimAnimation[weaponID] then
		resetAimAnimation[weaponID](weaponAnimationPieces[weaponID], weaponData[weaponID])
	end		
	
	if mountResetAnimation[weaponID]then
		mountResetAnimation[weaponID](mountAnimationPieces[weaponID], weaponMountData[weaponID])
	end	
	
	isAiming = false
end

function script.AimWeapon(weaponID, heading, pitch)
	if(weaponData[weaponID]["abilityWeapon"]) then
		return false
	end
	
	--Spring.Echo("aiming")
	isAiming = true
	
	Signal(SIG_AIM[weaponID])
	SetSignalMask(SIG_AIM[weaponID])
	
	if aimingAnimation[weaponID] then
		aimingAnimation[weaponID](weaponAnimationPieces[weaponID], weaponData[weaponID], heading, pitch)
	end	
	
	if mountAimingAnimation[weaponID] then
		mountAimingAnimation[weaponID](mountAnimationPieces[weaponID], weaponMountData[weaponID], heading, pitch)
	end		
	
	StartThread(RestoreAfterDelay, weaponID)
	return true
end

-- triggers per individual weapon fire
function script.FireWeapon(weaponID)
	--Spring.Echo("FireWeapon")
	if fireAnimation[weaponID] then
		fireAnimation[weaponID](weaponAnimationPieces[weaponID], weaponData[weaponID])
	end	
end

-- triggers per individual shot fired
function script.Shot(weaponID)
	local data				= weaponData[weaponID]
	local pieces			= weaponAnimationPieces[weaponID]
	local emitterId			= weaponEmitterId[weaponID] or 1
	local curretShot		= weaponCurrentShot[weaponID] or 1
	
	--Spring.Echo("\n curretShot: " .. curretShot, "data.barrelCount: " ..data.barrelCount,
	--			"\n emitterId: " .. emitterId,
	--			"\n volleyCount: " .. data.volleyCount, "data.shotCount: " .. data.shotCount)
	
	if shotAnimation[weaponID] then
		shotAnimation[weaponID](pieces, data, emitterId)
	end		

	--set query peice
	if pieces then
		weaponQueryPiece[weaponID]	= pieces.emitters[emitterId]	
	end
	
	--Spring.Echo(data.shotCount, emitterId, currentEmitter)

	-- time to switch to different linked emitter?
	if data.shotCount and data.shotCount > 1 then
		--Spring.Echo("curretShot: " .. curretShot, 
		--			"emitterId: " .. emitterId,
		--			"volleyCount: " .. data.volleyCount)
		
		if data.barrelCount <= curretShot then
			emitterId = emitterId + 1
			weaponCurrentShot[weaponID] = 1
		else
			weaponCurrentShot[weaponID] = curretShot + 1
		end

		--are we done with the current emitter cycle?
		if emitterId-1 < data.emitterResetCounter then
			weaponEmitterId[weaponID] = emitterId
		else
			weaponEmitterId[weaponID] = 1

			---Spring.Echo("         counter reset")
		end		
	end
end


-----------------------------------------------------------------------
-- death functions;
-----------------------------------------------------------------------	

function script.Killed(recentDamage, maxHealth)
	local severity = 1 
	local spawnx, spawny, spawnz = Spring.GetUnitPosition(unitID)
	Spring.SpawnCEG("red_pop", spawnx, spawny, spawnz, 0, 0, 0, 0)

	if	type(deathAnimation) == "function" then
		deathAnimation(deathAnimationPieces, deathData, recentDamage, maxHealth)
	else
		--local x,y,z,dx,dy,dz	= Spring.GetUnitPiecePosDir(unitID,base)
		--Spring.SpawnCEG("bigbulletimpact",x,y,z)
		
		Sleep (10)	
		if (severity <= 99) then
			return 3
		else
			return 0
		end
	end

end
