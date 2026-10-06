local JdkManager = require("config.lazy_plugins.java.jdks")
local GUI = require("config.lazy_plugins.java.gui")

local subcommands = {
    ["jdk-add"] = {
        cmd = function(opts)
            if #opts.fargs ~= 4 then
                vim.notify("jdk-add requires exactly 4 arguments", vim.log.levels.ERROR)
                return
            end

            local name = opts.fargs[2]
            local version = opts.fargs[3]
            local path = opts.fargs[4]

            local version_parsed = tonumber(version)
            if version_parsed ~= nil and version_parsed >= 8 then
                if JdkManager.jdk_exists(name) then
                    vim.notify("JDK with name " .. name .. " already exists!", vim.log.levels.ERROR)
                    return
                end

                JdkManager.add_jdk(name, path, version_parsed)
                vim.notify("Added jdk " .. name .. "!")
            else
                vim.notify("Invalid jdk-version provided!", vim.log.levels.ERROR)
            end
        end,

        cmplt = function(arglead, cmdline, cursorpos)
            local before = cmdline:sub(1, cursorpos)
            local parts = vim.split(before, "%s+", { trimempty = true })
            vim.notify("JDKs hit " .. arglead)

            local argc = #parts - 1
            if arglead == "" then
                argc = argc + 1
            end

            if argc == 4 then
                return vim.fn.getcompletion(arglead, "dir")
            end

            return {}
        end,
    },
    ["jdk-menu"] = {
        cmd = function(_)
            GUI.show_menu()
        end,
        cmplt = function()
            return {}
        end
    },
    ["download-lombok"] = {
        cmd = function()
            local lombok_dir = vim.fn.stdpath("data") .. "/lombok"
            local lombok = lombok_dir .. "/lombok.jar"

            if vim.fn.filereadable(lombok) == 0 then
                vim.fn.mkdir(lombok_dir, "p")
                vim.notify("Downloading lombok.jar...")
                local result = vim.system({
                    "curl", "-fsSL",
                    "https://projectlombok.org/downloads/lombok.jar",
                    "-o", lombok,
                }):wait()

                if result.code ~= 0 then
                    vim.notify("Lombok download failed: " .. (result.stderr or ""), vim.log.levels.ERROR)
                    os.remove(lombok)
                    return
                end
                vim.notify("Lombok successfully downloaded!")
            end
        end,
        cmplt = function()

        end
    }
}

-- create user-commands
vim.api.nvim_create_user_command("Java", function(opts)
    local subcommand = opts.fargs[1]
    if ! subcommands[subcommand] then
        vim.notify("Invalid subcommand!", vim.log.levels.ERROR)
        return
    end

    subcommands[subcommand].cmd(opts)
end, {

    nargs = "+",
    complete = function(arg_lead, cmd_line, cursorpos)
        local parts = vim.split(cmd_line, "%s+", { trimempty = true })
        if #parts <= 1 then
            return vim.tbl_filter(function(name)
                return vim.startswith(name, arg_lead)
            end, vim.tbl_keys(subcommands))
        end

        local subcommand = parts[2]
        if ! subcommands[subcommand] then
            return {}
        end
        return subcommands[subcommand].cmplt(arg_lead, cmd_line, cursorpos)
    end,
})
