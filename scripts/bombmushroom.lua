-- local cap = piece "Cap"

function script.Killed(recentDamage, maxHealth)
	--Explode(cap,SFX.FIRE);
		
-- 	local x,y,z = Spring.GetUnitPiecePosDir(unitID,cap);
	Spring.SpawnCEG("redpop", x, y, z, 0, 2, 0, 10,10);
	
	return 0
end

-- function script.QueryWeapon(num)
-- 	return cap
-- end
-- 
-- function script.AimFromWeapon(num)
-- 	return cap
-- end
-- 
-- function script.FireWeapon(weaponID)
-- 	return cap
-- end
-- 
-- function script.AimWeapon(num, heading, pitch)
-- 	return true
-- end
