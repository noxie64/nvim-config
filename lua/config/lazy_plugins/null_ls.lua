local null_ls = require("null-ls")
local mason_null_ls = require("mason-null-ls")

mason_null_ls.setup({
    ensure_installed = {
        "prettier", -- JS/TS formatter
        "eslint_d", -- JS/TS linter
        "black",    -- Python formatter
        "stylua",   -- Lua formatter
        "yamlfmt",  -- Yaml formatter
    },
    automatic_installation = true,
    automatic_setup = true,
})

local formatters = {
    stylua = {
        extra_args = { "--indent-type", "Spaces" },
    },
    prettier = {
        extra_args = { "--use-tabs", "false", "--tab-width", vim.opt.tabstop },
    },
    yamlfmt = {
        filetypes = { "yaml", "yml" },
    }
}

local sources = {}

for k, v in pairs(formatters) do
    table.insert(sources, null_ls.builtins.formatting[k].with(v))
end

null_ls.setup({
    sources = sources,
})
