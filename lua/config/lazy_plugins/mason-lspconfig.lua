local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())
capabilities.textDocument.completion.completionItem.snippetSupport = true

-- applies to every server
vim.lsp.config("*", { capabilities = capabilities })

vim.lsp.config("html", {
    settings = {
        html = {
            format = {
                enable = true,
                wrapLineLength = 80,
                wrapAttributes = "auto",
                indentInnerHtml = true,
                preserveNewLines = true,
            },
            hover = { documentation = true, references = true },
        },
    },
})

vim.lsp.config("bashls", {
    filetypes = { "sh", "bash", "zsh" },
    settings = {
        bashIde = {
            shellcheckPath = "shellcheck",
            shellcheckArguments = { "-x" },
            shfmtPath = "shfmt",
            shfmtExtraArgs = { "-i", "2", "-ci" },
        },
    },
})

vim.lsp.config("ts_ls", {
    init_options = {
        maxTsServerMemory = 4096,
        tsserver = {
            logDirectory = "/tmp/tsserver",
            logVerbosity = "verbose",
        },
    },
    settings = {
        typescript = {
            tsserver = {
                maxTsServerMemory = 4096,
            },
        },
    },
})

local lsps = {
    "lua_ls",
    "clangd",
    "html",
    "cssls",
    "ts_ls",
    "jsonls",
    "pyright",
    "bashls",
    "rust_analyzer",
    "texlab",
    "intelephense",
}

for _, v in ipairs(lsps) do
    vim.lsp.enable(v)
end

require("mason-lspconfig").setup({
    ensure_installed = lsps,
    -- automatic_enable = true is the default: installed servers get vim.lsp.enable()'d
})
