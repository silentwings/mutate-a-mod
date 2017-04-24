-- Wiki: http://springrts.com/wiki/Resources.lua

local	resources = {
	graphics = {
		-- Spring Defaults
		trees = {
			bark		= 'Bark.bmp',
			leaf		= 'bleaf.bmp',
			gran1		= 'gran.bmp',
			gran2		= 'gran2.bmp',
			birch1		= 'birch1.bmp',
			birch2		= 'birch2.bmp',
			birch3		= 'birch3.bmp',
		},
		maps = {
			detailtex	= 'detailtex2.bmp',
			watertex	= 'ocean.jpg',
		},
		groundfx = {
			groundflash	= 'groundflash.tga',
			groundring	= 'groundring.tga',
			seismic		= 'circles.tga',
		},
		projectiletextures = {
			largelove           = 'love_large.png',
			largelove2           = 'love_large2.png',
			largelove3           = 'love_large3.png',
			largelove4           = 'love_large4.png',
			goldlove             = 'love_gold.png',
		},
	}
}

local VFSUtils = VFS.Include('gamedata/VFSUtils.lua')

local function AutoAdd(subDir, map, filter)
	local dirList = RecursiveFileSearch("bitmaps/" .. subDir)
	for _, fullPath in ipairs(dirList) do
		local path, key, ext = fullPath:match("bitmaps/(.*/(.*)%.(.*))")
		if not fullPath:match("/%.svn") then
			local subTable = resources["graphics"][subDir] or {}
			resources["graphics"][subDir] = subTable
			if not filter or filter == ext then
				if not map then
					table.insert(subTable, path)
				else -- a mapped subtable
					subTable[key] = path
				end
			end
		end
	end
end

-- Add mod projectiletextures
AutoAdd("projectiletextures", true)

return resources
