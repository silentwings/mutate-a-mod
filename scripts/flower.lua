function script.Create()
	--local x,y,z = Spring.GetUnitPosition(unitID);
	--Spring.SpawnCEG("red_pop", x, y, z, 0, 0, 0, 0);
    return 0
end

function script.Killed(recentDamage, maxHealth)
	local x,y,z = Spring.GetUnitPosition(unitID);
	Spring.SpawnCEG("red_pop", x, y, z, 0, 0, 0, 0);
	return 0
end
