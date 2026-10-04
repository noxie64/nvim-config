local JdkManager = require('config.lazy_plugins.java.jdks')
local GUI = require("config.lazy_plugins.java.gui")

-- create user-commands
vim.api.nvim_create_user_command("JavaAddJDK", function(opts)
    if #opts.fargs ~= 2 then
        vim.notify("Copy requires exactly 2 arguments", vim.log.levels.ERROR)
        return
    end

    local name = opts.fargs[1]
    local path = opts.fargs[2]

    if JdkManager.jdk_exists(name) then
        vim.notify("JDK with name " .. name .. " already exists!", vim.log.levels.ERROR)
        return
    end

    JdkManager.add_jdk(name, path)
    vim.notify("Added jdk " .. name .. "!")
end, {
    nargs = "+",
    complete = function(arglead, cmdline, cursorpos)
        local before = cmdline:sub(1, cursorpos)
        local parts = vim.split(before, "%s+", { trimempty = true })

        local argc = #parts - 1
        if arglead == "" then
            argc = argc + 1
        end

        if argc == 2 then
            return vim.fn.getcompletion(arglead, "file")
        end

        return {}
    end,
})

vim.api.nvim_create_user_command("JavaJDKMenu", function(opts)
    GUI.show_menu()
end, {})
