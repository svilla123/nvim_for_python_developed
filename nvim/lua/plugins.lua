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
      build = ':TSUpdate', 
      config = function()
          require'nvim-treesitter.configs'.setup {
              -- Añadimos sql para el nuevo equipo
              ensure_installed = { "python", "lua", "vim", "sql", "dockerfile" }, 
              highlight = { enable = true },
              indent = { enable = true },
          }
      end,
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
    opts = {
        -- Esto asegura que los modelos de autocompletado estén en cualquier equipo
        ensure_installed = { "pyright", "lua_ls", "sqls" }, 
        automatic_installation = true,
    },
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
    config = function()
      local cmp = require('cmp')
      local luasnip = require('luasnip')
      require("luasnip.loaders.from_vscode").lazy_load() -- Carga friendly-snippets

      cmp.setup({
        snippet = {
          expand = function(args) luasnip.lsp_expand(args.body) end,
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-d>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
          ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then luasnip.expand_or_jump()
            else fallback() end
          end, { 'i', 's' }),
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp' }, -- Sugerencias del servidor (Python/SQL)
          { name = 'luasnip' },  -- Fragmentos de código
          { name = 'buffer' },   -- Palabras en el archivo actual
          { name = 'path' },     -- Rutas de archivos
        })
      })
    end
  },

  {
    'lewis6991/gitsigns.nvim',
    opts = {
        signcolumn = true,
        current_line_blame = true,
    }
  }
}
