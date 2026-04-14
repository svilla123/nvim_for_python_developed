-- =========================================================================
-- CONFIGURACIÓN DEL SERVIDOR DE LENGUAJE (LSP) - VERSIÓN COMPATIBLE

local lspconfig = require('lspconfig')
local mason_lspconfig = require('mason-lspconfig')

-- 1. Configuracion de MASON (Para instalar herramientas)
require('mason').setup()

-- 2. Definición de la Función de Conexión (on_attach)
-- Define acciones a tomar cuando el servidor LSP se adjunta a un buffer.
local on_attach = function(client, bufnr)
    -- Activar el formato al guardar (si el cliente lo soporta)
    if client.supports_method("textDocument/formatting") then
        vim.api.nvim_create_autocmd("BufWritePost", {
            buffer = bufnr,
            callback = function()
                vim.lsp.buf.format()
            end
        })
    end
end

-- 3. Configuración de Mason: Lista de servidores a instalar
-- (Esto instala pyright y lua_ls automáticamente)
mason_lspconfig.setup({
    ensure_installed = {
        'pyright',     -- Servidor LSP para Python
        'lua_ls',      -- LSP para configurar Nvim en Lua
    },
    automatic_installation = true,
})

-- 4. Configuración del Servidor Específico (Pyright y otros)
-- Usamos el método tradicional para adjuntar la configuración (on_attach)
mason_lspconfig.setup({
  function(server_name)
    lspconfig[server_name].setup({
      on_attach = on_attach,
    })
  end,
})

-- Nota: Si el error persiste, usa el siguiente bloque en lugar de 'mason_lspconfig.setup_handlers'


lspconfig.pyright.setup({
    on_attach = on_attach,
    settings = {
        python = {
            analysis = {
                typeCheckingMode = "off", -- Puedes cambiar a "basic" o "strict"
            },
        },
    },
})

lspconfig.lua_ls.setup({
    on_attach = on_attach,
    settings = {
        Lua = {
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
        },
    },
})



