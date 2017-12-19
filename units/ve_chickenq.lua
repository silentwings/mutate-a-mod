return {
	ve_chickenq = {
		acceleration = 1.2,
		airsightdistance = 2400,
		autoheal = 5,
		bmcode = "1",
		brakerate = 2,
		buildcostenergy = 2000000,
		buildcostmetal = 50000,
		builder = false,
		buildtime = 1000000,
		canattack = true,
		canguard = true,
		canmove = true,
		canpatrol = true,
		canstop = "1",
		cantbetransported = true,
		category = "MOBILE WEAPON NOTAIR NOTSUB NOTHOVER NOTSHIP ALL SURFACE",
		collisionspherescale = 1.75,
		collisionvolumeoffsets = "0 -52 15",
		collisionvolumescales = "60 130 140",
		collisionvolumetest = 1,
		collisionvolumetype = "box",
		corpse = "DEAD",
		defaultmissiontype = "Standby",
		description = "Clucking Hell! (Very Easy)",
		explodeas = "QUEEN_DEATH",
		footprintx = 3,
		footprintz = 3,
		icontype = "chickenq",
		leavetracks = true,
		maneuverleashlength = 2000,
		mass = 2000000,
		maxdamage = 75000,
		maxslope = 40,
		maxvelocity = 2.9,
		maxwaterdepth = 70,
		movementclass = "CHICKQUEENHOVER",
		name = "Chicken Queen",
		noautofire = false,
		nochasecategory = "VTOL",
		objectname = "ve_chickenq.s3o",
		pushresistant = true,
		seismicsignature = 4,
		selfdestructas = "QUEEN_DEATH",
		side = "THUNDERBIRDS",
		sightdistance = 1250,
		smoothanim = true,
		steeringmode = "2",
		tedclass = "KBOT",
		trackoffset = 18,
		trackstrength = 8,
		trackstretch = 1,
		tracktype = "ChickenTrack",
		trackwidth = 100,
		turninplace = 0,
		turnrate = 400,
		unitname = "ve_chickenq",
		upright = false,
		workertime = 0,
        customparams = {
            chicken = true,
            mushroom = true,
        },
		featuredefs = {
			dead = {},
			heap = {},
		},
		sfxtypes = {
			explosiongenerators = {
				[1] = "custom:dirt_hearts",
				[2] = "custom:dirt_hearts_big",
				[3] = "custom:red_pop",
			},
		},
		weapondefs = {
			goo = {
				areaofeffect = 200,
				avoidfeature = 0,
				avoidfriendly = 0,
				burst = 5,
				burstrate = 0.01,
				cegtag = "dirt_hearts",
				collidefriendly = 0,
				craterboost = 0,
				cratermult = 0,
				edgeeffectiveness = 0.33,
				explosiongenerator = "custom:dirt_hearts_big",
                explosionscar = false,
				impulseboost = 0,
				impulsefactor = 0,
				intensity = 0.7,
				interceptedbyshieldtype = 1,
				model = "SGreyRock1.S3O",
				name = "Blob",
				noselfdamage = true,
				proximitypriority = -4,
				range = 750,
				reloadtime = 5,
				rgbcolor = "0.1 0.6 1",
				size = 8,
				sizedecay = 0,
				soundhit = "xplomed2",
				soundstart = "bigchickenroar",
				sprayangle = 4096,
				tolerance = 5000,
				turret = true,
				weapontimer = 0.2,
				weaponvelocity = 400,
				damage = {
					bombers = 9999,
					chicken = 400,
					default = 1200,
					fighters = 9999,
					vtol = 1000,
				},
			},
			melee = {
				areaofeffect = 60,
				avoidfeature = 0,
				avoidfriendly = 0,
				camerashake = 0,
				collidefriendly = 0,
				craterboost = 0,
				cratermult = 0,
				explosiongenerator = "custom:NONE",
                explosionscar = false,
				impulseboost = 1.5,
				impulsefactor = 1.5,
				name = "ChickenClaws",
				noselfdamage = true,
				range = 260,
				reloadtime = 1.65,
				size = 0,
				soundstart = "bigchickenbreath",
				tolerance = 5000,
				turret = true,
				waterweapon = true,
				weapontype = "Cannon",
				weaponvelocity = 2500,
				damage = {
					bombers = 9999,
					chicken = 0.001,
					default = 1500,
					fighters = 9999,
					tinychicken = 0.001,
					vtol = 1500,
				},
			},
			spores1 = {
				areaofeffect = 0,
				damage = {
					default = 0,
				},
			},
			spores2 = {
				areaofeffect = 0,
				damage = {
					default = 0,
				},

			},
			spores3 = {
				areaofeffect = 0,
				damage = {
					default = 0,
				},
			},
        },
		weapons = {
			[1] = {
				def = "MELEE",
				maindir = "0 0 1",
				maxangledif = 155,
			},
			[2] = {
				badtargetcategory = "NOTAIR",
				def = "SPORES1",
			},
			[3] = {
				badtargetcategory = "WEAPON",
				def = "SPORES2",
			},
			[4] = {
				badtargetcategory = "NOWEAPON",
				def = "SPORES3",
			},
			[5] = {
				def = "GOO",
				maindir = "0 0 1",
				maxangledif = 120,
			},

		},
	},
}
