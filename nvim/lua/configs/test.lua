
--[[
  Custom LSP hover function that opens a floating window
  showing documentation which stays open until you move cursor
  or close it manually (with 'q').
  
  - Uses focusable = false (popup doesn’t accept input focus)
  - Closes on CursorMoved, BufHidden, InsertCharPre, or WinScrolled events
  - Maps 'q' inside popup buffer to close window quickly

  To interact with the popup (e.g., scroll or copy), consider
  setting focusable = true and use <C-w>w to focus the window.
  to unfocus use <C-w>p
]]
local function hover_sticky()
    local params = vim.lsp.util.make_position_params()
    vim.lsp.buf_request(0, "textDocument/hover", params, function(err, result, ctx, config)
        if err then
            return
        end
        if not (result and result.contents) then
            print "No hover information available"
            return
        end
        local markdown_lines = vim.lsp.util.convert_input_to_markdown_lines(result.contents)
        markdown_lines = vim.lsp.util.trim_empty_lines(markdown_lines)
        if vim.tbl_isempty(markdown_lines) then
            print "No hover content"
            return
        end
        local bufnr, winid = vim.lsp.util.open_floating_preview(markdown_lines, "markdown", {
            border = "rounded",
            focusable = true,
            close_events = { "CursorMoved", "BufHidden", "InsertCharPre", "WinScrolled" },
        })
        vim.api.nvim_buf_set_keymap(bufnr, "n", "q", "<cmd>close<CR>", { silent = true, noremap = true })
    end)
end

local lspconfig = require "lspconfig"
-- local lspconfig = vim.lsp.config

local capabilities = vim.lsp.protocol.make_client_capabilities()
-- local capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

local on_attach = function(client, bufnr)
    local opts = { noremap = true, silent = true, buffer = bufnr }
    local keymap = vim.keymap.set
    -- if client.name == "pyright" then
    client.server_capabilities.signatureHelpProvider = false
    -- end
    client.server_capabilities.semanticTokensProvider = nil
    keymap("n", "df", vim.lsp.buf.definition, opts)
    keymap("n", "dc", vim.lsp.buf.declaration, opts)
    keymap("n", "im", vim.lsp.buf.implementation, opts)
    keymap("n", "gr", vim.lsp.buf.references, opts)
    -- keymap("n", "do", vim.lsp.buf.hover, opts)
    keymap("n", "do", function()
        hover_sticky()
    end, opts)
end

-- Set up each language server
-- lspconfig.biome.setup {
--     cmd = { "biome", "lsp-proxy" },
--     filetypes = {
--         "javascript",
--         "typescript",
--         "javascriptreact",
--         "typescriptreact",
--         "json",
--         "jsonc",
--         "css",
--         "graphql",
--         "svelte",
--         "vue",
--         "astro",
--     },
--     root_dir = require("lspconfig.util").root_pattern(
--         "biome.json",
--         ".biome.json",
--         "biome.config.js",
--         "package.json",
--         ".git"
--     ),
--     on_attach = on_attach,
-- }

-- require("lspconfig").jdtls.setup {
--     on_attach = on_attach,
--     capabilities = capabilities,
--     ft = { "java" },
-- }

-- tailwind
-- lspconfig.tailwindcss.setup {
--     filetypes = {
--         "html",
--         "css",
--         "scss",
--         "javascript",
--         "javascriptreact",
--         "typescript",
--         "typescriptreact",
--         "svelte",
--         "vue",
--     },
--     init_options = {
--         userLanguages = {
--             eelixir = "html-eex",
--             eruby = "erb",
--             heex = "phoenix-heex",
--         },
--     },
--     settings = {
--         tailwindCSS = {
--             experimental = {
--                 classRegex = {
--                     -- for classnames inside arbitrary formats like `cn("bg-red-500")`
--                     { "cn\\(([^)]*)\\)", "[\"'`]([^\"'`]*).*?[\"'`]" },
--                 },
--             },
--         },
--     },
-- }

-- local jdkPath = "/usr/lib/jvm/jdk-24.0.1/"
-- require("lspconfig").jdtls.setup {
-- settings = {
--     java = {
--         configuration = {
--             runtimes = {
--                 {
--                     name = "JavaSE-24",
--                     path = jdkPath,
--                     -- default = true,
--                 },
--             },
--         },
--     },
-- },
-- filetypes = { "java" },
-- ft = { "java" },
-- }

