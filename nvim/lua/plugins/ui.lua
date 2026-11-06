return {
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        event = "VeryLazy",
        config = function()
            require "configs.lualine"
        end,
    },

    {
        "MeanderingProgrammer/render-markdown.nvim",
        dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
        ft = { "markdown", "quarto" },
        config = function()
            require "configs.render-markdown"
        end,
    },

    {
        "kevinhwang91/nvim-ufo",
        dependencies = { "kevinhwang91/promise-async" },
        event = "BufReadPost",
        keys = {
            {
                "zR",
                function()
                    require("ufo").openAllFolds()
                end,
                desc = "Open all folds",
            },
            {
                "zM",
                function()
                    require("ufo").closeAllFolds()
                end,
                desc = "Close all folds",
            },
        },
        config = function()
            require "configs.ufo"
        end,
    },

    {
        "sindrets/diffview.nvim",
        cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles", "DiffviewFileHistory" },
        keys = {
            { "<leader>gdo", "<cmd>DiffviewOpen<cr>", desc = "Open Diffview" },
            { "<leader>gdc", "<cmd>DiffviewClose<cr>", desc = "Close Diffview" },
            { "<leader>gdh", "<cmd>DiffviewFileHistory %<cr>", desc = "Current File History" },
        },
    },

    {
        "lervag/vimtex",
        lazy = false,
        ft = { "tex", "plaintex" },
        init = function()
            vim.g.tex_flavor = "latex"
            vim.g.vimtex_view_method = "zathura"
            vim.g.vimtex_quickfix_mode = 0
        end,
    },
}
