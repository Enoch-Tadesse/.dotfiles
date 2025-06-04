local jdtls = require "jdtls"
local home = os.getenv "HOME"
local workspace_dir = home .. "/.local/share/eclipse/" .. vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")

local capabilities = require("cmp_nvim_lsp").default_capabilities()

local config = {
    cmd = {
        "jdtls",
        "-data",
        workspace_dir,
    },
    capabilities = capabilities,
    root_dir = require("jdtls.setup").find_root { ".git", "mvnw", "gradlew", "build.gradle", "pom.xml" },
}

jdtls.start_or_attach(config)
