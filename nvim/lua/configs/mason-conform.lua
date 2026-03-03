-- mason-conform.nvim setup
require("mason-conform").setup {
    ensure_installed = {
		"rustfmt",
        "stylua", -- Lua formatter
        "black", -- Python formatter
		"eslint_d",
        "clang-format", -- C/C++ formatter
        "prettier", -- JS/TS/HTML formatter
        "gopls", -- Go language server (if you need LSP formatting)
    },
    automatic_installation = true, -- Automatically install missing tools
}
