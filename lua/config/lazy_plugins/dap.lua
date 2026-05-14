local dap = require("dap")

dap.adapters.cppdbg = {
    id = "cppdbg",
    type = "executable",
    command = vim.fn.stdpath("data") .. "/mason/bin/OpenDebugAD7",
}

-- install debugpy first: sudo pacman -S python-debugpy
dap.adapters.python = function(cb, config)
  if config.request == "attach" then
    ---@diagnostic disable-next-line: undefined-field
    local port = (config.connect or config).port
    ---@diagnostic disable-next-line: undefined-field
    local host = (config.connect or config).host or "127.0.0.1"
    cb({
      type = "server",
      port = assert(port, "`connect.port` is required for attach"),
      host = host,
      options = { source_filetype = "python" },
    })
  else
    cb({
      type = "executable",
      -- Prefer the debugpy inside the active venv; fall back to a global one.
      command = vim.fn.exepath("python") ~= "" and vim.fn.exepath("python") or "python3",
      args = { "-m", "debugpy.adapter" },
      options = { source_filetype = "python" },
    })
  end
end

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

dap.configurations.python = {
    {
        type = "python",
        request = "launch",
        name = "Launch file with args",
        program = "${file}",
        args = function()
            local args_str = vim.fn.input("Arguments: ")
            return vim.split(args_str, " ", { trimempty = true })
        end,
        pythonPath = function()
            local venv = os.getenv("VIRTUAL_ENV")
            if venv then
                return venv .. "/bin/python"
            end
            return "python3"
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
