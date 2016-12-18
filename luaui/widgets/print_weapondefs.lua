function widget:GetInfo()
    return {
        name      = "ACME",
        desc      = "ACME",
        author    = "",
        date      = "",
        license   = "",
        layer     = 0,
        enabled   = false
    }
end

function widget:Initialize()
    for wDID,wDef in pairs(WeaponDefs) do
        if string.find(wDef.name or "", "acme") then
            Spring.Echo("WeaponDef: " .. tostring(wDID))
            for k,v in wDef:pairs() do
                Spring.Echo(k,v)
            end
        end
    end
end