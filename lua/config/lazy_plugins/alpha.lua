if os.getenv('SYS_THEME') ~= "awsm" then
    return
end

local alpha = require("alpha")
local dashboard = require("alpha.themes.dashboard")

local lines = {}

local logo = [[
                __
  ___   __  __ /\_\    ___ ___
/' _ `\/\ \/\ \\/\ \ /' __` __`\
/\ \/\ \ \ \_/ |\ \ \/\ \/\ \/\ \
\ \_\ \_\ \___/  \ \_\ \_\ \_\ \_\
 \/_/\/_/\/__/    \/_/\/_/\/_/\/_/
]]

for line in logo:gmatch("[^\n]+") do
    table.insert(lines, line)
end

dashboard.section.header.val = lines
dashboard.section.buttons.val = {}

local quote_api = "https://zenquotes.io/api/random"
function display_erro()
    dashboard.section.footer.val = "The philosophers are not availble right now."
end

dashboard.section.footer.val = "Loading quote..."

local curl = require("plenary.curl")
curl.get( quote_api, {
    callback = function(response)
        if response.status == 200 then
            local data = vim.json.decode(response.body)
            dashboard.section.footer.val = {
                data[1].q,
                "— " .. data[1].a,
            }
        else
            display_erro()
        end

        vim.schedule(function()
            alpha.redraw()
        end)
    end,
    on_error = function (err)
        display_erro()
        vim.schedule(function()
            alpha.redraw()
        end)
    end
})

alpha.setup(dashboard.opts)

-- Draw startup-image
-- vim.api.nvim_create_autocmd("User", {
--     pattern = "AlphaReady",
--     callback = function()
--         local image = require("image")
--         image
--             .from_file(vim.fn.stdpath('config') .. "/cat.png", {
--                 window = vim.api.nvim_get_current_win(),
--                 buffer = vim.api.nvim_get_current_buf(),
--                 with_virtual_padding = true,
--                 x = 10, -- column offset
--                 y = 2, -- row offset
--                 width = 40,
--                 height = 20,
--             })
--             :render()
--     end,
-- })
