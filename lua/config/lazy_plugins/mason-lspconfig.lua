local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())
capabilities.textDocument.completion.completionItem.snippetSupport = true


local lsp_server = {
    "lua_ls",
    "clangd",
    "html",
    "cssls",
    "ts_ls",
    "jsonls",
    "pyright"
}

local lspconfig = require("lspconfig")

local handlers = {
    function(name)
        lspconfig[name].setup({ capabilities = capabilities })
    end,
    ["html"] = function()
        lspconfig.html.setup({
            capabilities = capabilities,
            on_attach = function(client, bufnr)
                print("HTML LSP attached to buffer " .. bufnr)
            end,
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
}

require("mason-lspconfig").setup({
    ensure_installed = lsp_server,
    handlers = handlers,
})
