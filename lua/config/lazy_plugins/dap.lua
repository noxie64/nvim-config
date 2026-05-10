local dap = require("dap")

dap.adapters.cppdbg = {
    id = "cppdbg",
    type = "executable",
    command = vim.fn.stdpath("data") .. "/mason/bin/OpenDebugAD7",
}

dap.configurations.cpp = {
    {
        name = "Launch file",
        type = "cppdbg",
        request = "launch",
        program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
        end,
        cwd = "${workspaceFolder}",
        stopAtEntry = true,
        setupCommands = {
            { text = "-enable-pretty-printing", description = "Enable GDB pretty printing" },
        },
        args = function()
            local args = vim.fn.input("Arguments: ")
            return vim.split(args, " ")
        end,
    },
}

dap.configurations.c = dap.configurations.cpp

require("dapui").setup({
    controls = {
        enabled = false,
    },
})

require("persistent-breakpoints").setup({
  load_breakpoints_event = { "BufReadPost" },
})
