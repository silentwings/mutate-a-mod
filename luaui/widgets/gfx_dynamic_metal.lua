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
local metalSpotHeight   = metalSpotWidth
local santaSpotWidth    = 96
local santaSpotHeight   = santaSpotWidth
local mode

function widget:Initialize()
	if not WG.metalSpots then
		Spring.Echo("<Lua Metal Decals> This widget requires the 'Metalspot Finder' widget to run.")
		widgetHandler:RemoveWidget(self)
        return
	end
	
	displayList = gl.CreateList(drawPatches)
end

local decals = {
    --[1] = "luaui/images/bunny.png",
    --[2] = "luaui/images/bunny_flipped.png",    
    --[3] = "luaui/images/horse.png",
    --[4] = "luaui/images/horse_flipped.png",
    [1] = "luaui/images/egg_1.png",
    [2] = "luaui/images/egg_2.png",
    [3] = "luaui/images/egg_3.png",
    [4] = "luaui/images/egg_4.png",
    [5] = "luaui/images/egg_5.png",
    [6] = "luaui/images/egg_6.png",
}

local santas = {
    [1] = "luaui/images/santa_1.tga",
    [2] = "luaui/images/santa_2.tga",
    [3] = "luaui/images/santa_3.tga",
    [4] = "luaui/images/santa_4.tga",
    [5] = "luaui/images/santa_5.tga",
    [6] = "luaui/images/santa_6.tga",
    [7] = "luaui/images/santa_7.tga",
    [8] = "luaui/images/santa_8.tga",
    [9] = "luaui/images/santa_9.tga",
    [10] = "luaui/images/santa_10.tga",
}

local function SampleFromArrayTable(t)
    if #t==0 then Spring.Echo("sampling from empty table") end
    local n = #t
    local m = 1+math.floor(math.random()*n)
    return t[m]
end

function drawPatches(decal)
	local mSpots = WG.metalSpots
	
	-- Switch to texture matrix mode
	gl.MatrixMode(GL.TEXTURE)
	
    gl.PolygonOffset(-25, -2)
    gl.Culling(GL.BACK)
    gl.DepthTest(true)
	
	for i = 1, #mSpots do
        local santa = false
        if math.random()<0.95 then
            gl.Texture(SampleFromArrayTable(decals))
        else
            gl.Texture(SampleFromArrayTable(santas)) 
            santa = true
        end
        gl.Color(1, 1, 1, 0.9) -- fix color from other widgets

        local metal_rotation = santa and 0 or math.random(0, 360)
		gl.PushMatrix()
		gl.Translate(0.5, 0.5, 0)
		gl.Rotate( metal_rotation, 0, 0, 1)   
        if santa then
            gl.DrawGroundQuad( mSpots[i].x - santaSpotWidth/2, mSpots[i].z - santaSpotHeight/2, mSpots[i].x + santaSpotWidth/2, mSpots[i].z + santaSpotHeight/2, false, -0.5,-0.5, 0.5,0.5)
		else
            gl.DrawGroundQuad( mSpots[i].x - metalSpotWidth/2, mSpots[i].z - metalSpotHeight/2, mSpots[i].x + metalSpotWidth/2, mSpots[i].z + metalSpotHeight/2, false, -0.5,-0.5, 0.5,0.5)
		end
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
	if mode ~= "height" and mode ~= "metal" then
		gl.CallList(displayList)
        shown = true
    elseif mode=="metal" and shown then
        displayList = gl.CreateList(drawPatches)    
        shown = false
    end
end