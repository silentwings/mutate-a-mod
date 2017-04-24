return {
	normalmushroom = {
		acceleration = 0.2,
		brakerate = 0.1,
		builder = 0,
		buildpic = "normalmushroom.png",
		canattack = 1,
		canguard = 1,
		canmove = 1,
		canpatrol = 1,
		canstop = 1,
		collisionvolumeoffsets = "0 50 1",
		collisionvolumescales = "75 75 75",
		collisionvolumetype = "sphere",
		explodeas = "mushroompop",
		footprintx = 3,
		footprintz = 3,
		holdsteady = true,
		idleautoheal = 0,
		leavetracks = 0,
		maxdamage = 600,
		maxslope = 15,
		maxvelocity = 90,
		maxwaterdepth = 20,
		movementclass = "Bot2x2",
		name = "Normal Mushroom",
		objectname = "normalmushroom.dae",
		radardistance = 0,
		reclaimable = 0,
		releaseheld = true,
		script = "UnitBase.lua",
		shownanoframe = false,
		shownanospray = false,
		sightdistance = 400,
		transportcapacity = 10,
		transportsize = 10,
		turninplace = false,
		turninplaceanglelimit = 90,
		turninplacespeedlimit = 1.6,
		turnrate = 3000,
		upright = 0,
		customparams = {
			basepiece = "Trunk",
			centeraim = "Trunk",
			mountanimdefaultto = "headers/weaponmounts/shroommouth.lua",
			moveanim = "headers/bipedal_mushroom_movement.lua",
			mushroom = true,
			turnaccel = 500,
		},
		weapons = {
		},
	},
}
