return {
	{
		"craftzdog/solarized-osaka.nvim",
		lazy = true,
		priority = 1000,
		opts = function()
			return {
				transparent = true,
			}
		end,
	},
	{
		"sontungexpt/witch",
		priority = 1000,
		lazy = false,
		config = function(_, opts)
			require("witch").setup(opts)
		end,
	},
}
