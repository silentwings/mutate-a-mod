local NOWEAPON = {
	name = "horse",
	explosionGenerator = "custom:nothing",
	damage = {
		default = 1e-5, -- 0 is rounded up to 1
	}
}

return lowerkeys{
    NOWEAPON = NOWEAPON,
}
