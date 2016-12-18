function gadget:GetInfo()
    return {
        name      = "Debug helper",
        desc      = "",
        author    = "",
        date      = "",
        license   = "",
        layer     = -math.pi,
        enabled   = true  -- loaded by default
    }
end

if not gadgetHandler:IsSyncedCode() then
    return false
end

function gadget:Initialize()
    for _,wDef in pairs(WeaponDefs) do
        Script.SetWatchWeapon(wDef.id, true)
    end
end

function gadget:ProjectileCreated(proID, proOwnerID, weaponDefID)
    Spring.Echo(WeaponDefs[weaponDefID].name .. " was fired")
end
