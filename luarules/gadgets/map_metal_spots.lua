function gadget:GetInfo()
	return {
		name      = "Lua Metal Spots",
		desc      = "Places metal spots according to the table returned from metal_spots.lua",
		author    = "Bluestone",
		date      = "April 2014",
		license   = "GPL v3.0 or later",
		layer     = 1, --must run after game_initial_spawn
		enabled   = true  --  loaded by default?
	}
end

if (not gadgetHandler:IsSyncedCode()) then
	return false
end

if (Spring.GetGameFrame() >= 1) then
	--safety
	return 
end

function gadget:Initialize()

	if VFS.FileExists("luarules/configs/metal_spots.lua") then
		include("luarules/configs/metal_spots.lua") --loads the metal_spots table
		--Spring.Echo("Loading metal_spots.lua")
	else
		Spring.Echo("Missing luarules/configs/metal_spots.lua - you will probably desync")
		return
	end

	if(metal_spots and #metal_spots > 0) then
		for i = 1, #metal_spots do
			local x = metal_spots[i].x/16
			local z = metal_spots[i].z/16
			local mAmount = 255 * metal_spots[i].metal
		
			Spring.SetMetalAmount(x, z, mAmount)
			Spring.SetMetalAmount(x, z+1, mAmount)
			Spring.SetMetalAmount(x+1, z, mAmount)
			Spring.SetMetalAmount(x+1, z+1, mAmount)
		end
		Spring.Echo("Set metal spots using metal_spots.lua")
	else 
		Spring.Echo("Failed to set metal spots - you will probably desync")
	end
end


