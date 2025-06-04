return {
    "nvim-java/nvim-java",
    dependencies = {
        "nvim-java/lua-async-await",
        "nvim-java/nvim-java-core",
        "nvim-java/nvim-java-test",
        "nvim-java/nvim-java-dap",
        "MunifTanjim/nui.nvim",
        "mfussenegger/nvim-dap",
        "williamboman/mason.nvim",
        {
            "williamboman/mason.nvim",
            opts = {
                registries = {
                    "github:nvim-java/mason-registry",
                    "github:mason-org/mason-registry",
                },
            },
        },
    },
    config = function()
        require("java").setup {
            jdk = {
                auto_install = false,
                -- version = "23.0.2",
                version = "24.0.1",
            },
        }
        -- local jdkPath = "/usr/lib/jvm/jdk-23.0.2-oracle-x64/"
        -- require("lspconfig").jdtls.setup {
        --     -- settings = {
        --     --     java = {
        --     --         configuration = {
        --     --             runtimes = {
        --     --                 {
        --     --                     name = "JavaSE-23",
        --     --                     path = jdkPath,
        --     --                     default = true,
        --     --                 },
        --     --             },
        --     --         },
        --     --     },
        --     -- },
        --     filetypes = { "java" },
        -- }
    end,
}
