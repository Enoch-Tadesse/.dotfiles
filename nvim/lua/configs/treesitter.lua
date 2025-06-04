require("nvim-treesitter.configs").setup {
    ensure_installed = {
        -- "bash",
        "c",
        -- "cmake",
        "cpp",
        "make",
        -- -- "fish",
        -- "asm",
        "python",
        "go",
        "javascript",
        "typescript",
        "tsx",
        "json",
        "java",
        "html",
        "css",
        "lua",
        -- "luadoc",
        "markdown",
        "markdown_inline",
        -- "printf",
        -- "toml",
        "vim",
        -- "vimdoc",
        -- "yaml",
    },

    -- Install parsers synchronously (only applied to `ensure_installed`)
    sync_install = true,

    -- Automatically install missing parsers when entering buffer
    auto_install = false,

    -- List of parsers to ignore installing (or "all")
    ignore_install = {},

    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
        -- list of language that will be disabled
        disable = { "c" },
        -- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
    },
    rainbow = {
        enable = true, -- Enable rainbow parentheses
        extended_mode = true, -- Highlight all parentheses, even in multiline expressions
        max_file_lines = nil, -- No limit on file size
    },

    indent = {
        enable = false, -- Enable Treesitter-based indentation
    },

    -- You can also enable autotag for HTML-like files
    autotag = {
        enable = true, -- Enables automatic tag closing in HTML, XML, etc.
    },
}
