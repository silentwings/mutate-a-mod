local horse = {
	{
		key     = 'randomseed',
		name    = 'Random Seed Bunny',
		desc    = 'The cat in the hat sat on the mat', -- 0 -> use Spring  RNG if exists (non-reproducible randomness), any other value -> use native RNG with that value as seed (reproducible)
		type    = 'number',
		section = 'Horse',
		def     = 0,
		min     = 0,
		max     = 999,
		step    = 1,
	},
	{
		key     = 'horsetastic',
		name    = 'Horse Mutation',
		desc    = 'My cat wears a hat',
		type    = 'bool',
		section = 'Horse',
		def     = true,
	},
	{
		key     = 'mushroomtastic',
		name    = 'Mushroom Mutation',
		desc    = 'My hat wears a cat',
		type    = 'bool',
		section = 'Horse',
		def     = true,
	},
	{
		key     = 'honk',
		name    = 'Honk',
		desc    = 'This option does nothing (honestly).',
		type    = 'bool',
		section = 'Honk',
		def     = true,
	},
	{
		key     = 'honk2',
		name    = 'Honk2',
		desc    = 'This option used to do something but I am not sure what it does now.',
		type    = 'bool',
		section = 'Honk',
		def     = false,
	},
	{
		key     = 'honk3',
		name    = 'Honk3',
		desc    = 'Probably better not to touch this one.',
		type    = 'bool',
		section = 'Honk',
		def     = false,
	},
}

return horse