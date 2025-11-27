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
map('n', '<leader>S', ':%s/')
map('n', '<leader>s', ':/')
map('n', '<Esc>', ':noh<CR>', { silent = true })

-- Undo / redo
map('n', 'u', ':undo<CR>')
map('n', 'r', ':redo<CR>')

-- Deleting
map('n', 'd', '"_dd')
map('n', 'x', '"_x')
map('v', 'x', '"_x')
map('v', 'd', '"_dd')

map('n', 'D', '"+dd')
map('n', 'X', '"+x')
map('v', 'X', '"+x')
map('v', 'D', '"+dd')

-- Go to prev buffer
map('n', '<A-b>', ':bp<CR>', { silent = true })
