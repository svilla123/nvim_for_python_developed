return {
  -- =========================================================================
  -- ESTÉTICA Y CORE
  -- =========================================================================
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = { style = "night", transparent = true },
    config = function()
        vim.cmd("colorscheme tokyonight")
        vim.cmd("hi Normal guibg=NONE ctermbg=NONE")
        vim.cmd("hi NormalNC guibg=NONE ctermbg=NONE")
    end,
  },

  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {
        indent = { char = "▏" },
        scope = { enabled = true },
    },
  },

  'nvim-tree/nvim-web-devicons', 

  {
      'nvim-lualine/lualine.nvim',
      dependencies = { 'nvim-tree/nvim-web-devicons' },
      config = function() require('lualine').setup() end,
  },

  -- =========================================================================
  -- HERRAMIENTAS DE EDICIÓN Y NAVEGACIÓN
  -- =========================================================================
  {
      'nvim-treesitter/nvim-treesitter',
      -- Rama de compatibilidad para la API nvim-treesitter.configs.
      branch = 'master',
      lazy = false,
      build = ':TSUpdate',
      config = function() require('config.treesitter') end,
  },

  {
    "nvim-tree/nvim-tree.lua",
    cmd = { "NvimTreeToggle", "NvimTreeClose" },
    keys = { { "<leader>e", "<cmd>NvimTreeToggle<cr>", desc = "Explorer" } },
    opts = {},
  },

  {
    'nvim-telescope/telescope.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    keys = { { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find Files" } },
  },

  -- =========================================================================
  -- LSP Y AUTOMATIZACIÓN (El corazón del IDE)
  -- =========================================================================
  {
    'williamboman/mason.nvim',
    opts = {},
  },

  {
    'williamboman/mason-lspconfig.nvim',
    dependencies = { 'williamboman/mason.nvim', 'neovim/nvim-lspconfig' },
    config = function()
        -- Configurar LSP antes de habilitar los servidores instalados.
        require('config.lsp')
        require('mason-lspconfig').setup({
            ensure_installed = { 'pyright', 'lua_ls' },
            automatic_enable = false,
        })
    end,
  },

  'neovim/nvim-lspconfig',

  -- Autocompletado (CMP) - CONFIGURACIÓN COMPLETA
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'saadparwaiz1/cmp_luasnip',
      'L3MON4D3/LuaSnip',
      'rafamadriz/friendly-snippets',
    },
    config = function() require('config.cmp') end,
  },

  {
    'lewis6991/gitsigns.nvim',
    opts = {
        signcolumn = true,
        current_line_blame = true,
    }
  },

  {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' },
    opts = {},
  }
}
