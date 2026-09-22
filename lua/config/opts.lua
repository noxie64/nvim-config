NVIM_THEME = require('config.utils').NVIM_THEME

local opt = vim.o.t
local o = vim.o

-- disable mouse
opt.mouse = ""

-- colorscheme
vim.o.background = "dark"
vim.o.termguicolors = true
colorscheme = ""


if NVIM_THEME ~= nil then
    colorscheme = NVIM_THEME
elseif NVIM_THEME == nil then
    colorscheme = 'molokai'
end

local isOK, err = pcall(vim.cmd, "colorscheme " .. colorscheme)
if not isOK then
    vim.notify(err, vim.log.levels.ERROR, { timeout = 5000 })
end

-- tabs
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.softtabstop = 4
opt.list = true

vim.api.nvim_create_autocmd("BufEnter", {
    pattern = "*",
    callback = function()
        if vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf()) == "" then
            vim.opt_local.list = false
        end
    end,
})

-- enable line numbers
opt.number = true

-- clipboard
opt.clipboard = "unnamedplus"

-- disable line wrap
vim.o.wrap = true
vim.o.linebreak = true
vim.o.breakindent = true
vim.o.showbreak = "↳ "

-- set spell lang hallo
opt.spelllang = { "de", "en" }
