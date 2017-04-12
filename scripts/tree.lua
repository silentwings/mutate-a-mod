function script.Killed(recentDamage, maxHealth)
	local x,y,z = Spring.GetUnitPosition(unitID);
	local trunk = piece('Trunk');
	Spring.SpawnCEG("blackpop", x, y, z, 0, 2, 0, 10,10);
	Turn(trunk,z_axis,2,1);	
	WaitForTurn(trunk,z_axis);
	return 0
end
