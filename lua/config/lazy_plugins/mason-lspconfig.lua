local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())
capabilities.textDocument.completion.completionItem.snippetSupport = true

local lsp_server = {
    "lua_ls",
    "clangd",
    "html",
    "cssls",
    "ts_ls",
    "jsonls",
    "pyright",
    "bashls",
    "rust-analyzer"
}

local lspconfig = require("lspconfig")

local handlers = {
    function(name)
        lspconfig[name].setup({ capabilities = capabilities })
    end,
    ["html"] = function()
        lspconfig.html.setup({
            capabilities = capabilities,
            settings = {
                html = {
                    format = {
                        enable = true, -- Enables formatting support
                        wrapLineLength = 80, -- Wrap lines at 80 characters
                        wrapAttributes = "auto", -- Wrap attributes automatically
                        indentInnerHtml = true, -- Indent contents of <head> and <body>
                        preserveNewLines = true, -- Preserve existing line breaks
                    },
                    hover = {
                        documentation = true, -- Enable hover documentation
                        references = true, -- Enable hover references
                    },
                },
            },
        })
    end,
    ["bashls"] = function()
        lspconfig.bashls.setup({
            capabilities = capabilities,
            filetypes = { "sh", "bash", "zsh" },
            cmd = { "bash-language-server", "start" },
            settings = {
                bashIde = {
                    shellcheckPath = "shellcheck", -- diagnostic tool
                    shellcheckArguments = { "-x" }, -- follow sourced files
                    shfmtPath = "shfmt", -- formatter tool
                    shfmtExtraArgs = { "-i", "2", "-ci" }, -- 2-space indent, indent case branches
                },
            },
        })
    end,
}

require("mason-lspconfig").setup({
    ensure_installed = lsp_server,
    handlers = handlers,
})
