-- 1. Configuracion Global (Opciones de Vim)
vim.opt.number = true
vim.opt.relativenumber = false -- Números relativos
vim.opt.tabstop = 4           -- Un tab son 4 espacios
vim.opt.shiftwidth = 4        -- Sangría de 4 espacios
vim.opt.expandtab = true      -- Usa espacios en lugar de tabs
vim.opt.clipboard = "unnamedplus" -- Permite que el portapapeles de Nvim y el del sistema compartan datos.

-- 3. Definición del Gestor de Plugins
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  local output = vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- última versión
    lazypath,
  })
  if vim.v.shell_error ~= 0 then
    error("No se pudo descargar lazy.nvim: " .. output)
  end
end
vim.opt.rtp:prepend(lazypath)

-- 4. Carga de Plugins
-- La lista real de plugins ruta en 'lua/plugins.lua'
require("lazy").setup("plugins", {
    rocks = { enabled = false },
})

-- 5. Mapeos (Bindings, osea comandos con teclas)
vim.api.nvim_set_keymap('n', '<leader>r', ':w<CR>:!python3 %<CR>', { noremap = true, silent = true })

-- Cada plugin carga su configuración desde lua/plugins.lua.
