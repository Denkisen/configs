function enable_transparency()
  vim.api.nvim_set_hl(0, "Normal", { bg = "none"})
  vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none"})
end

return {
  {
    'nvim-lualine/lualine.nvim',
    dependencies = {
      'nvim-tree/nvim-web-devicons'
    },
    config = function()
      require("lualine").setup({
      options = {
        icons_enabled = false,
        theme = "auto",
      }
    })
    end,
  },
  {
    'sainnhe/everforest',
    lazy = false,
    priority = 1000,
    config = function()
      -- Optionally configure and load the colorscheme
      -- directly inside the plugin declaration.
      vim.g.everforest_enable_italic = false
      vim.g.everforest_transparent_background = 1 
      vim.g.everforest_background = 'hard'
      vim.cmd.colorscheme('everforest')
      enable_transparency()
    end
  }
}
