local neotest = require "neotest"

neotest.setup {
    adapters = {
        require "neotest-python" {
            dap = { justMyCode = false },
            runner = "pytest",
            python = function()
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
                return vim.fn.exepath "python3" or "python"
            end,
            pytest_discover_instances = true,
        },
    },
    status = { virtual_text = true },
    output = { open_on_run = true },
    quickfix = {
        open = function()
            vim.cmd "copen"
        end,
    },
}
