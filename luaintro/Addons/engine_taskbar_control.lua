--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function addon:GetInfo()
  return {
    name      = "Engine Taskbar Stuff",
    desc      = 'Icon, name',
    author    = "KingRaptor",
    date      = "13 July 2011",
    license   = "Public Domain",
    layer     = -math.huge,
    enabled   = true,
  }
end

--------------------------------------------------------------------------------
function addon:Initialize()
	Spring.SetWMIcon("bitmaps/horse.png")
	Spring.SetWMCaption("Just because I can give multiple orgasms to the furniture just by sitting on it, doesn't mean that I'm not sick of this damn war: the blood, the noise, the endless poetry.")
end