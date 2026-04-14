-- ========================================================================== --
--  NEOVIM CONFIGURATION
--  Optimized for SSH, VMs, and DevOps operations
-- ========================================================================== --

-- 1. Global Options (Vim Options)
vim.g.mapleader = " "              -- Define la barra espaciadora como Leader
vim.opt.number = true              -- Muestra números de línea
vim.opt.relativenumber = false     -- Números absolutos (mejor para SSH)
vim.opt.tabstop = 4                -- Un tab son 4 espacios
vim.opt.shiftwidth = 4             -- Sangría de 4 espacios
vim.opt.expandtab = true           -- Usa espacios en lugar de tabs
vim.opt.clipboard = "unnamedplus"  -- Sincroniza con el portapapeles del sistema
vim.opt.termguicolors = true       -- Colores reales en la terminal

-- 2. Plugin Manager Bootstrap (Lazy.nvim)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- 3. Load Plugins
require("lazy").setup("plugins", {
    defaults = { lazy = true }, -- Carga perezosa para mayor velocidad en VMs
})

-- 4. Keybindings (Mapeos)
vim.api.nvim_set_keymap('n', '<leader>r', ':w<CR>:!python3 %<CR>', { noremap = true, silent = true })

-- 5. Modular Configuration with Safe Loading (pcall)
local function safe_require(module)
    local ok, m = pcall(require, module)
    if not ok then
        -- Opcional: print("Error loading: " .. module) 
        return nil 
    end
    return m
end

-- Carga modular segura
safe_require("config.lsp")         -- Configuración de LSP
safe_require("config.cmp")         -- Configuración de Autocompletado
safe_require("config.treesitter")  -- Configuración de Syntax Highlighting

-- 6. Fix for Neovim 0.11+ (LSP Deprecation)
-- Si algún módulo usa require('lspconfig'), esto asegura compatibilida
if vim.lsp.config then
   
    package.loaded['lspconfig'] = vim.lsp.config
end
