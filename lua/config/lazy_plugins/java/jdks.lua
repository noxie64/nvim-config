local NVIM_JAVA_DIR = vim.fn.stdpath("data") .. "/nvim-java"
local JDK_FILE = NVIM_JAVA_DIR .. "/jdks.json"

-- load jdks

local M = {
    serializable = {
        JDKS = {}, default_jdk = nil
    }
}

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
            M.serializable = vim.json.decode(content)
        end
        f:close()
    end
end

function M.save_jdks()
    create_dir()

    local f = io.open(JDK_FILE, "w")
    f:write(vim.json.encode(M.serializable))
    f:close()
end

load_jdks()

function M.jdk_exists(name)
    return M.serializable.JDKS[name] ~= nil
end

function M.set_default(name)
    if not M.jdk_exists(name) then
        error("JDK " .. name .. " doesn't exist!")
    end
    M.serializable.default_jdk = name
    M.save_jdks()
    vim.notify("Set " .. name .. " as the default jdk!")
end

function M.add_jdk(name, path, version)
    if M.serializable.default_jdk == nil then
        M.serializable.default_jdk = name
    end
    M.serializable.JDKS[name] = {
        name = name,
        path = path,
        version = version,
    }
    M.save_jdks()
end

function M.delete_jdk(name)
    if not M.jdk_exists(name) then
        error("JDK " .. name .. " doesn't exist!")
    end

    M.serializable.JDKS[name] = nil
    if M.serializable.default_jdk == name then
        M.serializable.default_jdk = nil
    end

    M.save_jdks()
end

return M
