-- mason-lspconfig.lua

-- Define a list of servers you want to use
local servers = {
    "gopls",
    "pyright",
    "lua_ls",
    "html",
    "cssls",
    "biome",
    "ts_ls",
    "tailwindcss",
    "rust_analyzer",
    -- "eslint",
    "clangd",
    -- "jdtls",
}

require("mason-lspconfig").setup {
    ensure_installed = servers,
    automatic_installation = true,
    automatic_enable = false,
}

-- List of servers to ignore during install (if needed)
local ignore_install = {}

-- Helper to check if a value is in a table

-- local function table_contains(tbl, val)
--     for _, v in ipairs(tbl) do
--         if v == val then
--             return true
--         end
--     end
--     return false
-- end
--
-- -- Filter the list based on ignore list
-- local all_servers = {}
-- for _, s in ipairs(servers) do
--     if not table_contains(ignore_install, s) then
-- table.insert(all_servers, s)
--     end
-- end
--
-- require("mason-lspconfig").setup {
--     ensure_installed = all_servers,
-- }
