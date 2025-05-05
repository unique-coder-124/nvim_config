vim.cmd([[packadd packer.nvim]])

return require('packer').startup(function(use)
  use('wbthomason/packer.nvim')

  use({
    'nvim-telescope/telescope.nvim', tag = '0.1.5',
    requires = { 'nvim-lua/plenary.nvim' }
  })

  use({
    'rose-pine/neovim',
    as = 'rose-pine',
    config = function()
      vim.cmd('colorscheme rose-pine')
    end
  })

  use({
    "Isrothy/neominimap.nvim",
    config = function()
      vim.g.neominimap = {
        auto_enable = false,
      }

      vim.keymap.set("n", "<leader>mm", "<cmd>Neominimap toggle<cr>")
    end,
  })

  use('Aasim-A/scrollEOF.nvim')

  use('lewis6991/gitsigns.nvim')

  use('lewis6991/satellite.nvim')

  use('vim-airline/vim-airline')
  use('vim-airline/vim-airline-themes')

  use('lukas-reineke/indent-blankline.nvim')

  use('nvim-treesitter/nvim-treesitter', {run = ':TSUpdate'})
  use('nvim-treesitter/playground')
  use('ThePrimeagen/vim-be-good')
  use('ThePrimeagen/harpoon')
  use('mbbill/undotree')
  use('tpope/vim-fugitive')

  use('nvim-treesitter/nvim-treesitter-context')

  use({
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v1.x',
    requires = {
      -- LSP Support
      {'neovim/nvim-lspconfig'},
      {'williamboman/mason.nvim'},
      {'williamboman/mason-lspconfig.nvim'},

      -- Autocompletion
      {'hrsh7th/nvim-cmp'},
      {'hrsh7th/cmp-buffer'},
      {'hrsh7th/cmp-path'},
      {'saadparwaiz1/cmp_luasnip'},
      {'hrsh7th/cmp-nvim-lsp'},
      {'hrsh7th/cmp-nvim-lua'},

      -- Snippets
      {'L3MON4D3/LuaSnip'},
      {'rafamadriz/friendly-snippets'},
    }
  })
end)
