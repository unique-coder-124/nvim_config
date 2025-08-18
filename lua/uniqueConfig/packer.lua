vim.cmd([[packadd packer.nvim]])
return require('packer').startup(function(use)
  -- Packer itself: always latest
  use { 'wbthomason/packer.nvim', lock = false }

  -- Fuzzy finding (safe updates)
  use {
    'nvim-telescope/telescope.nvim',
    tag      = '0.1.5',
    requires = { 'nvim-lua/plenary.nvim' },
    lock     = false,
  }

  -- Theme: pin so your colors never shift under you
  use {
    'rose-pine/neovim',
    as       = 'rose-pine',
    tag      = 'v3.0.2',
    lock     = true,
    config   = function()
      vim.cmd('colorscheme rose-pine')
    end,
  }

  -- Minimap utility (pin to avoid API churn)
  use {
    'Isrothy/neominimap.nvim',
    tag    = 'v3.14.1',
    lock   = true,
    config = function()
      vim.g.neominimap = { auto_enable = false }
      vim.keymap.set('n', '<leader>mm', '<cmd>Neominimap Toggle<cr>')
    end,
  }

  --[[ commented plugins (also pinned) ]]
  -- use {
  --   'Aasim-A/scrollEOF.nvim',
  --   tag  = '1.2.7',
  --   lock = true,
  -- }
  --
  -- use {
  --   'lewis6991/gitsigns.nvim',
  --   tag  = 'v1.0.2',
  --   lock = true,
  -- }
  --
  -- use {
  --   'lewis6991/satellite.nvim',
  --   tag  = 'v1.0.0',
  --   lock = true,
  -- }

  -- Statusline: pin for visual consistency
  use { 'vim-airline/vim-airline',        lock = true }
  use { 'vim-airline/vim-airline-themes', lock = true }

  -- Indent guides: pin for consistency
  use { 'lukas-reineke/indent-blankline.nvim', lock = true }

  -- Treesitter core: always get the latest parsers & fixes
  use {
    'nvim-treesitter/nvim-treesitter',
    run  = ':TSUpdate',
    lock = false,
  }

  -- Playground (experimental): safe to auto‑update
  use {
    'nvim-treesitter/playground',
    lock = false,
  }

  -- Learning games & project nav: pin for stability
  use { 'ThePrimeagen/vim-be-good', lock = true }
  use { 'ThePrimeagen/harpoon',    lock = true }

  -- Undo tree: pin so UI never shifts
  use { 'mbbill/undotree', lock = true }

  -- Git porcelain: pin to avoid surprises
  use { 'tpope/vim-fugitive', lock = true }

  -- Treesitter‑context: auto‑update alongside treesitter
  use {
    'nvim-treesitter/nvim-treesitter-context',
    lock = false,
  }

  -- LSP + completion (pin everything in this stack)
  use {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v3.x',
    lock   = false,
    requires = {
      -- Core LSP configs (pin to avoid new definitions breaking you)
      { 'neovim/nvim-lspconfig' },

      -- Mason package manager (you already pinned these)
      { 'williamboman/mason.nvim' },
      { 'williamboman/mason-lspconfig.nvim' },

      -- Completion engine + sources (pin to avoid API churn)
      { 'hrsh7th/nvim-cmp' },
      { 'hrsh7th/cmp-buffer' },
      { 'hrsh7th/cmp-path' },
      { 'saadparwaiz1/cmp_luasnip' },
      { 'hrsh7th/cmp-nvim-lsp' },
      { 'hrsh7th/cmp-nvim-lua' },

      -- Snippets engine (major‑version pinned) & repo (safe)
      { 'L3MON4D3/LuaSnip' },
      { 'rafamadriz/friendly-snippets' },
    }
  }
end)
