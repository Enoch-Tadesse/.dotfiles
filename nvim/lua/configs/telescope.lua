local telescope = require "telescope"
local actions = require "telescope.actions"

telescope.setup {
    defaults = {
        mappings = {
            i = {
                ["<C-n>"] = actions.move_selection_next,
                ["<C-p>"] = actions.move_selection_previous,
                ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
            },
        },
        file_ignore_patterns = { ".git/" }, -- ".cache", "%.o", "%.a", "%.out", "%.class", "%.pdf", "%.mkv", "%.mp4", "%.zip"
    },
    pickers = {
        find_files = { hidden = true },
    },
    extensions = {},
}

return telescope
