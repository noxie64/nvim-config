if os.getenv("SYS_THEME") ~= "awsm" then
    return
end

local alpha = require("alpha")
local function padding(n)
    return { type = "padding", val = n }
end

-- Highlight-groups --
vim.api.nvim_set_hl(0, "Quote", { italic = true, link = "Comment" })
vim.api.nvim_set_hl(0, "Versions", { 
    bg = vim.api.nvim_get_hl(0, { name = "Keyword", link = false }).fg,
    fg = "#000000",
    bold = true
})

local logo = {
    type = "text",
    val = {
        [[                __]],
        [[  ___   __  __ /\_\    ___ ___]],
        [[/' _ `\/\ \/\ \\/\ \ /' __` __`\]],
        [[/\ \/\ \ \ \_/ |\ \ \/\ \/\ \/\ \]],
        [[\ \_\ \_\ \___/  \ \_\ \_\ \_\ \_\]],
        [[ \/_/\/_/\/__/    \/_/\/_/\/_/\/_/]],
    },
    opts = {
        hl = "Keyword",
        position = "center",
    },
}

local quote_api = "https://zenquotes.io/api/random"

local quote_grp = {
    type = "group",
    spacing = 0,
    val = {},
    opts = {},
}

local function quote_simple(quote_str)
    quote_grp.val = {
        {
            type = "text",
            val = quote_str,
            opts = {
                position = "center",
                hl = "Quote",
            },
        },
    }
end

quote_simple("Loading quote...")

local curl = require("plenary.curl")
curl.get(quote_api, {
    callback = function(response)
        if response.status == 200 then
            local data = vim.json.decode(response.body)
            vim.schedule(function()
                quote_grp.val = {}
                local author_padding = ""
                local author = "- " .. data[1].a
                local quote_resp = ""

                local max_width = math.floor(vim.o.columns * 0.7 + 0.5)
                local len = 0
                data[1].q = data[1].q .. "."

                for i = 1, #data[1].q - 1 do
                    if i == max_width then
                        if quote_resp:sub(#quote_resp, #quote_resp) ~= " " then
                            for j = i, 0, -1 do
                                if quote_resp:sub(j, j) == " " then
                                    quote_resp = quote_resp:sub(1, j - 1) .. "\n" .. quote_resp:sub(j + 1, #quote_resp)
                                    if j > len then
                                        len = j - 1
                                    end
                                    break
                                end
                            end
                        else
                            quote_resp = quote_resp .. "\n"
                        end
                    end

                    quote_resp = quote_resp .. data[1].q:sub(i, i)
                end
                if len == 0 then
                    len = #quote_resp
                end

                author_padding = string.rep(" ", len - #author)

                local lines = vim.split(quote_resp, "\n")
                for _, line in ipairs(lines) do
                    table.insert(quote_grp.val, {
                        type = "text",
                        val = line .. string.rep(" ", len - #line),
                        opts = { hl = "Quote", position = "center" },
                    })
                end

                table.insert(quote_grp.val, {
                    type = "text",
                    val = author_padding .. author,
                    opts = {
                        hl = "Quote",
                        position = "center",
                    },
                })
            end)
        else
            quote_simple("The philosophers are not availble right now.")
        end

        vim.schedule(function()
            alpha.redraw()
        end)
    end,
    on_error = function(err)
        quote_simple(require("alpha.fortune")())
        vim.schedule(function()
            print(err)
            alpha.redraw()
        end)
    end,
})

function versions()
    local version_str = vim.fn.api_info().version.major
        .. "."
        .. vim.fn.api_info().version.minor
        .. "."
        .. vim.fn.api_info().version.patch
    local version_header = "v" .. version_str .. ", " .. _VERSION
    local header_padding = string.rep(" ", math.floor((vim.o.columns - #version_header) / 2 + .5))
    return {
        type = "text",
        val = header_padding .. version_header,
        opts = {
            position = "left",
            hl = {{"Versions", #header_padding, #header_padding + #version_header}}
        }
    }
end

local config = {
    keymap = {
        {
            "n",
            "i",
            function()
                local buf = vim.api.nvim_get_current_buf()
                vim.cmd("enew")
                vim.cmd("startinsert")
                pcall(vim.api.nvim_buf_delete, buf, { force = true })
            end,
            { noremap = true, silent = true },
        },
    },
    layout = {
        padding(4),
        logo,
        padding(1),
        versions(),
        padding(2),
        quote_grp,
    },
}

alpha.setup(config)

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
