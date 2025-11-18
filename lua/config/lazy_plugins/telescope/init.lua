local path = 'config.lazy_plugins.telescope.'

require("telescope").setup {
  defaults = { --[[ your defaults]] },
  extensions = {
    file_browser = require(path .. 'filebrowser')
  },
}
