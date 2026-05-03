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

vim.api.nvim_set_hl(0, "Good", {
    fg = vim.api.nvim_get_hl(0, { name = "OkMsg", link = false }).fg,
})
vim.api.nvim_set_hl(0, "Warn", {
    fg = vim.api.nvim_get_hl(0, { name = "WarningMsg", link = false }).fg,
})
vim.api.nvim_set_hl(0, "Bad", {
    fg = vim.api.nvim_get_hl(0, { name = "ErrorMsg", link = false }).fg,
})
vim.api.nvim_set_hl(0, "SecondHighlight", {
    fg = vim.api.nvim_get_hl(0, { name = "MoreMsg", link = false }).fg,
    bold = true,
})

vim.api.nvim_set_hl(0, "Default", {
    fg = vim.api.nvim_get_hl(0, { name = "StdoutMsg", link = false }).fg,
    italic = true,
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
                        heading_padding(false) + #heading,
                        heading_padding(false) + #heading + heading_padding(false) + #heading + heading_padding_after,
                    },
                },
                position = "center",
            },
        }
    end

    local function space_between(start_el, end_el)
        start_el.val = tostring(start_el.val)
        end_el.val = tostring(end_el.val)

        local line = start_el.val

        local padding_between = table_width - len(start_el.val) - len(end_el.val)
        line = line .. string.rep(" ", padding_between)
        line = line .. end_el.val

        return {
            type = "text",
            val = line,
            opts = {
                hl = {
                    { start_el.hl, 0, #start_el.val },
                    {
                        end_el.hl,
                        #start_el.val + padding_between,
                        #start_el.val + padding_between + #end_el.val,
                    },
                },
                position = "center",
            },
        }
    end

    local function command_out_safe(...)
        local cmd, hl = ...
        local ok, result = pcall(function()
            return vim.system(cmd, { text = true }):wait()
        end)
        local output = ""
        if not ok then
            output = "n/a"
            hl = "Comment"
        else
            output = result.stdout
            if hl == nil then
                hl = ""
            end
        end

        return output, hl, ok
    end

    local function key(val)
        return {
            val = val,
            hl = "Keyword",
        }
    end

    local function format_time(seconds)
        local h = math.floor(seconds / 3600)
        local m = math.floor((seconds % 3600) / 60)
        local s = seconds % 60
        return string.format("%02d:%02d:%02d", h, m, s)
    end

    local function os_info()
        local os_str, os_hl = command_out_safe({ "uname", "-r" }, "SecondHighlight")
        os_str = os_str:gsub("%s+$", "")
        if os_str:find("arch") then
            os_str = "󰣇 " .. os_str
        end

        local uptime, uptime_hl = command_out_safe({ "sh", "-c", "uptime -r | cut -d' ' -f2" }, "Default")
        local uptime_n = tonumber(uptime)
        if uptime_n ~= nil then
            uptime = format_time(uptime_n)
        end

        local function hl_by_num(num)
            if num < 50 then
                return "Good"
            elseif num > 50 and num < 75 then
                return "Warn"
            end
            return "Bad"
        end

        local cpu_usage_str, cpu_usage_hl, cpu_usage_ok = command_out_safe({
            "sh",
            "-c",
            "grep 'cpu ' /proc/stat | awk '{usage=($2+$4)*100/($2+$3+$4+$5)} END {print usage}'",
        })
        local cpu_usage = tonumber(cpu_usage_str)
        if cpu_usage_ok then
            cpu_usage_hl = hl_by_num(cpu_usage)
            cpu_usage_str = string.format("%.2f", cpu_usage)
        end

        local cpu_temp_str, cpu_temp_hl =
            command_out_safe({ "cat", "/sys/class/thermal/thermal_zone0/temp" }, "Default")
        local cpu_temp = tonumber(cpu_temp_str) / 1000
        if cpu_temp < 50 then
            cpu_temp_hl = "Good"
        elseif cpu_temp > 50 and cpu_temp < 75 then
            cpu_temp_hl = "Warn"
        else
            cpu_temp_hl = "Bad"
        end

        local mem_used_str, mem_used_hl, used_ok =
            command_out_safe({ "sh", "-c", "free | awk '/Mem/ {printf \"%.2f\", $3 / 1000000}'" })
        local mem_total_str, mem_total_hl, total_ok =
            command_out_safe({ "sh", "-c", "free | awk '/Mem/ {printf \"%.2f\", $2 / 1000000}'" })
        local mem_perc
        local mem_perc_str = "n/a"
        local mem_hl = "Comment"

        if used_ok and total_ok then
            local mem_total = tonumber(mem_total_str)
            mem_perc = tonumber(mem_used_str) / mem_total * 100
            mem_perc_str = string.format("%.2f", mem_perc)
            mem_total_str = tostring(math.floor(mem_total)) .. "G"
            mem_used_str = mem_used_str .. "G"

            mem_hl = hl_by_num(mem_perc)
        end

        return {
            space_between(key("Type"), {
                val = os_str,
                hl = os_hl,
            }),
            space_between(key("Uptime"), {
                val = uptime,
                hl = uptime_hl,
            }),
            space_between(key("CPU-Usage"), {
                val = cpu_usage_str .. "  %",
                hl = cpu_usage_hl,
            }),
            space_between(key("CPU-Temp"), {
                val = cpu_temp .. " °C",
                hl = cpu_temp_hl,
            }),
            space_between(key("Memory"), {
                val = mem_used_str .. " / " .. mem_total_str .. " -> " .. mem_perc_str .. "  %",
                hl = mem_hl,
            }),
        }
    end

    local function lazy()
        return space_between(key("Loaded plugins"), {
            val = #require("lazy").plugins(),
            hl = "Default",
        })
    end

    -- flatten table
    local function construct_table(parts)
        local final = {}

        for _, el in ipairs(parts) do
            if type(el) == "table" and el.type == nil then
                for _, inner_el in ipairs(el) do
                    table.insert(final, inner_el)
                end
            else
                table.insert(final, el)
            end
        end
        return final
    end

    return {
        type = "group",
        val = construct_table({
            seperator_heading("-", "OS"),
            os_info(),
            seperator_heading("-", "Lazy 󰒲"),
            lazy(),
            seperator("‾"),
        }),
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
local timer_id = -1
local quote_saved = quote()
local line_numbers = vim.opt.number
local function config()
    vim.opt.number = false
    return {
        layout = {
            padding(4),
            logo,
            padding(1),
            versions(),
            padding(2),
            stats_table(),
            padding(2),
            quote_saved,
        },
    }
end

function close()
    local buf = vim.api.nvim_get_current_buf()
    if timer_id ~= -1 then
        vim.fn.timer_stop(timer_id)
    end
    vim.api.nvim_buf_set_option(buf, "modifiable", true) -- unlock it
    vim.opt.number = line_numbers
    vim.cmd("enew")
    vim.cmd("startinsert")
    pcall(vim.api.nvim_buf_delete, buf, { force = true })
end

vim.api.nvim_create_autocmd("FileType", {
    pattern = "alpha",
    callback = function()
        vim.keymap.set("n", "i", close, { buffer = true, noremap = true, silent = true })
        vim.keymap.set("n", "<CR>", function ()end, { buffer = true, noremap = true, silent = true })
    end,
})

timer_id = vim.fn.timer_start(1000, function()
    alpha.setup(config())
    alpha.redraw()
end, { ["repeat"] = -1 })

alpha.setup(config())

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
--                 height = 19,
--             })
--             :render()
--     end,
-- })
