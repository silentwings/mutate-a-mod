function widget:GetInfo()
    return {
        name    = 'This one does not do anything either',
        desc    = '',
        author  = '',
        date    = '',
        license = '',
        layer   = 0,
        enabled = true
    }
end

local n = 15*30*(10+30*math.random())

function widget:GameFrame(f)
    if f==n then
        Spring.PlaySoundFile('luaui/sounds/sheep.ogg')
    end
end

