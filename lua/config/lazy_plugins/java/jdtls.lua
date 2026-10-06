local jdtls = require("jdtls")
local JdkManager = require("config.lazy_plugins.java.jdks")

local root_dir = require("jdtls.setup").find_root({ ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" })

local project_name = vim.fn.fnamemodify(root_dir, ":p:h:t")
local workspace_dir = vim.fn.stdpath("data") .. "/rdtls-workspace/" .. project_name

local config = {
    cmd = { "jdtls", "-data", workspace_dir },
    root_dir = root_dir,
    settings = {
        java = {
            import = {
                generatesMetadataFilesAtProjectRoot = false,
            },
            configuration = { runtimes = JdkManager.to_jdtls_jdks() }
        }
    },
}

jdtls.start_or_attach(config)
