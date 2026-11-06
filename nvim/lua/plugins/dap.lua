return {
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            "rcarriga/nvim-dap-ui",
            "nvim-neotest/nvim-nio",
            "theHamsta/nvim-dap-virtual-text",
            "mfussenegger/nvim-dap-python",
        },
        cmd = { "DapToggleBreakpoint", "DapContinue" },
        keys = {
            {
                "<leader>db",
                function()
                    require("dap").toggle_breakpoint()
                end,
                desc = "Toggle Breakpoint",
            },
            {
                "<leader>dB",
                function()
                    vim.ui.input({ prompt = "Breakpoint condition: " }, function(input)
                        if input and input ~= "" then
                            require("dap").set_breakpoint(input)
                        end
                    end)
                end,
                desc = "Conditional Breakpoint",
            },
            {
                "<leader>dc",
                function()
                    require("dap").continue()
                end,
                desc = "Debug: Continue / Start",
            },
            {
                "<leader>do",
                function()
                    require("dap").step_over()
                end,
                desc = "Debug: Step Over",
            },
            {
                "<leader>di",
                function()
                    require("dap").step_into()
                end,
                desc = "Debug: Step Into",
            },
            {
                "<leader>dO",
                function()
                    require("dap").step_out()
                end,
                desc = "Debug: Step Out",
            },
            {
                "<leader>du",
                function()
                    require("dapui").toggle()
                end,
                desc = "Toggle Debugger UI",
            },
            {
                "<leader>dr",
                function()
                    require("dap").repl.open()
                end,
                desc = "Open Debugger REPL",
            },
            {
                "<leader>dt",
                function()
                    require("dap").terminate()
                    require("dapui").close()
                end,
                desc = "Terminate Debugger",
            },
            {
                "<F5>",
                function()
                    require("dap").continue()
                end,
                desc = "Debug: Continue",
            },
            {
                "<F10>",
                function()
                    require("dap").step_over()
                end,
                desc = "Debug: Step Over",
            },
            {
                "<F11>",
                function()
                    require("dap").step_into()
                end,
                desc = "Debug: Step Into",
            },
            {
                "<F12>",
                function()
                    require("dap").step_out()
                end,
                desc = "Debug: Step Out",
            },
        },
        config = function()
            require "configs.dap"
        end,
    },

    {
        "nvim-neotest/neotest",
        dependencies = {
            "nvim-neotest/nvim-nio",
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
            "nvim-neotest/neotest-python",
        },
        cmd = { "Neotest" },
        keys = {
            {
                "<leader>tn",
                function()
                    require("neotest").run.run()
                end,
                desc = "Run Nearest Test",
            },
            {
                "<leader>tf",
                function()
                    require("neotest").run.run(vim.fn.expand "%")
                end,
                desc = "Run Test File",
            },
            {
                "<leader>ts",
                function()
                    require("neotest").run.run { suite = true }
                end,
                desc = "Run Test Suite",
            },
            {
                "<leader>to",
                function()
                    require("neotest").output.open { enter = true }
                end,
                desc = "Open Test Output",
            },
            {
                "<leader>tS",
                function()
                    require("neotest").summary.toggle()
                end,
                desc = "Toggle Test Summary",
            },
            {
                "<leader>td",
                function()
                    require("neotest").run.run { strategy = "dap" }
                end,
                desc = "Debug Nearest Test",
            },
        },
        config = function()
            require "configs.neotest"
        end,
    },
}
