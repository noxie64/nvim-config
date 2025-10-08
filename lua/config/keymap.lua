local map = vim.keymap.set
local opts = { silent = true, noremap = true}

-- Nvim-Tree
vim.keymap.set('n', '<leader>pf', ':NvimTreeToggle<CR>', { silent = true })

-- Harpoon
local harpoon_mark = require('harpoon.mark')
local harpoon_ui = require('harpoon.ui')
    -- some stylistic goodies
function initTabbar()
    vim.cmd('redrawtabline')
    vim.cmd('highlight! HarpoonInactive guibg=NONE guifg=#94816e')
    vim.cmd('highlight! TabLineFill guibg=NONE guifg=white')
    vim.cmd('highlight! HarpoonActive guibg=NONE guifg=white')
    vim.cmd('highlight! HarpoonNumberActive guibg=NONE guifg=#e49b5d')
    vim.cmd('highlight! HarpoonNumberInactive guibg=NONE guifg=#94816e')
end
initTabbar()

    -- add a file to harpoon
map('n', '<leader>pa', function ()
    if vim.loop.fs_stat(vim.fn.expand('%:p')) ~= nil then
        harpoon_mark.add_file()
        initTabbar()
    else
        vim.notify('Save file before adding it to harpoon!')
    end
end)

    -- remove file from harpoon
map('n', '<leader>pr', function ()
    harpoon_mark.rm_file(harpoon_mark.get_current_index())
    initTabbar()
end)

    -- toggle harpoon-quick-menu
map('n', '<leader>pq', harpoon_ui.toggle_quick_menu)

    -- close all files
map('n', '<leader>pc', function ()
    vim.ui.input({ prompt ='Close harpooned tabs? ' }, function (input)
        if input == 'y' then
            harpoon_mark.clear_all()
            initTabbar()
        end
    end)
end)

map("n", "<leader><S-Tab>", harpoon_ui.nav_prev)
map("n", "<leader><Tab>", harpoon_ui.nav_next)



-- Telescope
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })

-- Null-ls
map({ 'n', 'i' }, '<C-f>', ':lua vim.lsp.buf.format()<CR>', { noremap = true, silent = true })

--  nvim-lspconfig
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
vim.keymap.set('n', 'gD', vim.lsp.buf.type_definition, opts)
vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
vim.keymap.set('n', 'f', vim.lsp.buf.format, opts)