lspconfig.pyright.setup {
    capabilities = capabilities,
    filetypes = { "python" },
    on_attach = on_attach,
    settings = {
        python = {
            -- make sure to source the activate in bashrc
            -- pythonPath = "/home/henok/Desktop/Neuro-Symbolic-AI/yon/bin/activate",
            pythonPath = "/home/henok/global/bin/python",
            analysis = {
                typeCheckingMode = "off", -- or "off" for even less strictness
                diagnosticSeverityOverrides = {
                    reportIncompatibleMethodOverride = "none", -- <== THIS silences the override warnings
                },
            },
        },
    },
}

-- HTML
lspconfig.html.setup {
    capabilities = capabilities,
}

-- CSS
lspconfig.cssls.setup {
    capabilities = capabilities,
}

-- Go
lspconfig.gopls.setup {
    cmd = { "gopls", "-vv", "serve" },
    capabilities = capabilities,
    -- on_attach = on_attach,
    on_attach = function(client, bufnr)
        local opts = { noremap = true, silent = true, buffer = bufnr }
        local keymap = vim.keymap.set
        -- if client.name == "pyright" then
        --     client.server_capabilities.signatureHelpProvider = false
        -- end
        client.server_capabilities.semanticTokensProvider = nil
        keymap("n", "df", vim.lsp.buf.definition, opts)
        keymap("n", "dc", vim.lsp.buf.declaration, opts)
        keymap("n", "im", vim.lsp.buf.implementation, opts)
        keymap("n", "gr", vim.lsp.buf.references, opts)
        -- keymap("n", "do", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "do", hover_sticky, { noremap = true, silent = true, buffer = bufnr })
    end,

    settings = {
        gopls = {
            analyses = { unusedparams = true },
            staticcheck = true,
            completeUnimported = true,
            usePlaceholders = true,
            hints = {
                assignVariableTypes = true,
                compositeLiteralFields = true,
                constantValues = true,
                functionTypeParameters = true,
                parameterNames = true,
            },
        },
    },
}

-- Lua
lspconfig.lua_ls.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
        Lua = {
            diagnostics = {
                -- globals = { "vim" },
            },
            workspace = {
                library = {
                    vim.fn.expand "$VIMRUNTIME/lua",
                    vim.fn.expand "$VIMRUNTIME/lua/vim/lsp",
                    vim.fn.stdpath "data" .. "/lazy/ui/nvchad_types",
                    vim.fn.stdpath "data" .. "/lazy/lazy.nvim/lua/lazy",
                    "${3rd}/love2d/library",
                },
                maxPreload = 100000,
                preloadFileSize = 10000,
            },
        },
    },
}

lspconfig.ts_ls.setup {
    capabilities = capabilities,
    on_attach = function(client, bufnr)
        -- Disable ts_ls diagnostics (to avoid duplicates with ESLint)
        client.handlers["textDocument/publishDiagnostics"] = function() end
        -- Run your own on_attach if you have one
        if on_attach then
            on_attach(client, bufnr)
        end
    end,
    cmd = { "typescript-language-server", "--stdio" },
    init_options = {
        preferences = {
            disableSuggestions = false,
        },
    },
    filetypes = {
        "javascript",
        "javascriptreact",
        "typescript",
        "typescriptreact",
    },
    root_dir = lspconfig.util.root_pattern("package.json", "tsconfig.json", ".git"),
}

-- TypeScript / JavaScript
-- lspconfig.ts_ls.setup({
--     cmd = { "typescript-language-server", "--stdio" },
--     filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
--     root_dir = lspconfig.util.root_pattern("package.json", "tsconfig.json", "jsconfig.json", ".git"),
--     capabilities = capabilities,
--     on_attach = on_attach,
-- })

-- ESLint
-- lspconfig.eslint.setup {
--   on_attach = function(client, bufnr)
--     -- Optional: Auto-fix on save
--     -- vim.api.nvim_create_autocmd("BufWritePre", {
--     --   buffer = bufnr,
--     --   command = "EslintFixAll", -- needs `eslint.nvim` plugin for this to work
--     -- })
--   end,
--   settings = {
--     format = { enable = true }, -- allow eslint to format
--   }
-- }

-- Clangd
lspconfig.clangd.setup {
    capabilities = capabilities,
    on_attach = on_attach,
}

lspconfig.rust_analyzer.setup {
    capabilities = capabilities,
    on_attach = on_attach,
    settings = {
        ["rust-analyzer"] = {
            cargo = { allFeatures = true },
            experimental = { enable = true },
            -- check = {
            --     command = "clippy",
            -- },
        },
    },
}

lspconfig.dartls.setup {
    cmd = { "dart", "language-server", "--protocol=lsp" },
    filetypes = { "dart" },
    root_dir = function()
        return "/home/henok/dev/mobile/"
    end,
    capabilities = capabilities,
    on_attach = on_attach,
}
