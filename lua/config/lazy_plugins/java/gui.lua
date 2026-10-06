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
    if next(JdkManager.serializable.JDKS) == nil then
        vim.notify("No jdks saved yet!", vim.log.levels.ERROR)
        return
    end

    local function build_items()
        local transformed = {}
        for k, v in pairs(JdkManager.serializable.JDKS) do
            local name = k .. " [v" .. v.version .. "]"
            table.insert(
                transformed,
                Menu.item((JdkManager.serializable.default_jdk == k and "* " .. name or name), {
                    name = k,
                    name_ver = name,
                })
            )
        end

        return transformed
    end

    local menu = Menu({
        position = "50%",
        zindex = 1,
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
        lines = build_items(),
        max_width = 20,
        keymap = {
            focus_next = { "j", "<Down>", "<Tab>" },
            focus_prev = { "k", "<Up>", "<S-Tab>" },
            close = { "<Esc>", "q" },
            submit = {},
        },
        on_submit = function(item)
            print("Menu Submitted: ", item.text)
        end,
    })

    local function rerender()
        menu.tree:set_nodes(build_items())
        menu.tree:render()
    end

    menu:map("n", "<CR>", function()
        local item = menu.tree:get_node()
        local name = item.name
        if name == JdkManager.serializable.default_jdk then
            return
        end
        JdkManager.set_default(name)
        rerender()
    end)

    menu:map("n", "D", function()
        local item = menu.tree:get_node()
        vim.ui.input({
            prompt = "Delete " .. item.name_ver .. " (y/n)?",
        }, function(input)
            if input ~= "y" then
                vim.notify("Aborted!")
                return
            end

            JdkManager.delete_jdk(item.name)
            vim.notify("JDK " .. item.name_ver .. " was removed from jdk-cache!")
            if next(JdkManager.serializable.JDKS) == nil then
                menu:unmount()
            else
                rerender()
            end
        end)
    end)

    menu:mount()
end

return M
