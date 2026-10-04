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

    local boxes = {}
    local layout = nil
    local closed = false
    local inputs = {}

    local function is_own_buf(bufnr)
        for _, input in ipairs(inputs) do
            if input.bufnr == bufnr then
                return true
            end
        end
        return false
    end

    local function unmount_on_cursor_leave(target_for_e, target_for_close)
        target_for_e:on(event.BufLeave, function()
            if closed then
                return
            end

            if not is_own_buf(vim.api.nvim_get_current_buf()) then
                closed = true
                layout:unmount()
            end
            target_for_close:unmount()
        end)
    end

    local function add(input)
        table.insert(inputs, input)
        table.insert(boxes, Layout.Box(input, { grow = 1 }))

        local config = {
            position = "50%",
            size = { width = "50%", height = 4 },
        }
        local root = Layout.Box(boxes, { dir = "col" })

        if layout == nil then
            layout = Layout(config, root)
        else
            layout:update(config, root)
        end

        unmount_on_cursor_leave(input, layout)
    end

    add(create_input(f, f, "JDK Name"))
    add(create_input(f, f, "JDK Path"))
    return layout
end

-- create user-commands

