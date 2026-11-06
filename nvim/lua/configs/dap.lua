local dap = require "dap"
local dapui = require "dapui"

-- Configure UI
dapui.setup {
    icons = { expanded = "▾", collapsed = "▸", current_frame = "▸" },
    mappings = {
        expand = { "<CR>", "<2-LeftMouse>" },
        open = "o",
        remove = "d",
        edit = "e",
        repl = "r",
        toggle = "t",
    },
    layouts = {
        {
            elements = {
                { id = "scopes", size = 0.25 },
                { id = "breakpoints", size = 0.25 },
                { id = "stacks", size = 0.25 },
                { id = "watches", size = 0.25 },
            },
            position = "left",
            size = 40,
        },
        {
            elements = {
                { id = "repl", size = 0.5 },
                { id = "console", size = 0.5 },
            },
            position = "bottom",
            size = 10,
        },
    },
    floating = {
        border = "rounded",
        mappings = {
            close = { "q", "<Esc>" },
        },
    },
}

-- Auto open/close dap-ui on debug events
dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
    dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
    dapui.close()
end

-- Signs
vim.fn.sign_define("DapBreakpoint", { text = "🔴", texthl = "DapBreakpoint", linehl = "", numhl = "" })
vim.fn.sign_define("DapBreakpointCondition", { text = "🟡", texthl = "DapBreakpointCondition", linehl = "", numhl = "" })
vim.fn.sign_define("DapBreakpointRejected", { text = "⚪", texthl = "DapBreakpointRejected", linehl = "", numhl = "" })
vim.fn.sign_define("DapLogPoint", { text = "📝", texthl = "DapLogPoint", linehl = "", numhl = "" })
vim.fn.sign_define("DapStopped", { text = "▶️", texthl = "DapStopped", linehl = "DapStoppedLine", numhl = "" })

-- Virtual text
pcall(function()
    require("nvim-dap-virtual-text").setup {
        commented = true,
    }
end)

-- Setup nvim-dap-python with Mason's debugpy
local debugpy_path = vim.fn.stdpath "data" .. "/mason/packages/debugpy/venv/bin/python"
if vim.fn.executable(debugpy_path) ~= 1 then
    debugpy_path = "python3"
end

local ok_dap_py, dap_python = pcall(require, "dap-python")
if ok_dap_py and dap_python then
    dap_python.setup(debugpy_path)
    dap_python.test_runner = "pytest"

    -- Ensure dap-python uses the active project venv if present
    dap_python.resolve_python = function()
        if vim.env.VIRTUAL_ENV and vim.fn.executable(vim.env.VIRTUAL_ENV .. "/bin/python") == 1 then
            return vim.env.VIRTUAL_ENV .. "/bin/python"
        end
        local ok_venv, venv_mod = pcall(require, "configs.venv-autodetect")
        if ok_venv then
            local _, py_bin = venv_mod.find_venv(vim.fn.getcwd())
            if py_bin and vim.fn.executable(py_bin) == 1 then
                return py_bin
            end
        end
        return debugpy_path
    end
end
