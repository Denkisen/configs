-- local conf = require('telescope.config').values
-- local themes = require('telescope.themes')
--
-- -- helper function to use telescope on harpoon list.
-- -- change get_ivy to other themes if wanted
-- local function toggle_telescope(harpoon_files)
--   local file_paths = {}
--   for _, item in ipairs(harpoon_files.items) do
--     table.insert(file_paths, item.value)
--   end
--   local opts = themes.get_ivy({
--     promt_title = "Working List"
--   })
--
--   require("telescope.pickers").new(opts, {
--     finder = require("telescope.finders").new_table({
--       results = file_paths,
--     }),
--     previewer = conf.file_previewer(opts),
--     sorter = conf.generic_sorter(opts),
--   }):find()
-- end
--
-- return {
--   "ThePrimeagen/harpoon",
--   branch = "harpoon2",
--   dependencies = {
--     "nvim-lua/plenary.nvim"
--   },
--   config = function()
--     local harpoon = require('harpoon')
--     vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end)
--     vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)
--     vim.keymap.set("n", "<leader>fl", function() toggle_telescope(harpoon:list()) end,
--       { desc = "Open harpoon window" })
--     vim.keymap.set("n", "<C-p>", function() harpoon:list():prev() end)
--     vim.keymap.set("n", "<C-n>", function() harpoon:list():next() end)
--   end
-- }
return {
	"ThePrimeagen/harpoon",
	branch = "harpoon2",
	opts = {
		menu = {
			width = vim.api.nvim_win_get_width(0) - 4,
		},
		settings = {
			save_on_toggle = true,
		},
	},
	keys = function()
		local keys = {
			{
				"<leader>ah",
				function()
					require("harpoon"):list():add()
				end,
				desc = "Harpoon File",
			},
			{
				"<C-e>",
				function()
					local harpoon = require("harpoon")
					harpoon.ui:toggle_quick_menu(harpoon:list())
				end,
				desc = "Harpoon Quick Menu",
			},
			{
				"<C-p>",
				function()
					local harpoon = require("harpoon")
					harpoon:list():prev()
				end,
				desc = "Harpoon Quick Menu",
			},
			{
				"<C-n>",
				function()
					local harpoon = require("harpoon")
					harpoon:list():next()
				end,
				desc = "Harpoon Quick Menu",
			},
		}

		for i = 1, 5 do
			table.insert(keys, {
				"<leader>" .. i,
				function()
					require("harpoon"):list():select(i)
				end,
				desc = "Harpoon to File " .. i,
			})
		end
		return keys
	end,
}
