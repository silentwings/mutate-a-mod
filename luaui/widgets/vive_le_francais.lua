function widget:GetInfo()
    return {
        name    = 'This one does not do anything',
        desc    = '',
        author  = '',
        date    = '',
        license = 'secret knee trembler',
        layer   = 0,
        enabled = true
    }
end

function IsItFrench(unitID)
    local teamID = Spring.GetUnitTeam(unitID)
    local playerList = Spring.GetPlayerList(teamID)
    for _,pID in pairs(playerList) do
        local _,_,_,_,_,_,_,country = Spring.GetPlayerInfo(pID)
        if country == "fr" then
            return true
        end
    end
    return false
end

function ViveLeFrance()
    Spring.PlaySoundFile('luaui/sounds/le_marseillaise.ogg')
end

function widget:UnitDestroyed(unitID, unitDefID, unitTeam, attackerID, attackerDefID, attackerTeam)
    if UnitDefs[unitDefID].customParams.iscommander and IsItFrench(unitID) then
        ViveLeFrance()
    end
end

