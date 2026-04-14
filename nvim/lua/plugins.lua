return {
  -- =========================================================================
  -- ESTÉTICA Y CORE
  -- =========================================================================
  
  -- Tema Tokyo Night
  {
    "folke/tokyonight.nvim",
    lazy = false, -- Carga inmediata
    priority = 1000,
    opts = { style = "night", transparent = true },
    config = function()
        vim.cmd("colorscheme tokyonight")
        -- Asegurar que el fondo del buffer sea transparente también.
        vim.cmd("hi Normal guibg=NONE ctermbg=NONE")
        vim.cmd("hi NormalNC guibg=NONE ctermbg=NONE")
    end,
  },
  
  -- Líneas de Sangría (Indent-Blankline, ahora en Lua)
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {},
    config = function()
        require("ibl").setup {
            indent = { char = "▏" },
            scope = { enabled = true },
        }
    end,
  },

  -- Iconos (Para Nvim-Tree y Lualine)
  'nvim-tree/nvim-web-devicons', 

  -- Barra de Estado (Lualine)
  {
      'nvim-lualine/lualine.nvim',
      dependencies = { 'nvim-tree/nvim-web-devicons' }
  },

  -- =========================================================================
  -- HERRAMIENTAS DE EDICIÓN Y NAVEGACIÓN
  -- =========================================================================
  
  -- Resaltado avanzado (Treesitter)
  {
      'nvim-treesitter/nvim-treesitter',
      build = ':TSUpdate', 
      config = function()
          require'nvim-treesitter.configs'.setup {
              ensure_installed = { "python", "lua", "vim" }, 
              highlight = { enable = true },
              indent = { enable = true }, -- Habilita sangría inteligente
          }
      end,
  },

  -- Explorador de Archivo
  {
    "nvim-tree/nvim-tree.lua",
    cmd = { "NvimTreeToggle", "NvimTreeClose" },
    opts = {}, -- Usa las opciones por defecto
  },

  -- Buscador Fuzzy (Telescope)
  {
    'nvim-telescope/telescope.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' }
  },
  
  -- =========================================================================
  -- LSP Y AUTOMATIZACIÓN (El corazón del IDE)
  -- =========================================================================

  -- Gestor de Servidores LSP, Linters y Formatters (MASON)
  {
    'williamboman/mason.nvim',
    cmd = 'Mason',
  },
  {
    'williamboman/mason-lspconfig.nvim',
    dependencies = { 'williamboman/mason.nvim', 'neovim/nvim-lspconfig' },
  },

  -- Configuración de LSP (el cliente nativo)
  'neovim/nvim-lspconfig',

  -- Autocompletado (CMP) y Snippets (LUASNIP)
  'hrsh7th/nvim-cmp',
  'hrsh7th/cmp-nvim-lsp',
  'hrsh7th/cmp-buffer',
  'hrsh7th/cmp-path',
  'saadparwaiz1/cmp_luasnip',
  'L3MON4D3/LuaSnip',
  'rafamadriz/friendly-snippets',
  
  -- Integración de Git
  {
    'lewis6991/gitsigns.nvim',
    opts = {
        signcolumn = true,
        current_line_blame = true,
    }
  }
}
