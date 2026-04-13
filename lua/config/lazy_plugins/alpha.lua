local alpha = require("alpha")
local dashboard = require("alpha.themes.dashboard")

-- Leave header empty or minimal
dashboard.section.header.val = { "" }

alpha.setup(dashboard.config)

-- Render image after alpha opens
vim.api.nvim_create_autocmd("User", {
    pattern = "AlphaReady",
    callback = function()
        local image = require("image")
        image
            .from_file("/path/to/your/image.png", {
                window = vim.api.nvim_get_current_win(),
                buffer = vim.api.nvim_get_current_buf(),
                with_virtual_padding = true,
                x = 10, -- column offset
                y = 2, -- row offset
                width = 40,
                height = 20,
            })
            :render()
    end,
})
