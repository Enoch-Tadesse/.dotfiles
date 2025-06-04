require("noice").setup {
    cmdline = {
        enabled = true,
        view = "cmdline_popup", -- Options: cmdline, cmdline_popup, popup
        format = {
            cmdline = { pattern = "^:", icon = "", lang = "vim" },
            search_down = { kind = "search", pattern = "^/", icon = " ", lang = "regex" },
            search_up = { kind = "search", pattern = "^%?", icon = " ", lang = "regex" },
            filter = { pattern = "^:%s*!", icon = "$", lang = "bash" },
            lua = { pattern = "^:%s*lua%s+", icon = "", lang = "lua" },
            help = { pattern = "^:%s*he?l?p?%s+", icon = "" },
        },
    },
    --------------uncomment to disable popups -----------------
    messages = { enabled = true },
    notify = { enabled = false },
    lsp = {
        progress = { enabled = true },
        signature = { enabled = false },
        hover = { enabled = true },
        message = { enabled = false },
    },
    --------------uncomment to disable popups -----------------
    presets = {
        bottom_search = false, -- replaces bottom cmdline
        command_palette = true, -- shows command palette
    },
    views = {
        mini = {
            timeout = 2000, -- in milliseconds (e.g., 2000ms = 2 seconds)
        },
        popup = {
            timeout = 3000, -- optional: if you're using popup views
        },
    },
}

-- CMP setup for cmdline completion
local cmp = require "cmp"
cmp.setup.cmdline(":", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        { name = "cmdline" },
    },
})
cmp.setup.cmdline("/", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        { name = "buffer" },
    },
})
