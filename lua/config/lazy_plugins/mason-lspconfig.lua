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

vim.api.nvim_create_autocmd("FileType", {
    pattern = "*",
    callback = function(args)
        if excluded_filetypes[vim.bo[args.buf].filetype] then
            return
        end
        if vim.bo[args.buf].buftype ~= "" then
            return -- skip non-file buffers (terminals, prompts, etc.)
        end
        vim.lsp.start(vim.lsp.config.harper_ls, { bufnr = args.buf })
    end,
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
    "harper_ls",
}

for _, v in ipairs(lsps) do
    vim.lsp.enable(v)
end

require("mason-lspconfig").setup({
    ensure_installed = lsps,
    -- automatic_enable = true is the default: installed servers get vim.lsp.enable()'d
})
