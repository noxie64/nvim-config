local NVIM_JAVA_DIR = vim.fn.stdpath("data") .. "/nvim-java"
local JDK_FILE = NVIM_JAVA_DIR .. "/jdks.json"

-- load jdks

local M = { JDKS = {} }

local function create_dir()
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
        local content = f:read("*all")
        if vim.fn.trim(content) ~= "" then
            M.JDKS = vim.json.decode(content)
        end
        f:close()
    end
end

function M.save_jdks()
    create_dir()

    local f = io.open(JDK_FILE, "w")
    f:write(vim.json.encode(M.JDKS))
    f:close()
end

load_jdks()

function M.jdk_exists(name)
    for _, row in ipairs(M.JDKS) do
        return row.name == name
    end

    return false
end

function M.set_default(name)
    for _, row in ipairs(M.JDKS) do
        if row.name == name then
            name.default = true
        end
    end
end

function M.add_jdk(name, path)
    M.JDKS[name] = {
        name = name,
        path = path,
        default = #M.JDKS == 0,
    }
    M.save_jdks()
end

return M
