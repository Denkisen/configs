local excluded = {}

return {
	"folke/snacks.nvim",
	opts = {
		picker = {
			sources = {
				explorer = {
					-- ignored = true,
					-- hidden = true,
				},
				files = {
					-- ignored = false,
					-- hidden = false,
					exclude = excluded,
				},
				grep = {
					--   ignored = false,
					--   hidden = false,
					exclude = excluded,
				},
			},
		},
	},
}
