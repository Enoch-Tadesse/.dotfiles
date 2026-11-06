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

-- local lspconfig = require "lspconfig"
-- local lspconfig = vim.lsp.config

local capabilities = vim.lsp.protocol.make_client_capabilities()
local ok_cmp_lsp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if ok_cmp_lsp then
    capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
end

local on_attach = function(client, bufnr)
    local opts = { noremap = true, silent = true, buffer = bufnr }
    local keymap = vim.keymap.set
    -- if client.name == "pyright" then
    client.server_capabilities.signatureHelpProvider = false
    -- end
    client.server_capabilities.semanticTokensProvider = nil
    -- Custom keymaps
    keymap("n", "df", vim.lsp.buf.definition, opts)
    keymap("n", "dc", vim.lsp.buf.declaration, opts)
    keymap("n", "im", vim.lsp.buf.implementation, opts)
    keymap("n", "gr", vim.lsp.buf.references, opts)
    keymap("n", "do", function()
        hover_sticky()
    end, opts)
    -- Standard LSP keymaps
    keymap("n", "gd", vim.lsp.buf.definition, opts)
    keymap("n", "gD", vim.lsp.buf.declaration, opts)
    keymap("n", "gi", vim.lsp.buf.implementation, opts)
    keymap("n", "K", function()
        hover_sticky()
    end, opts)
    keymap("n", "<leader>ra", vim.lsp.buf.rename, opts)
    keymap("n", "<leader>ca", vim.lsp.buf.code_action, opts)
    keymap("n", "<leader>sh", vim.lsp.buf.signature_help, opts)
end

-- vim.lsp.enable "jedi_language_server"
vim.lsp.enable "pyright"
vim.lsp.enable "ruff"
vim.lsp.enable "html"
vim.lsp.enable "cssls"
vim.lsp.enable "gopls"
vim.lsp.enable "lua_ls"
vim.lsp.enable "ts_ls"
vim.lsp.enable "clangd"
vim.lsp.enable "rust_analyzer"
vim.lsp.enable "dartls"
-- vim.lsp.enable "phpactor"
vim.lsp.enable "intelephense"

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

vim.lsp.config("pyright", {
    capabilities = capabilities,
    filetypes = { "python" },
    on_attach = on_attach,
    before_init = function(_, config)
        local ok_venv, venv_mod = pcall(require, "configs.venv-autodetect")
        if ok_venv then
            local _, python_bin = venv_mod.find_venv(vim.fn.getcwd())
            if python_bin and vim.fn.executable(python_bin) == 1 then
                config.settings.python.pythonPath = python_bin
                return
            end
        end
        if vim.env.VIRTUAL_ENV and vim.fn.executable(vim.env.VIRTUAL_ENV .. "/bin/python") == 1 then
            config.settings.python.pythonPath = vim.env.VIRTUAL_ENV .. "/bin/python"
        end
    end,
    settings = {
        python = {
            analysis = {
                typeCheckingMode = "basic",
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                diagnosticMode = "workspace",
            },
        },
    },
})

vim.lsp.config("ruff", {
    capabilities = capabilities,
    filetypes = { "python" },
    on_attach = function(client, bufnr)
        -- Disable hover in ruff in favor of Pyright hover
        client.server_capabilities.hoverProvider = false
        on_attach(client, bufnr)
    end,
})

-- HTML
vim.lsp.config("html", {
    capabilities = capabilities,
    filetypes = { "html", "php", "blade" },
    on_attach = on_attach,
})

-- CSS
vim.lsp.config("cssls", {
    capabilities = capabilities,
})

-- Go
vim.lsp.config("gopls", {
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
})

-- Lua
vim.lsp.config("lua_ls", {
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
})

