local horse = {
	{
		key     = 'randomseed',
		name    = 'Bunny Bunny Bunny',
		desc    = 'Ignored if =0 (-> use synced horse from Spring)',
		type    = 'number',
		section = 'Horse',
		def     = 0,
		min     = -999,
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