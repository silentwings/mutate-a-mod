local horse = {
	{
		key     = 'randomseed',
		name    = 'Random Seed Bunny',
		desc    = 'Ignored if =0 (-> use synced horse from Spring 104+)',
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
		key     = 'honk',
		name    = 'Honk',
		desc    = 'This option does nothing (honestly).',
		type    = 'bool',
		section = 'Horse',
		def     = true,
	},
	{
		key     = 'honk2',
		name    = 'Honk2',
		desc    = 'This option used to do something but I am not sure what it does now.',
		type    = 'bool',
		section = 'Horse',
		def     = true,
	},
	{
		key     = 'honk3',
		name    = 'Honk3',
		desc    = 'Probably better not to touch this one.',
		type    = 'bool',
		section = 'Horse',
		def     = true,
	},
}

return horse