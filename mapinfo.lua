--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- mapinfo.lua
--

local mapinfo = {
	name        = "Easter Bunny v2 Horse",
	shortname   = "Horse",
	description = "Just because I can give multiple orgasms to the furniture just by sitting on it, doesn't mean that I'm not sick of this damn war: the blood, the noise, the endless poetry.",
	author      = "Horse",
	version     = "Horse",
	--mutator   = "deployment";
	--mapfile   = "", --// location of smf/sm3 file (optional)
	modtype     = 3, --// 1=primary, 0=hidden, 3=map
	--depend      = {"Map Helper v1"},
	replace     = {},

	maphardness     = 300,
	notDeformable   = false,
	gravity         = 70,
	tidalStrength   = 0,
	maxMetal        = 3.5,
	extractorRadius = 90.0,
	voidWater       = false,
	autoShowMetal   = true,


	smf = {
		minheight = -930,
		maxheight = 1570,
		--smtFileName0 = "",
		--smtFileName1 = "",
		--smtFileName.. = "",
		--smtFileNameN = "",
	},


	resources = {
		--grassBladeTex = "",

		--grassShadingTex = "",
		--detailTex = "",
		--specularTex = "",
		--splatDetailTex = "",
		--splatDistrTex = "",
		--skyReflectModTex = "",
		--detailNormalTex = "",
		--lightEmissionTex = "",
	},

	--[[splats = {
		texScales = {0.02, 0.02, 0.02, 0.02},
		texMults  = {1.0, 1.0, 1.0, 1.0},
	},]]

	atmosphere = {
		minWind      = 0.0,
		maxWind      = 0.0,

		fogStart     = 0.9,
		fogEnd       = 1.0,
		fogColor     = {0.0, 0.0, 0.0},

		sunColor     = {1.0, 1.0, 1.0},
		skyColor     = {0.0, 0.0, 0.0},
		skyDir       = {0.0, 0.0, -1.0},
		skyBox       = "",

		cloudDensity = 0.0,
		cloudColor   = {1.0, 1.0, 1.0},
	},

	grass = {
		bladeWaveScale = 1.0,
		bladeWidth  = 0,
		bladeHeight = 0,
		bladeAngle  = 1.57,
		bladeColor  = {0.59, 0.81, 0.57}, --// does nothing when `grassBladeTex` is set
	},

	lighting = {
		--// dynsun
		sunStartAngle = 0.0,
		sunOrbitTime  = 1440.0,
		sunDir        = {0.0, 1.0, 2.0, 1e9},

		--// unit & ground lighting
		groundAmbientColor  = {1.0, 1.0, 1.0},
		groundDiffuseColor  = {0.5, 0.5, 0.5},
		groundSpecularColor = {0.1, 0.1, 0.1},
		groundShadowDensity = 0.0,
		unitAmbientColor    = {0.8, 0.8, 0.8},
		unitDiffuseColor    = {0.7, 0.7, 0.7},
		unitSpecularColor   = {0.7, 0.7, 0.7},
		unitShadowDensity   = 0.0,
		
		specularExponent    = 100.0,
	},
	
	water = {
		damage =  0.0,

		repeatX = 0.0,
		repeatY = 0.0,

		absorb    = {0.004, 0.004, 0.002},
		baseColor = {0.7, 0.95, 0.95},
		minColor  = {0.6, 0.7, 0.8},

		ambientFactor  = 1.3,
		--diffuseFactor  = 0.3,
		specularFactor = 0.5,
		specularPower  = 2.0,

		--planeColor = {0.0, 0.0, 0.0},

		surfaceColor  = {0.8, 0.9, 0.95},
		surfaceAlpha  = 0,
		--diffuseColor  = {0.55, 0.4, 0.3},
		specularColor = {0.5, 0.5, 0.5},

		fresnelMin   = 0.3,
		fresnelMax   = 0.8,
		fresnelPower = 4.0,

		reflectionDistortion = 1.0,

		blurBase      = 2.0,
		blurExponent = 1.5,

		perlinStartFreq  =  8.0,
		perlinLacunarity = 3.0,
		perlinAmplitude  =  0.9,
		windSpeed = 1.0, --// does nothing yet

		shoreWaves = true,
		forceRendering = false,

		--// undefined == load them from resources.lua!
		--texture =       "",
		--foamTexture =   "",
		--normalTexture = "",
		--caustics = {
		--	"",
		--	"",
		--},
	},

	teams = {
		[0] = {startPos = {x = 1668, z = 3007}},
		[1] = {startPos = {x = 6638, z = 3123}},
		[2] = {startPos = {x = 1658, z = 3017}},
		[3] = {startPos = {x = 6648, z = 3133}},
	},

	terrainTypes = {
		[0] = {
			name = "Default",
			hardness = 1.0,
			receiveTracks = true,
			moveSpeeds = {
				tank  = 1.1,
				kbot  = 1.0,
				hover = 1.5,
				ship  = 1.0,
			},
		},
	},

}

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Helper

local function lowerkeys(ta)
	local fix = {}
	for i,v in pairs(ta) do
		if (type(i) == "string") then
			if (i ~= i:lower()) then
				fix[#fix+1] = i
			end
		end
		if (type(v) == "table") then
			lowerkeys(v)
		end
	end
	
	for i=1,#fix do
		local idx = fix[i]
		ta[idx:lower()] = ta[idx]
		ta[idx] = nil
	end
end

lowerkeys(mapinfo)

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Map Options

if (Spring) then
	local function tmerge(t1, t2)
		for i,v in pairs(t2) do
			if (type(v) == "table") then
				t1[i] = t1[i] or {}
				tmerge(t1[i], v)
			else
				t1[i] = v
			end
		end
	end

	-- make code safe in unitsync
	if (not Spring.GetMapOptions) then
		Spring.GetMapOptions = function() return {} end
	end
	function tobool(val)
		local t = type(val)
		if (t == 'nil') then
			return false
		elseif (t == 'boolean') then
			return val
		elseif (t == 'number') then
			return (val ~= 0)
		elseif (t == 'string') then
			return ((val ~= '0') and (val ~= 'false'))
		end
		return false
	end

	getfenv()["mapinfo"] = mapinfo
		local files = VFS.DirList("mapconfig/mapinfo/", "*.lua")
		table.sort(files)
		for i=1,#files do
			local newcfg = VFS.Include(files[i])
			if newcfg then
				lowerkeys(newcfg)
				tmerge(mapinfo, newcfg)
			end
		end
	getfenv()["mapinfo"] = nil
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

return mapinfo

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
