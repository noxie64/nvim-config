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
    bold = true,
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

local function quote(quote_str)
    return {
        type = "text",
        val = quote_str,
        opts = {
            position = "center",
            hl = "Quote",
        },
    }
end

local function versions()
    local version_str = vim.fn.api_info().version.major
        .. "."
        .. vim.fn.api_info().version.minor
        .. "."
        .. vim.fn.api_info().version.patch
    local version_header = "v" .. version_str .. ", " .. _VERSION
    local header_padding = string.rep(" ", math.floor((vim.o.columns - #version_header) / 2 + 0.5))
    return {
        type = "text",
        val = header_padding .. version_header,
        opts = {
            position = "left",
            hl = { { "Versions", #header_padding, #header_padding + #version_header } },
        },
    }
end

local function stats_table()
    local table_width = math.floor(vim.o.columns / 2)
    local table_start = math.floor((vim.o.columns - table_width) / 2)

    local function seperator(chr)
        return {
            type = "text",
            val = string.rep(chr, table_width),
            opts = {
                hl = "Comment",
                position = "center",
            },
        }
    end
    return {
        type = "group",
        val = {
            seperator("_"),
        },
    }
end

-- Center quote
local fortune = require("fortune").get_fortune()
local quote_grp = {
    type = "group",
    val = {},
}

if #fortune[1] == 1 then
    table.remove(fortune, 1)
end

for _, line in ipairs(fortune) do
    if #line == 1 then
         break
    end

    table.insert(quote_grp.val, {
        type = "text",
        val = line,
        opts = {
            position = "center",
            hl = "Comment"
        },
    })
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
        stats_table(),
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
