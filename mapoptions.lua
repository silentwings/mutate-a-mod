local horse = {
	{
		key     = 'randomseed',
		name    = 'Horse Random Seed Bunny Bunny Bunny',
		desc    = 'Ignored if 0 (-> use synced seed from Spring)',
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
}

return horse