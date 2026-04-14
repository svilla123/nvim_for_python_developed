-- 1. Configuracion Global (Opciones de Vim)
vim.opt.number = true
vim.opt.relativenumber = false -- Números relativos
vim.opt.tabstop = 4           -- Un tab son 4 espacios
vim.opt.shiftwidth = 4        -- Sangría de 4 espacios
vim.opt.expandtab = true      -- Usa espacios en lugar de tabs
vim.opt.clipboard = "unnamedplus" -- Permite que el portapapeles de Nvim y el del sistema compartan datos.

-- 2. Definición del Directorio de Configuración
local config_path = vim.fn.stdpath('config') .. '/lua'

-- 3. Definición del Gestor de Plugins
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- última versión
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- 4. Carga de Plugins
-- La lista real de plugins ruta en 'lua/plugins.lua'
require("lazy").setup("plugins")

-- 5. Mapeos (Bindings, osea comandos con teclas)
vim.api.nvim_set_keymap('n', '<leader>r', ':w<CR>:!python3 %<CR>', { noremap = true, silent = true })

-- 6. Configuración Modular
require("config.lsp")         -- Carga la configuración de LSP (pyright)
require("config.cmp")         -- Carga la configuración de nvim-cmp
require("config.treesitter")  -- Carga la configuración de Treesitter
-- require("config.otros")     -- Aquí podrías poner otras configuraciones 
