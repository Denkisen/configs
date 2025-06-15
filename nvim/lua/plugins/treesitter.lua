return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "master",
		lazy = false,
		build = ":TSUpdate",
		config = function()
			local configs = require("nvim-treesitter.configs")
			configs.setup({
				highlight = { enable = true },
				indent = { enable = true },
				autotage = { enable = true },
				ensure_installed = {
					"c",
					"lua",
					"vim",
					"vimdoc",
					"cpp",
					"rust",
					"ron",
					"python",
					"dart",
					"dockerfile",
					"glsl",
					"json",
					"make",
					"cmake",
				},
				auto_install = false,
				additional_vim_regex_highlighting = false,
			})
		end,
	},
}
