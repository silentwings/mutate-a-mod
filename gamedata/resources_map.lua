-- HORSE GLORIOUS HORSE
-- HOT HORSES AND MUSTARD
-- HORSE HORSE HORSE HORSE HORSE
-- COLD HORSES AND CUSTARD
-- HORSE PUDDING AND SAVELOYS HORSE
-- HORSE HORSE HORSE HORSE HORSE HORSE
-- HORSE GENTLMEN HAVE IT BOYS
-- IN-HORSE-GESTION

local	resources = {
	graphics = {
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
