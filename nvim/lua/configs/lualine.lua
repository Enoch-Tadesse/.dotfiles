local function python_venv()
    local ok, venv_mod = pcall(require, "configs.venv-autodetect")
    if ok and venv_mod then
        local venv_name = venv_mod.get_venv_info()
        if venv_name then
            return "󰌠 " .. venv_name
        end
    end
    if vim.env.VIRTUAL_ENV then
        return "󰌠 " .. vim.fn.fnamemodify(vim.env.VIRTUAL_ENV, ":t")
    end
    return ""
end

local function lsp_status()
    local clients = vim.lsp.get_clients { bufnr = 0 }
    if #clients == 0 then
        return ""
    end
    local names = {}
    for _, client in ipairs(clients) do
        if client.name ~= "null-ls" and client.name ~= "copilot" then
            table.insert(names, client.name)
        end
    end
    return " " .. table.concat(names, ",")
end

local function dap_status()
    local ok, dap = pcall(require, "dap")
    if ok and dap.status() ~= "" then
        return " " .. dap.status()
    end
    return ""
end

require("lualine").setup {
    options = {
        theme = "auto",
        component_separators = { left = "│", right = "│" },
        section_separators = { left = "", right = "" },
        globalstatus = true,
        disabled_filetypes = {
            statusline = { "NvimTree", "alpha" },
        },
    },
    sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff" },
        lualine_c = {
            {
                "filename",
                file_status = true,
                path = 1,
            },
            {
                "diagnostics",
                sources = { "nvim_diagnostic" },
                symbols = { error = " ", warn = " ", info = " ", hint = "󰌵 " },
            },
        },
        lualine_x = {
            {
                dap_status,
                color = { fg = "#e06c75" },
            },
            {
                python_venv,
                color = { fg = "#98c379", gui = "bold" },
            },
            {
                lsp_status,
                color = { fg = "#61afef" },
            },
            "filetype",
        },
        lualine_y = { "progress" },
        lualine_z = { "location" },
    },
    extensions = { "nvim-tree", "fugitive", "quickfix" },
}
