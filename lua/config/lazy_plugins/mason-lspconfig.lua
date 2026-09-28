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
    },
    settings = {
        typescript = {
            tsserver = {
                maxTsServerMemory = 4096,
            },
        },
    },
})

vim.lsp.config("harper_ls", {
    cmd = { "harper-ls", "--stdio" },
    settings = {
        ["harper-ls"] = {
            userDictPath = "",
            workspaceDictPath = "",
            fileDictPath = "",
            linters = {
                SpellCheck = true,
                SpelledNumbers = false,
                AnA = true,
                SentenceCapitalization = true,
                UnclosedQuotes = true,
                WrongApostrophe = false,
                LongSentences = true,
                RepeatedWords = true,
                Spaces = true,
                CorrectNumberSuffix = true,
            },
            codeActions = {
                ForceStable = false,
            },
            markdown = {
                IgnoreLinkTitle = false,
            },
            diagnosticSeverity = "hint",
            isolateEnglish = false,
            dialect = "American",
            maxFileLength = 120000,
            ignoredLintsPath = "",
            excludePatterns = {},
        },
    },
})

local lsps_for_activation = {
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
    -- "harper_ls", -- mnually activated
}

for _, v in ipairs(lsps_for_activation) do
    vim.lsp.enable(v)
end

-- manually start harper_ls and set root-dir
vim.api.nvim_create_autocmd("FileType", {
    pattern = "*",
    callback = function(args)
        local excluded_filetypes = {
            ["neo-tree"] = true,
            NvimTree = true,
            TelescopePrompt = true,
            help = true,
            lazy = true,
            mason = true,
            qf = true,
            checkhealth = true,
            alpha = true,
        }

        if excluded_filetypes[vim.bo[args.buf].filetype] then
            return
        end
        if vim.bo[args.buf].buftype ~= "" then
            return
        end

        local client_id = vim.lsp.start(
            vim.tbl_extend("force", vim.lsp.config.harper_ls, {
                root_dir = vim.fs.root(args.buf, { ".git" }) or vim.fn.getcwd(), -- manually set root-dir
            }),
            { bufnr = args.buf }
        )
    end,
})

require("mason-lspconfig").setup({
    ensure_installed = lsps_for_activation,
    -- automatic_enable = true is the default: installed servers get vim.lsp.enable()'d
})
