local lspconfig = require "lspconfig"

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
    keymap("n", "do", vim.lsp.buf.hover, opts)
end

-- Set up each language server
lspconfig.biome.setup {
    cmd = { "biome", "lsp-proxy" },
    filetypes = {
        "javascript",
        "typescript",
        "javascriptreact",
        "typescriptreact",
        "json",
        "jsonc",
        "css",
        "graphql",
        "svelte",
        "vue",
        "astro",
    },
    root_dir = require("lspconfig.util").root_pattern("biome.json", ".biome.json", "package.json", ".git"),
}

require("lspconfig").jdtls.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    ft = { "java" },
}

-- tailwind
lspconfig.tailwindcss.setup {
    filetypes = {
        "html",
        "css",
        "scss",
        "javascript",
        "javascriptreact",
        "typescript",
        "typescriptreact",
        "svelte",
        "vue",
    },
    init_options = {
        userLanguages = {
            eelixir = "html-eex",
            eruby = "erb",
            heex = "phoenix-heex",
        },
    },
    settings = {
        tailwindCSS = {
            experimental = {
                classRegex = {
                    -- for classnames inside arbitrary formats like `cn("bg-red-500")`
                    { "cn\\(([^)]*)\\)", "[\"'`]([^\"'`]*).*?[\"'`]" },
                },
            },
        },
    },
}

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
            analysis = {
                typeCheckingMode = "basic", -- or "off" for even less strictness
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
        keymap("n", "do", vim.lsp.buf.hover, opts)
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
--     capabilities = capabilities,
--     on_attach = on_attach,
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
