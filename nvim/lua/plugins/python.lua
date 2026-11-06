return {
    {
        "linux-cultist/venv-selector.nvim",
        dependencies = {
            "neovim/nvim-lspconfig",
            "nvim-telescope/telescope.nvim",
            "mfussenegger/nvim-dap-python",
        },
        lazy = false,
        cmd = { "VenvSelect", "VenvSelectCached" },
        keys = {
            { "<leader>vs", "<cmd>VenvSelect<cr>", desc = "Select VirtualEnv (Telescope)" },
            { "<leader>vc", "<cmd>VenvSelectCached<cr>", desc = "Select Cached VirtualEnv" },
            {
                "<leader>va",
                function()
                    require("configs.venv-autodetect").autodetect(true)
                end,
                desc = "Auto-detect Project VirtualEnv",
            },
            {
                "<leader>vi",
                function()
                    require("configs.venv-autodetect").show_info()
                end,
                desc = "Python & VirtualEnv Info",
            },
        },
        opts = {
            settings = {
                options = {
                    notify_user_on_activate = true,
                    auto_refresh = true,
                },
            },
        },
    },
}
