
-- exclude menus and so on
local excluded_filetypes = {
    help = true,
    qf = true,
    TelescopePrompt = true,
    ["neo-tree"] = true,
    NvimTree = true,
    alpha = true,
    lazy = true,
}


require('lint').linters_by_ft = {
    typescript = { 'oxlint' },
    javascript = { 'oxlint' },
    sql = { 'sqlfluff' }
}

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
    callback = function()
        if excluded_filetypes[vim.bo.filetype] then
            return
        end
        require("lint").try_lint()
    end,
})
