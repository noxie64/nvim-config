vim.notify("Hello from nvim-lint!")

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
vim.api.nvim_create_autocmd({ "BufWritePost" }, {
    callback = function()
        if excluded_filetypes[vim.bo.filetype] then
            return
        end
        require("lint").try_lint()
        require("lint").try_lint("cspell")
    end,
})
