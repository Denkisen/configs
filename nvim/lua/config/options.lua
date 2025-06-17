vim.opt.number = true
vim.opt.cursorline = true
vim.opt.relativenumber = true

vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.softtabstop = 1
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.g.python_recommended_style = 0
vim.opt.list = true
vim.opt.listchars = "tab:» ,lead:⋅,trail:⋅"
vim.opt.updatetime = 250
vim.opt.completeopt = "menuone,noselect"
vim.opt.clipboard = "unnamedplus"
vim.opt.hlsearch = true
vim.opt.autochdir = true
vim.opt.shell = "zsh"
vim.g.lazyvim_rust_diagnostics = "rust-analyzer"

vim.api.nvim_create_autocmd("VimEnter", {
	callback = function()
		vim.api.nvim_set_current_dir(vim.fn.expand("%:p:h"))
	end,
})
