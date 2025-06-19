return {
    {
        "kylechui/nvim-surround",
        version = "^3.0.0", -- Use for stability; omit to use `main` branch for the latest features
        event = "VeryLazy",
        -- event = "InsertEnter", -- Load on InsertEnter event
        config = function()
            require("nvim-surround").setup {
                -- Configuration here, or leave empty to use defaults
            }
        end,
    },

    {
        "m4xshen/hardtime.nvim",
        lazy = false,
        dependencies = { "MunifTanjim/nui.nvim" },
        opts = {},
        config = function(_, opts)
            require("hardtime").setup(opts)
        end,
    },

    {
        "zbirenbaum/copilot.lua",
        event = "InsertEnter",
        config = function()
            require("copilot").setup {
                suggestion = { enabled = true, auto_trigger = true },
                panel = { enabled = false },
                keymap = {
                    accept = "<C-Space>", -- already handled above
                },
                filetypes = {
                    rust = false, -- disable copilot for Rust files
                    python = false, -- disable copilot for Python files
                    go = false,
                    html = false,
                },
            }
        end,
    },

    {
        "zbirenbaum/copilot-cmp",
        after = { "copilot.lua", "nvim-cmp" },
        config = function()
            require("copilot_cmp").setup()
        end,
    },

    {
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
        end,
    },

    {
        "williamboman/mason.nvim",
        build = ":MasonUpdate",
        lazy = false, -- or event = "VeryLazy" if you want deferred loading
        config = function()
            require "configs.mason"
        end,
    },

    {
        "tpope/vim-fugitive",
        cmd = { "Git", "G", "Gdiffsplit", "Gvdiffsplit", "Gwrite", "Gread", "Glog" }, -- optional lazy loading
    },

    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        lazy = false,
        config = function()
            require "configs.lspconfig"
        end,
    },

    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        config = function()
            require("nvim-autopairs").setup()
            local cmp_autopairs = require "nvim-autopairs.completion.cmp"
            local cmp = require "cmp"
            cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
        end,
    },

    {
        "chentoast/marks.nvim",
        event = "BufReadPost",
        config = function()
            require("marks").setup()
        end,
    },

    {
        "folke/noice.nvim",
        event = "VeryLazy",
        dependencies = {
            "MunifTanjim/nui.nvim",
            "rcarriga/nvim-notify",
            "hrsh7th/nvim-cmp",
            "hrsh7th/cmp-cmdline",
        },
        config = function()
            require "configs.noice"
        end,
    },

    {
        "folke/snacks.nvim",
        priority = 1000,
        lazy = false,
        ---@type snacks.Config
        opts = {
            -- your configuration comes here
            -- or leave it empty to use the default settings
            -- refer to the configuration section below
            bigfile = { enabled = true },
            dashboard = { enabled = true },
            explorer = { enabled = true },
            indent = { enabled = true },
            input = { enabled = true },
            picker = { enabled = true },
            notifier = { enabled = true },
            quickfile = { enabled = true },
            scope = { enabled = true },
            scroll = { enabled = false },
            statuscolumn = { enabled = true },
            words = { enabled = true },
        },
        keys = {
            {
                "<leader>sm",
                function()
                    Snacks.picker.marks()
                end,
                desc = "Marks",
            },
            {
                "<leader>fe",
                function()
                    Snacks.explorer()
                end,
                desc = "File Explorer",
            },
        },
    },

    {
        "folke/which-key.nvim",
        event = "VimEnter",
        opts = {
            -- your configuration comes here
            -- or leave it empty to use the default settings
            -- refer to the configuration section below
        },
        keys = {
            {
                "<leader>?",
                function()
                    require("which-key").show { global = false }
                end,
                desc = "Buffer Local Keymaps (which-key)",
            },
        },
    },

    {
        "numToStr/FTerm.nvim",
        config = function()
            require "configs.terminal"
        end,
    },

    {
        "A7lavinraj/assistant.nvim",
        lazy = false,
        enabled = true,
        keys = {
            { "<leader>a", "<cmd>Assistant<cr>", desc = "Assistant.nvim" },
        },
        opts = {
            ui = {
                border = "single",
                diff_mode = false,
            },
        },
    },

    {
        "L3MON4D3/LuaSnip",
        dependencies = { "rafamadriz/friendly-snippets" },
        config = function()
            local ls = require "luasnip"

            -- Load VSCode-style snippets
            require("luasnip.loaders.from_vscode").lazy_load()

            -- Load custom Lua-based snippets
            require("luasnip.loaders.from_lua").lazy_load { paths = "~/.config/nvim/lua/snippets" }
            vim.api.nvim_set_keymap("i", "<A-.>", [[<cmd>lua require'luasnip'.jump(1)<CR>]], { noremap = true })
            vim.api.nvim_set_keymap("s", "<A-.>", [[<cmd>lua require'luasnip'.jump(1)<CR>]], { noremap = true })

            vim.api.nvim_set_keymap("i", "<A-,>", [[<cmd>lua require'luasnip'.jump(-1)<CR>]], { noremap = true })
            vim.api.nvim_set_keymap("s", "<A-,>", [[<cmd>lua require'luasnip'.jump(-1)<CR>]], { noremap = true })
        end,
    },

    {
        "hrsh7th/cmp-cmdline",
        event = "CmdlineEnter",
        dependencies = { "hrsh7th/nvim-cmp" },
        config = function()
            local cmp = require "cmp"
            cmp.setup.cmdline(":", {
                mapping = cmp.mapping.preset.cmdline(),
                sources = cmp.config.sources({
                    { name = "path" },
                }, {
                    { name = "cmdline" },
                }),
            })
            cmp.setup.cmdline({ "/", "?" }, {
                mapping = cmp.mapping.preset.cmdline(),
                sources = {
                    { name = "buffer" },
                },
            })
        end,
    },

    -- {
    --     "hrsh7th/nvim-cmp",
    --     dependencies = {
    --         { "hrsh7th/cmp-nvim-lsp" },
    --         { "hrsh7th/cmp-buffer" },
    --         { "hrsh7th/cmp-path" },
    --         { "hrsh7th/cmp-cmdline" },
    --         { "L3MON4D3/LuaSnip" },
    --         { "saadparwaiz1/cmp_luasnip" },
    --     },
    --     config = function()
    --         require "configs.nvim-cmp"
    --     end,
    -- },

    {
        "zapling/mason-conform.nvim",
        event = "VeryLazy",
        dependencies = { "conform.nvim" },
        config = function()
            require "configs.mason-conform"
        end,
    },

    {
        "stevearc/conform.nvim",
        -- event = "BufWritePre", -- uncomment for format on save
        opts = require "configs.conform",
        keys = {
            {
                "<leader>fm",
                function()
                    require("conform").format { async = true, lsp_format = "fallback" }
                end,
                mode = "",
                desc = "[F]ormat buffer",
            },
        },
    },

    {
        "williamboman/mason-lspconfig.nvim",
        event = "VeryLazy",
        dependencies = { "nvim-lspconfig" },
        config = function()
            require "configs.mason-lspconfig"
        end,
    },

    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            require "configs.treesitter"
        end,
    },

    {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.8",
        cmd = "Telescope", -- Lazy-load on :Telescope command
        lazy = false,
        keys = {
            {
                "<leader>th",
                function()
                    require("theme_picker").open()
                end,
                desc = "Pick Theme",
            },
        },
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require "configs.telescope"
        end,
    },

    {
        "numToStr/FTerm.nvim",
        config = function()
            require "configs.terminal"
        end,
    },

    {
        "nvim-tree/nvim-tree.lua",
        opts = {
            filters = {
                git_ignored = false, -- doesn't respect .gitinore
            },
        },
    },

    -- {
    --     -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
    --     -- used for completion, annotations and signatures of Neovim apis
    --     "folke/lazydev.nvim",
    --     ft = "lua",
    --     opts = {
    --         library = {
    --             -- Load luvit types when the `vim.uv` word is found
    --             { path = "${3rd}/luv/library", words = { "vim%.uv" } },
    --         },
    --     },
    -- },
}
