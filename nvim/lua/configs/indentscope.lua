local indentscope = require "mini.indentscope"
local options = {
    symbol = "│",
    options = { border = "both", try_as_border = true, n_lines = 10000, indent_at_cursor = true },
    draw = {
        delay = 50,
        -- animation = require("mini.indentscope").gen_animation.none(),

        -- animation = indentscope.gen_animation.cubic({ easing = "in-out", duration = 250, unit = "step" }),
        animation = indentscope.gen_animation.cubic { easing = "in-out", duration = 150, unit = "total" },
    },
}

require("mini.indentscope").setup(options)

-- Disable for specific filetypes
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "help", "dashboard", "NvimTree", "lazy" },
    callback = function()
        vim.b.miniindentscope_disable = true
    end,
})

vim.cmd [[ highlight MiniIndentscopeSymbol guifg=#a5e33b gui=nocombine ]]