-- vim.lsp.config("ts_ls", {
--     capabilities = capabilities,
--     on_attach = function(client, bufnr)
--         -- Disable ts_ls diagnostics (to avoid duplicates with ESLint)
--         client.handlers["textDocument/publishDiagnostics"] = function() end
--         -- Run your own on_attach if you have one
--         if on_attach then
--             on_attach(client, bufnr)
--         end
--     end,
--     cmd = { "typescript-language-server", "--stdio" },
--     init_options = {
--         preferences = {
--             disableSuggestions = false,
--         },
--     },
--     filetypes = {
--         "javascript",
--         "javascriptreact",
--         "typescript",
--         "typescriptreact",
--     },
--     root_dir = lspconfig.util.root_pattern("package.json", "tsconfig.json", ".git"),
-- })

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
vim.lsp.config("clangd", {
    capabilities = capabilities,
    on_attach = on_attach,
})

vim.lsp.config("rust_analyzer", {
    capabilities = capabilities,
    on_attach = on_attach,
    settings = {
        ["rust-analyzer"] = {
            cargo = { allFeatures = true },
            -- experimental = { enable = true },
            -- check = {
            --     command = "clippy",
            -- },
            diagnostics = {
                disabled = { "unlinked-file" },
            },

            files = {
                watcher = "server",
            },

            standalone = {
                enable = true,
            },
        },
    },
})

vim.lsp.config("dartls", {
    cmd = { "dart", "language-server", "--protocol=lsp" },
    filetypes = { "dart" },
    root_markers = { { "pubspec.yaml", ".git" } },
    capabilities = capabilities,
    on_attach = on_attach,
    settings = {
        dart = {
            completeFunctionCalls = true,
            showTodos = true,
            enableSnippets = true,
            updateImportsOnRename = true,
        },
    },
    init_options = {
        onlyAnalyzeProjectsWithOpenFiles = false,
        suggestFromUnimportedLibraries = true,
        closingLabels = true,
        outline = true,
        flutterOutline = true,
    },
})

vim.lsp.config("jedi_language_server", {
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
        python = {},
    },
})

local lspconfig = require "lspconfig"
vim.lsp.config("phpactor", {
    capabilities = capabilities,
    cmd = { "phpactor", "language-server" }, -- Command to start phpactor
    root_markers = { { ".git", "composer.json" } }, -- Define root for PHP projects
    settings = {
        phpactor = {
            -- You can add any PHPactor-specific settings here.
            enable_snippets = true,
            php_bin = "/usr/bin/php", -- Path to your PHP binary, if required.
        },
    },
})

-- vim.lsp.config("intelephense", {
--     capabilities = capabilities,
--     on_attach = on_attach,
--     settings = {
--         intelephense = {
--             files = {
--                 maxSize = 5000000, -- 5 MB for indexing
--             },
--             stubs = {
--                 "apache",
--                 "bcmath",
--                 "bz2",
--                 "calendar",
--                 "core",
--                 "ctype",
--                 "curl",
--                 "date",
--                 "dba",
--                 "dom",
--                 "enchant",
--                 "exif",
--                 "fileinfo",
--                 "filter",
--                 "ftp",
--                 "gd",
--                 "gettext",
--                 "hash",
--                 "iconv",
--                 "imap",
--                 "intl",
--                 "json",
--                 "ldap",
--                 "libxml",
--                 "mbstring",
--                 "mysqli",
--                 "mysql",
--                 "odbc",
--                 "openssl",
--                 "pcntl",
--                 "pcre",
--                 "PDO",
--                 "pgsql",
--                 "phar",
--                 "posix",
--                 "pspell",
--                 "readline",
--                 "recode",
--                 "reflection",
--                 "session",
--                 "shmop",
--                 "SimpleXML",
--                 "soap",
--                 "sockets",
--                 "sodium",
--                 "spl",
--                 "standard",
--                 "superglobals",
--                 "sysvmsg",
--                 "sysvsem",
--                 "sysvshm",
--                 "tidy",
--                 "tokenizer",
--                 "xml",
--                 "xmlreader",
--                 "xmlwriter",
--                 "xsl",
--                 "zip",
--                 "zlib",
--             },
--             environment = {
--                 includePaths = { "/usr/include/php/20230831/" }, -- adjust for your PHP version
--             },
--             completion = {
--                 fullyQualifyGlobalSymbols = true,
--             },
--         },
--     },
-- })
