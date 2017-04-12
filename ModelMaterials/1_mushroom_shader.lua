-- $Id$
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
local glUniform=gl.Uniform

local healthFactorID

local function DrawUnit(unitID, material)
	if healthFactorID == nil then
		healthFactorID = gl.GetUniformLocation(material.shader, "healthFactor")
	end
	local hp, maxhp = Spring.GetUnitHealth(unitID)
	local healthFactor = hp / maxhp
	glUniform(healthFactorID, healthFactor)

  --// engine should still draw it (we just set the uniforms for the shader)
  return false
end

local materials = {
   mushroom = {
      shader    = include("ModelMaterials/Shaders/mushroomshader.lua"),
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
    normalmushroom       = "mushroom",
	bigmushroom          = "mushroom",
	smallmushroom        = "mushroom",
	mushroomcluster      = "mushroom",
	poisonmushroom       = "mushroom",
	bombmushroom         = "mushroom",
}


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

return materials, unitMaterials

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
