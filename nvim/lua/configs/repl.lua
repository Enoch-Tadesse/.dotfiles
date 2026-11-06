local iron = require "iron.core"
local view = require "iron.view"

iron.setup {
    config = {
        scratch_repl = true,
        repl_definition = {
            python = {
                command = function()
                    if vim.env.VIRTUAL_ENV and vim.fn.executable(vim.env.VIRTUAL_ENV .. "/bin/ipython") == 1 then
                        return { vim.env.VIRTUAL_ENV .. "/bin/ipython", "--no-autoindent" }
                    elseif vim.env.VIRTUAL_ENV and vim.fn.executable(vim.env.VIRTUAL_ENV .. "/bin/python") == 1 then
                        return { vim.env.VIRTUAL_ENV .. "/bin/python" }
                    elseif vim.fn.executable "ipython" == 1 then
                        return { "ipython", "--no-autoindent" }
                    else
                        return { "python3" }
                    end
                end,
                format = require("iron.fts.common").bracketed_paste_python,
            },
        },
        repl_open_cmd = view.split.vertical.botright(0.42),
    },
    keymaps = {
        send_motion = "<leader>rm",
        visual_send = "<leader>rs",
        send_file = "<leader>rf",
        send_line = "<leader>rl",
        send_paragraph = "<leader>rp",
        cr = "<leader>r<cr>",
        interrupt = "<leader>r<space>",
        exit = "<leader>rq",
        clear = "<leader>rc",
    },
    highlight = {
        italic = true,
    },
    ignore_blank_lines = true,
}
