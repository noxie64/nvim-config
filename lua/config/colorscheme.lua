-- colorscheme
NVIM_THEME = require("config.utils").NVIM_THEME
local colorscheme = ""

if NVIM_THEME ~= nil then
    colorscheme = NVIM_THEME
else
    colorscheme = 'molokai'
end

return colorscheme
