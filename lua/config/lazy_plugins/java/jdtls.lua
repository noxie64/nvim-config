local jdtls = require("jdtls")
local JdkManager = require("config.lazy_plugins.java.jdks")

local lombok = vim.fn.stdpath("data") .. "/lombok/lombok.jar"

local root_dir = require("jdtls.setup").find_root({ "mvnw", "gradlew", "pom.xml", "build.gradle" })

local project_name = vim.fn.fnamemodify(root_dir, ":p:h:t")
local workspace_dir = vim.fn.stdpath("data") .. "/rdtls-workspace/" .. project_name

local config = {
    cmd = { "jdtls", "--jvm-arg=-javaagent:" .. lombok, "-data", workspace_dir },
    root_dir = root_dir,
    settings = {
        java = {
            import = {
                generatesMetadataFilesAtProjectRoot = false,
            },
            configuration = { runtimes = JdkManager.to_jdtls_jdks() },
        },
    },
}

vim.api.nvim_create_autocmd("FileType", {
    pattern = "java",
    callback = function(args)
        local name = vim.api.nvim_buf_get_name(args.buf)
        if name == "" or not name:match("^/") then
            return
        end
        require("jdtls").start_or_attach(config)
    end,
})
