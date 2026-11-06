local M = {}

local cache_file = vim.fn.stdpath "data" .. "/venv_cache.json"

local function read_cache()
    if vim.fn.filereadable(cache_file) == 1 then
        local content = vim.fn.readfile(cache_file)
        if #content > 0 then
            local ok, parsed = pcall(vim.json.decode, table.concat(content, "\n"))
            if ok and type(parsed) == "table" then
                return parsed
            end
        end
    end
    return {}
end

local function write_cache(cache)
    local ok, encoded = pcall(vim.json.encode, cache)
    if ok then
        vim.fn.writefile({ encoded }, cache_file)
    end
end

-- Common venv folder names to check in order of priority
local venv_names = { ".venv", "venv", "env", ".env" }

--- Find a virtualenv path for the given directory or its parents
--- @param start_dir string
--- @return string|nil venv_path
--- @return string|nil python_bin
function M.find_venv(start_dir)
    if not start_dir or start_dir == "" then
        start_dir = vim.fn.getcwd()
    end

    -- 1. Check cache first
    local cache = read_cache()
    if cache[start_dir] then
        local cached_venv = cache[start_dir]
        local cached_bin = cached_venv .. "/bin/python"
        if vim.fn.executable(cached_bin) == 1 then
            return cached_venv, cached_bin
        else
            cache[start_dir] = nil
            write_cache(cache)
        end
    end

    -- 2. Traverse up from start_dir to find local venv folders
    local current = vim.fn.fnamemodify(start_dir, ":p"):gsub("/+$", "")
    local root = ""
    while current and current ~= root and current ~= "/" do
        for _, name in ipairs(venv_names) do
            local candidate = current .. "/" .. name
            local bin = candidate .. "/bin/python"
            if vim.fn.executable(bin) == 1 then
                return candidate, bin
            end
        end

        -- Check Poetry if pyproject.toml exists and poetry is available
        local pyproject = current .. "/pyproject.toml"
        if vim.fn.filereadable(pyproject) == 1 and vim.fn.executable("poetry") == 1 then
            local handle = io.popen("cd " .. vim.fn.shellescape(current) .. " && poetry env info -p 2>/dev/null")
            if handle then
                local poetry_path = handle:read("*a"):gsub("%s+$", "")
                handle:close()
                if poetry_path ~= "" and vim.fn.executable(poetry_path .. "/bin/python") == 1 then
                    return poetry_path, poetry_path .. "/bin/python"
                end
            end
        end

        -- Stop at git root boundary if not found yet, but still check cwd
        if vim.fn.isdirectory(current .. "/.git") == 1 then
            break
        end

        local parent = vim.fn.fnamemodify(current, ":h")
        if parent == current then
            break
        end
        current = parent
    end

    -- 3. Check Conda / active VIRTUAL_ENV if pointing to a valid python
    if vim.env.CONDA_PREFIX and vim.fn.executable(vim.env.CONDA_PREFIX .. "/bin/python") == 1 then
        return vim.env.CONDA_PREFIX, vim.env.CONDA_PREFIX .. "/bin/python"
    end

    return nil, nil
end

--- Activate the specified virtualenv
--- @param venv_path string
--- @param notify boolean|nil
function M.activate(venv_path, notify)
    if not venv_path or venv_path == "" then
        return false
    end

    venv_path = vim.fs.normalize(venv_path)
    local python_bin = venv_path .. "/bin/python"
    if vim.fn.executable(python_bin) ~= 1 then
        if notify then
            vim.notify("Python binary not found at: " .. python_bin, vim.log.levels.WARN, { title = "Venv AutoDetect" })
        end
        return false
    end

    -- Set environment variables for child processes (terminals, runners)
    vim.env.VIRTUAL_ENV = venv_path

    -- Prepend to PATH so terminal and child jobs run the venv's python
    local old_path = vim.env.PATH or ""
    local venv_bin = venv_path .. "/bin"
    -- Remove any existing venv path from PATH to avoid stale stacking
    local path_entries = vim.split(old_path, ":")
    local filtered_entries = {}
    for _, entry in ipairs(path_entries) do
        if not entry:match "/venv/bin$" and not entry:match "/%.venv/bin$" and not entry:match "/env/bin$" then
            table.insert(filtered_entries, entry)
        end
    end
    vim.env.PATH = venv_bin .. ":" .. table.concat(filtered_entries, ":")

    -- Update active Python LSPs (pyright, basedpyright)
    for _, client in ipairs(vim.lsp.get_clients()) do
        if client.name == "pyright" or client.name == "basedpyright" then
            client.config.settings = client.config.settings or {}
            client.config.settings.python = client.config.settings.python or {}
            client.config.settings.python.pythonPath = python_bin
            client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
        end
    end

    -- Update DAP Python if available
    local ok_dap, dap_python = pcall(require, "dap-python")
    if ok_dap and dap_python then
        pcall(function()
            dap_python.resolve_python = function()
                return python_bin
            end
        end)
    end

    -- Save to project cache
    local cwd = vim.fn.getcwd()
    local cache = read_cache()
    cache[cwd] = venv_path
    write_cache(cache)

    -- Trigger User autocommand for UI updates (lualine, etc.)
    vim.api.nvim_exec_autocmds("User", { pattern = "VenvActivated", data = { venv = venv_path, python = python_bin } })

    if notify then
        local venv_display = vim.fn.fnamemodify(venv_path, ":t")
        local py_ver = ""
        local handle = io.popen(vim.fn.shellescape(python_bin) .. " --version 2>&1")
        if handle then
            py_ver = " (" .. handle:read("*a"):gsub("%s+$", "") .. ")"
            handle:close()
        end
        vim.notify(
            "Activated virtualenv: " .. venv_display .. py_ver,
            vim.log.levels.INFO,
            { title = "Python Environment" }
        )
    end

    return true
