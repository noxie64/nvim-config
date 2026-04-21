if os.getenv("SYS_THEME") ~= "awsm" then
    return
end

local alpha = require("alpha")
local function padding(n)
    return { type = "padding", val = n }
end

-- Highlight-groups --
vim.api.nvim_set_hl(0, "TableHeading", {
    fg = vim.api.nvim_get_hl(0, { name = "Keyword", link = false }).fg,
    bold = true,
})
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
    local table_width = math.min(math.floor(vim.o.columns / 2), 60)
    local len = vim.fn.strcharlen

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

    local function seperator_heading(chr, heading)
        local function heading_padding(real)
            if real then
                return math.floor((table_width - len(heading)) / 2)
            end

            return math.floor((table_width - #heading) / 2)
        end

        local heading_padding_after = table_width - heading_padding(true) - len(heading)
        return {
            type = "text",
            val = string.rep(chr, heading_padding(true)) .. heading .. string.rep(chr, heading_padding_after),
            opts = {
                hl = {
                    { "Comment", 0, heading_padding(true) },
                    { "TableHeading", heading_padding(true), heading_padding(true) + #heading },
                    {
                        "Comment",
                        heading_padding(false) + #heading + 1,
                        heading_padding(false) + #heading + heading_padding_after,
                    },
                },
                position = "center",
            },
        }
    end

    local function space_between(start_el, end_el)
        local line = start_el.val

        local padding_between = table_width - len(start_el.val) - len(end_el.val)
        line = line .. string.rep(" ", padding_between)
        line = line .. end_el.val

        return {
            type = "text",
            val = line,
            opts = {
                hl = {
                    { start_el.hl, 0, len(start_el.val) },
                    {
                        end_el.hl,
                        len(start_el.val) + padding_between,
                        len(start_el.val) + padding_between + len(end_el.val),
                    },
                },
                position = "center",
            },
        }
    end

    local function os_info()
        local os_str = vim.fn.system("uname -r"):gsub("%s$", "")
        local os_hl = ""
        if vim.v.shell_error ~= 0 then
            os_str = "n/a"
            os_hl = "Comment"
        end

        if os_str:find("arch") then
            os_str = "󰣇 " .. os_str
        end

        return {
            space_between({
                val = "Type",
                hl = "Keyword",
            }, {
                val = os_str,
                hl = os_hl,
            }),
        }
    end

    local function loaded_plugins()
        return space_between({
            val = "Loaded plugins",
            hl = "Keyword",
        }, {
            val = #require("lazy").plugins(),
            hl = "",
        })
    end

    return {
        type = "group",
        val = {
            seperator_heading("-", "OS"),
            unpack(os_info()),
            seperator_heading("-", "󰒲 Lazy"),
            loaded_plugins(),
            seperator("‾"),
        },
    }
end

local function quote()
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
                hl = "Comment",
            },
        })
    end

    quote_grp.val[1].val = "“" .. quote_grp.val[1].val:gsub("^%s", "")
    local last_entry = #quote_grp.val
    quote_grp.val[last_entry].val = quote_grp.val[last_entry].val:gsub("%s$", "") .. "”"

    return quote_grp
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
        quote(),
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
