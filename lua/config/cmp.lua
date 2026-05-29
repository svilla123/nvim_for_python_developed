-- =========================================================================
-- CONFIGURACIÓN DE NVIM-CMP (Autocompletado)
-- =========================================================================

local cmp = require('cmp')
local luasnip = require('luasnip')

cmp.setup({
    -- Configuración de Snippets
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body) -- Usa LuaSnip como motor de snippets
        end,
    },
    
    -- Mapeos de Teclado 
    mapping = cmp.mapping.preset.insert({
        ["<C-Space>"] = cmp.mapping.complete(), -- Mostrar sugerencias
        ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Confirmar sugerencia

        -- Navegación con Tab/Shift+Tab para la lista de sugerencias
        ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump() -- Navega dentro del snippet si es posible
            else
                fallback()
            end
        end, { 'i', 's' }),
        
        ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1) -- Vuelve al campo anterior del snippet
            else
                fallback()
            end
        end, { 'i', 's' }),
    }),
    
    -- Fuentes de Autocompletado
    sources = {
        { name = 'nvim_lsp' },  -- Sugerencias del Servidor de Lenguaje (Pyright)
        { name = 'luasnip' },   -- Sugerencias de Snippets
        { name = 'buffer' },    -- Palabras del buffer actual
        { name = 'path' },      -- Rutas de archivos
    },
    
    -- Estilo y Apariencia
    window = {
        -- Puedes usar un tema más atractivo si quieres, por defecto son minimalistas.
    },
})
