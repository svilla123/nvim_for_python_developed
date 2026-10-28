-- Neovim >= 0.11.3: configuración LSP nativa.
local capabilities = vim.lsp.protocol.make_client_capabilities()
local ok, cmp_lsp = pcall(require, 'cmp_nvim_lsp')
if ok then
    capabilities = cmp_lsp.default_capabilities(capabilities)
end

local on_attach = function(client, bufnr)
    if client:supports_method('textDocument/formatting') then
        local group = vim.api.nvim_create_augroup('LspFormat_' .. bufnr, { clear = true })
        vim.api.nvim_create_autocmd('BufWritePre', {
            group = group,
            buffer = bufnr,
            callback = function()
                vim.lsp.buf.format({ bufnr = bufnr, async = false })
            end,
        })
    end
end

vim.lsp.config('pyright', {
    capabilities = capabilities,
    on_attach = on_attach,
    settings = { python = { analysis = { typeCheckingMode = 'off' } } },
})
vim.lsp.config('lua_ls', {
    capabilities = capabilities,
    on_attach = on_attach,
    settings = {
        Lua = {
            diagnostics = { globals = { 'vim' } },
            workspace = { checkThirdParty = false },
        },
    },
})
vim.lsp.enable({ 'pyright', 'lua_ls' })
