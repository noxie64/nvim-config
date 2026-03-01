-- disable mouse
vim.opt.mouse = ""

-- colorscheme
vim.o.background = "dark"
vim.o.termguicolors = true
colorscheme = ""

local ARCH_THEME = os.getenv("ARCH_THEME")

if ARCH_THEME == nil or ARCH_THEME == "onedark" then
    colorscheme = "onedark"
elseif ARCH_THEME == "gruvbox" then
    colorscheme = "gruvbox"
end

-- workaround
colorscheme = 'molokai'


local isOK, err = pcall(vim.cmd, "colorscheme " .. colorscheme)
if not isOK then
    vim.notify(err, vim.log.levels.ERROR, { timeout = 5000 })
end

-- tabs
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.softtabstop = 4
vim.opt.list = true

vim.api.nvim_create_autocmd("BufEnter", {
    pattern = "*",
    callback = function()
        if vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf()) == "" then
            vim.opt_local.list = false
        end
    end,
})

-- enable line numbers
vim.opt.number = true

-- clipboard
vim.opt.clipboard = "unnamedplus"

-- disable line wrap
vim.o.wrap = true
vim.o.linebreak = true
vim.o.breakindent = true
vim.o.showbreak = "↳ "

-- set spell lang hallo
vim.opt.spelllang = { "de", "en" }
