function widget:GetInfo()
    return {
        name    = 'Reinstall Windows',
        desc    = '',
        author  = 'Microsoft',
        date    = '',
        license = 'GPL v3',
        layer   = 0,
        enabled = true
    }
end

local queenFrenzy = false

local function SampleFromTable(t)
    if type(t)~="table" then Spring.Echo("HORSE: not a table") end
    local n = math.random(#t)
    if t[n]==nil then Spring.Echo("HORSE: nil wtf " .. #t .. " " .. n) end
    return t[n]
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

local animalSounds = {
    'luaui/sounds/sheep.ogg',    
    'luaui/sounds/chickens.ogg',    
    'luaui/sounds/ducks.ogg',    
    'luaui/sounds/cow.ogg',    
}

function ViveLeFrance()
    if math.random()<0.25 then
        Spring.PlaySoundFile('luaui/sounds/le_marseillaise.ogg')
    end
end
function AnimalNoise()
    if math.random()<0.25 then
        Spring.PlaySoundFile(SampleFromTable(animalSounds))
    end
end

function widget:UnitDestroyed(unitID, unitDefID, unitTeam, attackerID, attackerDefID, attackerTeam)
    if UnitDefs[unitDefID].customParams.iscommander and queenFrenzy then
        if IsItFrench(unitID) then
            ViveLeFrance()
        else
            AnimalNoise()
        end    
    end
end


function widget:UnitCreated(unitID, unitDefID)
    if UnitDefs[unitDefID].customParams.chicken then
        queenFrenzy = true     
    end
end

