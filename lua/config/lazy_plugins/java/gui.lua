local Input = require("nui.input")
local event = require("nui.utils.autocmd").event
local Layout = require("nui.layout")

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

local Creators = {}
function Creators.jdk_add_popup()
    local f = function() end

    function unmount_on_cursor_leave(target_for_e, target_for_close)
        target_for_e:on(event.BufLeave, function()
            target_for_close:unmount()
        end)
    end

    local boxes = {}

    local layout = Layout({
        size = {
            height = 2,
            width = "50%",
        },
        position = "50%",
    }, Layout.Box({}, { dir = "col" }))


    local function add(input)
        -- grow = 1 splits space evenly, however many boxes there are
        table.insert(boxes, Layout.Box(input, { grow = 1 }))
        layout:update(Layout.Box(boxes, { dir = "col" }))
    end

    add(create_input(f, f, "JDK Name"))
    add(create_input(f, f, "JDK Path"))

    return layout
end

-- create user-commands
vim.api.nvim_create_user_command(
    "JavaAddJDK", -- command name (must start with uppercase)
    function(opts)
        local show_jdk_add_popup = Creators.jdk_add_popup()
        show_jdk_add_popup:mount()
    end,
    {}
)
