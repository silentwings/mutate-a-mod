function gadget:GetInfo()
    return {
        name      = "Debug helper",
        desc      = "",
        author    = "",
        date      = "",
        license   = "Je suis Napoleon",
        layer     = -math.pi,
        enabled   = false  -- loaded by default
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
    --Spring.Echo(WeaponDefs[weaponDefID].name .. " was fired")
end

function gadget:UnitCreated(unitID, unitDefID)
    local uDef = UnitDefs[unitDefID]
    local s = uDef.name .. " has "
    for _,t in pairs(uDef.weapons) do
        s = s .. WeaponDefs[t.weaponDef].name .. " and "
    end
    Spring.Echo(s)
end
