local null_ls = require("null-ls")
local mason_null_ls = require("mason-null-ls")
local fmt = null_ls.builtins.formatting

mason_null_ls.setup({
    ensure_installed = {
        "prettier",
        "black",
        "isort",
        "stylua",
        "yamlfmt",
        "shfmt",
    },
    automatic_installation = false,
})

null_ls.setup({
    sources = {
        fmt.stylua.with({ extra_args = { "--indent-type", "Spaces" } }),
        fmt.prettier.with({
            extra_args = { "--use-tabs", "false", "--tab-width", tostring(vim.o.tabstop) },
        }),
        fmt.yamlfmt,
        fmt.shfmt,
        fmt.black,
        fmt.isort.with({ extra_args = { "--profile", "black" } }),
    },
})
