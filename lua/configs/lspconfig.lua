require("nvchad.configs.lspconfig").defaults()

local servers = { "html", "cssls", "pyright", "rust_analyzer", "ts_ls", "eslint", "styled_components_ls" }
vim.lsp.enable(servers)

-- read :h vim.lsp.config for changing options of lsp servers
