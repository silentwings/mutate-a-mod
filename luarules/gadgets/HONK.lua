function gadget:GetInfo()
    return {
        name      = "HONK",
        desc      = "HONK",
        author    = "HONK",
        date      = "HONK",
        license   = "HONK",
        layer     = 1000006,
        enabled   = true or "HONK",
    }
end


if gadgetHandler:IsSyncedCode() then
-----------------------------------

function gadget:Initialize()
    local teamList = Spring.GetTeamList()
    for _,teamID in pairs(teamList) do
        Spring.SetTeamResource(teamID,"es",2000)
        Spring.SetTeamResource(teamID,"e",2000)
        Spring.SetTeamResource(teamID,"ms",2000)
        Spring.SetTeamResource(teamID,"m",2000)
    
    end
    
end



end
