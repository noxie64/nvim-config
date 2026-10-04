local M = {}

PROJECT_INFO_FILE = vim.fn.getcwd() .. ".java-project"

function M.save_project_info(jdk)
    local ProjectInfo = {
        jdk = jdk
    }

    local f = io.open(PROJECT_INFO_FILE, "w")
    f:write(vim.json.encode(ProjectInfo))
end

function M.detect_java_project()
    local stat = vim.uv.fs_stat(PROJECT_INFO_FILE)

    if stat and stat.type == 'file' then
        vim.notify("Java project detected! Using default ")
    end
end
