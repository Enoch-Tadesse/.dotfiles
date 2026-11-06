local options = {
    formatters_by_ft = {
        lua = { "stylua" },
        python = { "ruff_organize_imports", "ruff_format" },
        c = { "clang-format" },
        cpp = { "clang-format" },
		javascript = { "prettier", "eslint_d" },
        javascriptreact = { "prettier", "eslint_d" },
        typescript = { "prettier", "eslint_d" },
        typescriptreact = { "prettier", "eslint_d" },
		php = {"php-cs-fixer", "phpcbf"},
		blade = {"blade-formatter"},
        css = { "prettier" },
        html = { "prettier" },
		rust = { "rustfmt" },
        json = { "prettier" },
        jsx = { "prettier" },
        markdown = { "prettier" },
        dart = { "dart_format" },
    },
    formatters = {
        -- cpp
        ["clang-format"] = {
            prepend_args = {
                "-style={ \
                BasedOnStyle: google, \
                IndentWidth: 4, \
                TabWidth: 4, \
                UseTab: Never, \
                AccessModifierOffset: 0, \
                IndentAccessModifiers: true, \
                PackConstructorInitializers: Never}",
            },
        },
        -- javascript
        ["prettier"] = {
            prepend_args = {
                "--tab-width",
                "2",
                "--use-tabs",
                "false",
                "--single-quote",
                "true",
                "--trailing-comma",
                "all",
            },
        },
        -- Python
        black = {
            prepend_args = {
                "--fast",
                "--line-length",
                "88",
            },
        },
    },
    format_on_save = {
        timeout_ms = 1500,
        lsp_format = "fallback",
    },
}

return options
