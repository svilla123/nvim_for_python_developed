-- =========================================================================
-- CONFIGURACIÓN DE NVIM-TREESITTER
-- =========================================================================

-- Carga el módulo de configuración de Treesitter
require('nvim-treesitter.configs').setup {
    -- Asegura que los parsers (analizadores sintácticos) para estos lenguajes estén instalados.
    -- El comando ':TSUpdate' los instalará.
    ensure_installed = { 
        "python", -- Esencial para Pythonistas
        "lua",    -- Esencial para configurar Nvim
        "vim",    -- Útil para archivos .vim
        "markdown",
    },

    -- Opciones principales:
    highlight = {
        enable = true,  -- Habilitar el resaltado avanzado
    },
    indent = {
        enable = true,  -- Habilitar la sangría basada en la estructura del código
    },
    
    -- Opcional: Recomendado si quieres más funcionalidades, como el renombrado.
    -- incremental_selection = {
    --     enable = true,
    --     keymaps = {
    --         init_selection = "gnn",
    --         node_incremental = "<C-Space>",
    --         scope_incremental = "<M-Space>",
    --         node_decremental = "<bs>",
    --     },
    -- },
}
