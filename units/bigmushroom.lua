return {
	bigmushroom = {
		acceleration = 0.2,
		brakerate = 0.1,
		buildcostenergy = 1,
		buildcostmetal = 1,
		builder = 0,
		buildpic = "bigmushroom.png",
		canattack = false,
		canguard = 1,
		canmove = 1,
		canpatrol = 1,
		canstop = 1,
		collisionvolumeoffsets = "0 65 0",
		collisionvolumescales = "83 83 83",
		collisionvolumetype = "sphere",
		explodeas = "mushroompop",
		footprintx = 4,
		footprintz = 4,
		holdsteady = true,
		idleautoheal = 0,
		leavetracks = 0,
		maxdamage = 2000,
		maxslope = 15,
		maxvelocity = 20,
		maxwaterdepth = 20,
		movementclass = "Bot2x2",
		name = "Big Mushroom",
		objectname = "bigmushroom.dae",
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
			moveanim = "headers/bipedal_heavymushroom_movement.lua",
			mushroom = true,
			turnaccel = 500,
		},
		weapons = {
		},
	},
}
