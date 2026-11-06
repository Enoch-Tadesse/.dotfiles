return {
    {
        "GCBallesteros/jupytext.nvim",
        lazy = false,
        init = function()
            -- Patch get_ipynb_metadata to safely handle notebooks without kernelspec
            local ok, utils = pcall(require, "jupytext.utils")
            if ok and utils then
                utils.get_ipynb_metadata = function(filename)
                    local ok_read, data = pcall(function()
                        local f = io.open(filename, "r")
                        if not f then
                            return {}
                        end
                        local content = f:read "*a"
                        f:close()
                        return vim.json.decode(content)
                    end)
                    if ok_read and data and data.metadata then
                        local metadata = data.metadata
                        local language = "python"
                        if metadata.kernelspec and metadata.kernelspec.language then
                            language = metadata.kernelspec.language
                        elseif metadata.kernelspec and metadata.kernelspec.name then
                            language = metadata.kernelspec.name:match "python" and "python" or metadata.kernelspec.name
                        elseif metadata.language_info and metadata.language_info.name then
                            language = metadata.language_info.name
                        end
                        local ext = (language == "python" or language == "python3") and "py" or "py"
                        return { language = language, extension = ext }
                    end
                    return { language = "python", extension = "py" }
                end
            end
        end,
        opts = {
            style = "percent",
            output_extension = "auto",
            force_ft = "python",
        },
    },

    {
        "benlubas/molten-nvim",
        version = "^1.0.0",
        lazy = false,
        build = ":UpdateRemotePlugins",
        init = function()
            require "configs.molten"
        end,
        cmd = {
            "MoltenInit",
            "MoltenInfo",
            "MoltenEvaluateLine",
            "MoltenEvaluateVisual",
            "MoltenReevaluateCell",
            "MoltenShowOutput",
            "MoltenHideOutput",
            "MoltenDelete",
            "MoltenRestart",
        },
        keys = {
            { "<leader>mi", "<cmd>MoltenInit<cr>", desc = "Initialize Molten Kernel" },
            { "<leader>me", "<cmd>MoltenEvaluateOperator<cr>", desc = "Evaluate Operator" },
            { "<leader>ml", "<cmd>MoltenEvaluateLine<cr>", desc = "Evaluate Current Line" },
            { "<leader>mr", "<cmd>MoltenReevaluateCell<cr>", desc = "Re-evaluate Cell" },
            {
                "<leader>mv",
                ":<C-u>MoltenEvaluateVisual<cr>",
                mode = "v",
                desc = "Evaluate Visual Selection",
            },
            { "<leader>mo", "<cmd>MoltenShowOutput<cr>", desc = "Show Output Float" },
            { "<leader>mh", "<cmd>MoltenHideOutput<cr>", desc = "Hide Output Float" },
            { "<leader>md", "<cmd>MoltenDelete<cr>", desc = "Delete Cell Output" },
            { "<leader>mx", "<cmd>MoltenInterrupt<cr>", desc = "Interrupt Kernel" },
            { "<leader>mR", "<cmd>MoltenRestart<cr>", desc = "Restart Kernel" },
        },
    },

    {
        "GCBallesteros/NotebookNavigator.nvim",
        dependencies = {
            "benlubas/molten-nvim",
        },
        event = "VeryLazy",
        opts = {
            syntax_highlight = true,
            repl_provider = "molten",
        },
        keys = {
            {
                "]h",
                function()
                    require("notebook-navigator").move_cell "d"
                end,
                desc = "Next Cell",
            },
            {
                "[h",
                function()
                    require("notebook-navigator").move_cell "u"
                end,
                desc = "Previous Cell",
            },
            {
                "<leader>jr",
                function()
                    require("notebook-navigator").run_cell()
                end,
                desc = "Run Cell",
            },
            {
                "<leader>ja",
                function()
                    require("notebook-navigator").run_and_move()
                end,
                desc = "Run Cell and Move to Next",
            },
        },
    },

    {
        "Vigemus/iron.nvim",
        cmd = { "IronRepl", "IronRestart", "IronFocus", "IronHide" },
        keys = {
            {
                "<leader>rr",
                function()
                    require("iron.core").repl_toggle "python"
                end,
                desc = "Toggle Python REPL",
            },
            {
                "<leader>rf",
                function()
                    require("iron.core").send_file()
                end,
                desc = "Send File to REPL",
            },
            {
                "<leader>rl",
                function()
                    require("iron.core").send_line()
                end,
                desc = "Send Line to REPL",
            },
            {
                "<leader>rs",
                function()
                    require("iron.core").visual_send()
                end,
                mode = "v",
                desc = "Send Selection to REPL",
            },
            {
                "<leader>rc",
                function()
                    require("iron.core").send(nil, string.char(12))
                end,
                desc = "Clear REPL",
            },
            {
                "<leader>rq",
                function()
                    require("iron.core").close_repl "python"
                end,
                desc = "Close REPL",
            },
        },
        config = function()
            require "configs.repl"
        end,
    },
}
