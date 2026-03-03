return {
    cn = { -- leetcode.cn
        enabled = false, ---@type boolean
        translator = true, ---@type boolean
        translate_problems = true, ---@type boolean
    },
    lang = "rust",
    ui = {
        theme = "dark",
        layout = "split", -- or "float_right"
    },
    editor = {
        reset_previous_code = false,
    },
    storage = {
        home = vim.fn.expand "~/Documents/leetcode",
    },
    image_support = true,
    description = {
        position = "left",
        width = "40%",
        show_stats = false,
    },
    hooks = { -- avoids problem with which key and leader when entering a question
        ["question_enter"] = {
            function()
                vim.cmd "startinsert"
                vim.cmd "stopinsert"
            end,
        },
    },
}
