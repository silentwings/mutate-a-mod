-- $Id$
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
local GetGameFrame=Spring.GetGameFrame
local GetUnitHealth=Spring.GetUnitHealth
local modulo=math.fmod
local glUniform=gl.Uniform
local sine =math.sin
local maximum=math.max

local frameLocID, healthFactorID, grownPercentageID, heightID, colorFactorID

local function DrawUnit(unitID, material)
	if frameLocID == nil then
		frameLocID = gl.GetUniformLocation(material.shader, "frameLoc")
		healthFactorID = gl.GetUniformLocation(material.shader, "healthFactor")
		grownPercentageID = gl.GetUniformLocation(material.shader, "grownPercentage")
		heightID = gl.GetUniformLocation(material.shader, "height")
		colorFactorID = gl.GetUniformLocation(material.shader, "colorFactor")
	end
	local unitDefID = Spring.GetUnitDefID(unitID)
	local unitDef = UnitDefs[unitDefID]
	local factor = 0.0001
	if unitDef.customParams.tree then
		factor = 0.002
	elseif unitDef.customParams.shrubs then
		factor = 0.008
	end
	local frame = factor * sine(modulo(unitID, 10) + GetGameFrame() / (modulo(unitID, 7) + 6))
	glUniform(frameLocID, frame)
	
	local hp, maxhp = Spring.GetUnitHealth(unitID)
	local healthFactor = hp / maxhp
	glUniform(healthFactorID, healthFactor)
	
	local createdFrame = Spring.GetUnitRulesParam(unitID, "createdFrame") or 0
	local growTime = 33 * 0.5
	local duration = Spring.GetGameFrame() - createdFrame
	local grownPercentage = math.min(1, duration / growTime)
	if not unitDef.customParams.tree then
		grownPercentage = 1
	end
	glUniform(grownPercentageID, grownPercentage)
	--glUniform(grownPercentageID, 0.5)
	
	local height = Spring.GetUnitHeight(unitID)
	glUniform(heightID, height)
	
	local colorFactor = 0
	if unitDef.customParams.tree then
		local progress = Spring.GetUnitRulesParam(unitID, "upgradeProgress") or 0
		if progress > 0 then
			colorFactor = (math.sin(GetGameFrame() / 3 * (progress-0.5)) / math.pi + 1) / 2.5
		end
	end
	glUniform(colorFactorID, colorFactor)
--   health,maxhealth=GetUnitHealth(unitID)
--   glUniform(material.healthLoc, 2*maximum(0, (-2*health)/(maxhealth)+1) )
  
  --Spring.Echo('Drawing tree in 1_tree_normalmapping.lua!')
  --inverse of health, 0 if health is 100%-50%, goes to 1 by 0 health


  --// engine should still draw it (we just set the uniforms for the shader)
  return false
end

local materials = {
   tree = {
      shader    = include("ModelMaterials/Shaders/treeshader.lua"),
      force     = true, --// always use the shader even when normalmapping is disabled
      usecamera = false,
      culling   = GL.BACK,
      texunits  = {
        [0] = '%%UNITDEFID:0',
        [1] = '%%UNITDEFID:1',
        [2] = '$shadow',
        [3] = '$specular',
        [4] = '$reflection',
      },
      DrawUnit = DrawUnit
   }
}

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- affected unitdefs

local unitMaterials = {
   treelevel1 = "tree",
   treelevel2 = "tree",
   treelevel3 = "tree",
   
--    grass1 = "tree",
--    grass2 = "tree",
--    grass3 = "tree",
--    grass4 = "tree",
--    grass5 = "tree",
--    
--    flower1 = "tree",
--    flower2 = "tree",
--    flower3 = "tree",
--    flower4 = "tree",
--    flower5 = "tree",
--    flower6 = "tree",
   
   spire = "tree",
}


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

return materials, unitMaterials

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
