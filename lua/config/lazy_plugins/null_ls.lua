local null_ls = require('null-ls')
local mason_null_ls = require("mason-null-ls")

mason_null_ls.setup({
  ensure_installed = {
    "prettier",    -- JS/TS formatter
    "eslint_d",    -- JS/TS linter
    "black",       -- Python formatter
    "stylua",      -- Lua formatter
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
}


local mason_registry = require('mason-registry')
for k, v in pairs(formatters) do
    local tool = mason_registry.get_package(k)

    if not tool:is_installed() then
        vim.notify('Installing ' .. k .. '...')
        tool:install()
        vim.notify('Done')
    end
end

local sources = {}


for k, v in pairs(formatters) do
    table.insert(sources, null_ls.builtins.formatting[k].with(v)) 
end

null_ls.setup({
    sources = sources
})
