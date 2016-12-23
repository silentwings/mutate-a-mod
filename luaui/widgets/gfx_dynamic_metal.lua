function widget:GetInfo()
  return {
    name      = "Lua Metal Decals",
    desc      = "Draws a decal on each metal spot",
    author    = "Bluestone",
    date      = "April 2014",
    license   = "GPL v3 or later",
    layer     = 5,
    enabled   = true  --  loaded by default?
  }
end

local displayList 		= 0
local metalSpotWidth    = 64
local metalSpotHeight   = 64
local mode

function widget:Initialize()
	if not WG.metalSpots then
		Spring.Echo("<Lua Metal Decals> This widget requires the 'Metalspot Finder' widget to run.")
		gadgetHandler:RemoveWidget(self)
	end
	
	displayList = gl.CreateList(drawPatches)
end

function drawPatches()
	local mSpots = WG.metalSpots
	
	-- Switch to texture matrix mode
	gl.MatrixMode(GL.TEXTURE)
	
    gl.PolygonOffset(-25, -2)
    gl.Culling(GL.BACK)
    gl.DepthTest(true)
    if math.random()<0.5 then
        gl.Texture("luaui/images/horse.png")
	else
        gl.Texture("luaui/images/horse_flipped.png")    
    end
    gl.Color(1, 1, 1, 0.68) -- fix color from other widgets
	
	for i = 1, #mSpots do
		local metal_rotation = math.random(0, 360)
		gl.PushMatrix()
		gl.Translate(0.5, 0.5, 0)
		gl.Rotate( metal_rotation, 0, 0, 1)   
		gl.DrawGroundQuad( mSpots[i].x - metalSpotWidth/2, mSpots[i].z - metalSpotHeight/2, mSpots[i].x + metalSpotWidth/2, mSpots[i].z + metalSpotHeight/2, false, -0.5,-0.5, 0.5,0.5)
		gl.PopMatrix()
		
	end
    gl.Texture(false)
    gl.DepthTest(false)
    gl.Culling(false)
    gl.PolygonOffset(false)
	
	-- Restore Modelview matrix
	gl.MatrixMode(GL.MODELVIEW)
end

function widget:DrawWorldPreUnit()
	mode = Spring.GetMapDrawMode()
	if(mode ~= "height" and mode ~= "metal") then
		gl.CallList(displayList)
	end
	
end