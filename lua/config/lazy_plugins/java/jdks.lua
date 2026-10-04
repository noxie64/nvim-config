local NVIM_JAVA_DIR = vim.fn.stdpath("data") .. "/nvim-java"
local JDK_FILE = NVIM_JAVA_DIR .. "/jdks.json"

-- load jdks

local M = { JDKS = {} }

function create_dir()
    local dir_stat = vim.uv.fs_stat(NVIM_JAVA_DIR)
    if not (dir_stat and dir_stat.type == "directory") then
        vim.fn.mkdir(NVIM_JAVA_DIR, "p")
    end
end

local function load_jdks()
    create_dir()

    local jdk_file_stat = vim.uv.fs_stat(JDK_FILE)
    if jdk_file_stat and jdk_file_stat.type == "file" then
        local f = io.open(JDK_FILE, "r")
        M.JDKS = vim.json.decode(f:read("*all"))
        f:close()
    end
end

function M.save_jdks()
    create_dir()

    local f = io.open(JDK_FILE, "w")
    f:write(vim.json.encode(M.JDKS))
    f:close()
end

vim.api.nvim_create_autocmd("VimEnter", {
    callback = load_jdks,
})

vim.api.nvim_create_autocmd("VimLeave", {
    callback = M.save_jdks,
})

return M
