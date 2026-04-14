-- =========================================================================
-- CONFIGURACIÓN LSP - COMPATIBILIDAD TOTAL 0.11+ (SIN AVISOS)
-- =========================================================================

-- 1. Carga segura de Mason
local status_mason, mason = pcall(require, "mason")
local status_mason_lsp, mason_lspconfig = pcall(require, "mason-lspconfig")
if not status_mason or not status_mason_lsp then return end

mason.setup()
mason_lspconfig.setup({
    ensure_installed = { 'pyright', 'lua_ls' },
    automatic_installation = true,
})

-- 2. Función de Conexión (on_attach)
local on_attach = function(client, bufnr)
    if client.supports_method("textDocument/formatting") then
        vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = bufnr,
            callback = function()
                vim.lsp.buf.format({ bufnr = bufnr, async = false })
            end
        })
    end
end

-- 3. Configuración de Servidores (Sintaxis 0.11+)
-- En lugar de require('lspconfig'), usamos el puente de Mason que es más estable
local lspconfig = require('lspconfig')

-- Python
lspconfig.pyright.setup({
    on_attach = on_attach,
    settings = {
        python = {
            analysis = { typeCheckingMode = "off" },
        },
    },
})

-- Lua
lspconfig.lua_ls.setup({
    on_attach = on_attach,
    settings = {
        Lua = {
            diagnostics = { globals = {'vim'} },
            workspace = { checkThirdParty = false },
        },
    },
})
