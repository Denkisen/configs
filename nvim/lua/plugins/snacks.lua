return {
	"snacks.nvim",
	opts = {
		bigfile = { enabled = true },
		quickfile = { enabled = true },
		terminal = {
			enabled = true,
		},
		explorer = {
			enabled = true,
			replace_netrw = true,
		},
		picker = {
			sources = {
				files = {
					hidden = true,
					ignored = true,
				},
			},
			hidden = true,
			ignored = true,
		},
	},
}
