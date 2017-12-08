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
		desc    = 'Horse',
		type    = 'bool',
		section = 'Horse',
		def     = true,
	},
	{
		key     = 'honk',
		name    = 'Honk',
		desc    = 'This option does nothing, honest.',
		type    = 'bool',
		section = 'Horse',
		def     = true,
	},
}

return horse