end

--- Auto-detect and activate for current directory or buffer
--- @param notify boolean|nil
function M.autodetect(notify)
    local dir = vim.fn.expand "%:p:h"
    if not dir or dir == "" or dir:match "^term:" then
        dir = vim.fn.getcwd()
    end

    local venv_path, _ = M.find_venv(dir)
    if venv_path then
        if vim.env.VIRTUAL_ENV ~= venv_path then
            return M.activate(venv_path, notify)
        end
        return true
    end

    if notify then
        vim.notify("No virtualenv detected in " .. dir, vim.log.levels.INFO, { title = "Python Environment" })
    end
    return false
end

--- Get a formatted string of the active virtualenv for statusline / info
function M.get_venv_info()
    local venv = vim.env.VIRTUAL_ENV
    if not venv or venv == "" then
        return nil
    end

    local name = vim.fn.fnamemodify(venv, ":t")
    -- If name is generic like .venv or venv, show parent project name too
    if name == ".venv" or name == "venv" or name == "env" or name == ".env" then
        local parent = vim.fn.fnamemodify(venv, ":h:t")
        name = parent .. " (" .. name .. ")"
    end
    return name
end

--- Display comprehensive details about the current Python environment
function M.show_info()
    local venv = vim.env.VIRTUAL_ENV or "None"
    local python_bin = venv ~= "None" and (venv .. "/bin/python") or vim.fn.exepath "python3"
    local version = "Unknown"
    if vim.fn.executable(python_bin) == 1 then
        local handle = io.popen(vim.fn.shellescape(python_bin) .. " --version 2>&1")
        if handle then
            version = handle:read("*a"):gsub("%s+$", "")
            handle:close()
        end
    end

    local lsp_clients = {}
    for _, client in ipairs(vim.lsp.get_clients()) do
        if client.name == "pyright" or client.name == "basedpyright" or client.name == "ruff" then
            table.insert(lsp_clients, client.name .. " (id: " .. client.id .. ")")
        end
    end

    local lines = {
        "Python Environment Details:",
        "--------------------------------------",
        "  Virtualenv: " .. venv,
        "  Interpreter: " .. python_bin,
        "  Version: " .. version,
        "  LSP Clients: " .. (#lsp_clients > 0 and table.concat(lsp_clients, ", ") or "None active"),
        "  Neovim Provider: " .. (vim.g.python3_host_prog or "System default"),
        "--------------------------------------",
    }
    vim.notify(table.concat(lines, "\n"), vim.log.levels.INFO, { title = "Python Environment" })
end

--- Setup autocommands to automatically detect venvs on entering python files or changing directories
function M.setup()
    local group = vim.api.nvim_create_augroup("VenvAutoDetectGroup", { clear = true })

    vim.api.nvim_create_autocmd({ "VimEnter", "BufEnter" }, {
        group = group,
        pattern = { "*.py", "*.ipynb", "*.md" },
        callback = function()
            -- Only autodetect if buffer has a real file
            local bufname = vim.api.nvim_buf_get_name(0)
            if bufname ~= "" and not bufname:match "^%a+://" then
                M.autodetect(false)
            end
        end,
    })

    vim.api.nvim_create_autocmd("DirChanged", {
        group = group,
        callback = function()
            M.autodetect(true)
        end,
    })

    vim.api.nvim_create_user_command("VenvAutoDetect", function()
        M.autodetect(true)
    end, { desc = "Auto-detect and activate virtual environment for current project" })

    vim.api.nvim_create_user_command("VenvInfo", function()
        M.show_info()
    end, { desc = "Show current Python environment details" })
end

return M
