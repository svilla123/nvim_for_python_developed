-- =========================================================================
-- OPCIONES GENERALES DE VIM
-- =========================================================================

-- Número de línea absoluto (1, 2, 3...)
vim.opt.nu = true

-- Desactiva el número de línea relativo (¡SOLUCIÓN AL DECREMENTO!)
vim.opt.rnu = false

-- Habilita el color verdadero (True Color)
vim.opt.termguicolors = true

-- Sangría (indentación)
vim.opt.tabstop = 4        -- Un tabulador es de 4 espacios
vim.opt.softtabstop = 4    -- Los espacios son 4 al presionar Tab
vim.opt.shiftwidth = 4     -- Cuántos espacios se usan para la sangría automática
vim.opt.expandtab = true   -- Usa espacios en lugar de tabuladores reales

-- Búsqueda
vim.opt.incsearch = true   -- Muestra las coincidencias mientras escribes
vim.opt.hlsearch = false   -- No resalta la última búsqueda

-- Guardar y Copiar
vim.opt.swapfile = false   -- No crea archivos de intercambio (swap files)
vim.opt.backup = false     -- No crea archivos de copia de seguridad (backup files)
vim.opt.undofile = true    -- Persiste la historia de deshacer (undo)
vim.opt.encoding = 'utf-8' -- Usa UTF-8

-- Comportamiento de la ventana
vim.opt.scrolloff = 8      -- Deja 8 líneas de contexto al mover el cursor
