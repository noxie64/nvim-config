local map = vim.keymap.set
local opts = { silent = true, noremap = true }

-- chr-wrapper
function wrap(padd)
    local function read_chr(wrapper_key_start)
        local wrapper_key_end = wrapper_key_start

        if wrapper_key_start == "{" then
            wrapper_key_end = "}"
        end
        if wrapper_key_start == "(" then
            wrapper_key_end = ")"
        end
        if wrapper_key_start == "[" then
            wrapper_key_end = "]"
        end
        return {
            start = wrapper_key_start,
            ["end"] = wrapper_key_end,
        }
    end

    local key = vim.fn.getcharstr()
    local wrapper = read_chr(key)

    local region = vim.fn.getregion(vim.fn.getpos("v"), vim.fn.getpos("."), {
        type = "v",

        exclusive = false,

        eol = false,

        bounds = true,
    })

    local regionPos = vim.fn.getregionpos(vim.fn.getpos("v"), vim.fn.getpos("."), {
        type = "v",

        exclusive = false,

        eol = false,

        bounds = true,
    })

    local line_start = regionPos[1][1]
    local line_end = regionPos[#regionPos][2]

    local cords = {
        start = {
            row = line_start[2],
            col = line_start[3],
        },
        ["end"] = {
            row = line_end[2],
            col = line_end[3],
        },
    }

    local inline = cords.start.row == cords["end"].row

    local replacement = { wrapper.start }
    if inline then
        replacement = {
            wrapper.start .. padd .. region[1] .. padd .. wrapper["end"],
        }
    else
        for _, line in ipairs(region) do
            table.insert(replacement, string.rep(" ", vim.o.tabstop) .. line)
        end
        table.insert(replacement, wrapper["end"])
    end

    vim.api.nvim_buf_set_text(
        0,
        -- row, col
        cords.start.row - 1,
        cords.start.col - 1,
        cords["end"].row - 1,
        cords["end"].col,
        replacement
    )

    vim.api.nvim_feedkeys(vim.keycode('<ESC>'), 'n', true)
end
