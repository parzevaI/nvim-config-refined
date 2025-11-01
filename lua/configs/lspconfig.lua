require("nvchad.configs.lspconfig").defaults()

local lspconfig = require("lspconfig")

local servers = {
    "html",
    "cssls",
    "pyright",
    "rust_analyzer",
    "ts_ls",
    "eslint",
    -- "styled_components_language_server",
    "svelte",
}

for _, lsp in ipairs(servers) do
    lspconfig[lsp].setup({})
end

-- read :h vim.lsp.config for changing options of lsp servers
