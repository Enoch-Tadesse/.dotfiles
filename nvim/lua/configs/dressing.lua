local M = {}

M.setup = function()
    require("dressing").setup {
        input = {
            enabled = true,
            default_prompt = "> ",
            border = "rounded", -- Options: "none", "single", "double", "rounded", "solid"
            win_options = {
                winblend = 10, -- Transparency effect
                winhighlight = "NormalFloat:Normal,FloatBorder:FloatBorder",
            },
        },
        select = {
            enabled = true,
            backend = { "telescope", "fzf", "builtin" }, -- Order of preference
            builtin = {
                border = "rounded",
                win_options = {
                    winblend = 10,
                },
            },
        },
    }
end

return M
