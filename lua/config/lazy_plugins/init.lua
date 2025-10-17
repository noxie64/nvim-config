-- function load(name)
  --  local base_path = 'config.lazy_plugins.'
  --  require('_' .. name)
-- end

local base_path = 'config.lazy_plugins.'

require(base_path .. 'lualine')
require(base_path .. 'nvim-tree')
require(base_path .. 'nvim-treesitter')
require(base_path .. 'harpoon')
require(base_path .. 'mason')
require(base_path .. 'mason-lspconfig')
require(base_path .. 'nvim-cmp')
require(base_path .. 'nvim-ts-autopair')
require(base_path .. 'lua_snip')
require(base_path .. 'null_ls')
require(base_path .. 'snippets')
