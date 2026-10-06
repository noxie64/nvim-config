local Input = require("nui.input")
local Menu = require("nui.menu")
local JdkManager = require("config.lazy_plugins.java.jdks")

function create_input(on_submit, on_close, title)
    return Input({
        position = "50%",
        size = {
            width = 20,
        },
        border = {
            style = "rounded",
            text = {
                top = title,
                top_align = "center",
            },
        },
        win_options = {
            winhighlight = "Normal:Normal,FloatBorder:Normal",
        },
    }, {
        prompt = "> ",
        default_value = "Hello",
        on_close = on_close,
        on_submit = on_submit,
    })
end

local M = {}
function M.show_menu()
    vim.notify(vim.inspect(JdkManager))
    if next(JdkManager.serializable.JDKS) == nil then
        vim.notify("No jdks saved yet!", vim.log.levels.ERROR)
        return
    end

    local function to_menu_items(jdks)
        local transformed = {}
        for k, v in pairs(jdks) do
            local name = k .. " [v" .. v.version .. "]"
            vim.notify(JdkManager.serializable.default_jdk)
            table.insert(
                transformed,
                Menu.item((JdkManager.serializable.default_jdk == k and "* " .. name or name), {
                    name = k,
                })
            )
        end

        return transformed
    end

    local menu = Menu({
        position = "50%",
        size = {
            width = 25,
            height = 5,
        },
        border = {
            style = "single",
            text = {
                top = "[JDKs]",
                top_align = "center",
            },
        },
        win_options = {
            winhighlight = "Normal:Normal,FloatBorder:Normal",
        },
    }, {
        lines = to_menu_items(JdkManager.serializable.JDKS),
        max_width = 20,
        keymap = {
            focus_next = { "j", "<Down>", "<Tab>" },
            focus_prev = { "k", "<Up>", "<S-Tab>" },
            close = { "<Esc>", "<C-c>" },
            submit = { "<CR>", "<Space>" },
        },
        on_close = function()
            print("Menu Closed!")
        end,
        on_submit = function(item)
            print("Menu Submitted: ", item.text)
        end,
    })

    menu:mount()
end

return M
