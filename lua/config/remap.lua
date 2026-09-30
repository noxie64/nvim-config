vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

local map = vim.keymap.set

-- Window-switching
map('n', '<A-h>', '<C-w>h')
map('n', '<A-j>', '<C-w>j')
map('n', '<A-k>', '<C-w>k')
map('n', '<A-l>', '<C-w>l')

-- Closing
map('n', '<A-q>', ':q<CR>', { silent = true })

-- Searching
map('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Buffer
map('n', '<leader>bp', '<cmd>bprevious<CR>')
map('n', '<leader>bn', '<cmd>bnext<CR>')
