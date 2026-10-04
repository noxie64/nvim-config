local jdk_manager = require('config.lazy_plugins.java.jdks')

-- create user-commands
vim.api.nvim_create_user_command("JavaAddJDK", function(opts)
    vim.notify(vim.inspect(opts))
    if #opts.fargs ~= 2 then
        vim.notify("Copy requires exactly 2 arguments", vim.log.levels.ERROR)
        return
    end

    local name = opts.fargs[1]
    local path = opts.fargs[2]
    table.insert(jdk_manager.JDKS, { name = name, path = path})
    jdk_manager.save_jdks()
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
