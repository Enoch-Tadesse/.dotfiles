require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("x", ">", ">gv", { noremap = true, silent = true, desc = "Indent right" }) -- keep visual selection after indenting
map("x", "<", "<gv", { noremap = true, silent = true, desc = "Indent left" }) -- keep visual selection after indenting
map("n", ";", ":", { desc = "CMD enter command mode" })
map("n", "j" , "gj", { desc = "Move down by visual line" })
map("n", "k" , "gk", { desc = "Move up by visual line" })
map("n", "<C-p>", "<CMD>put +<CR>", { noremap = true, silent = true, desc = "Paste from clipboard" })
map("i", "jk", "<ESC>")
map("i", "<A-l>", "<ESC>ll", {noremap = true, silent = true, desc = "Move to the end of the line in insert mode"})

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")

-------------------------Copilot_________________________
map("i", "<C-Space>", function()
  require("copilot.suggestion").accept()
end, { noremap = true, silent = true })
-------------------------Copilor_________________________

----------------------Terminal-----------------------
map({ "n", "t" }, "<A-i>", function()
    require("nvchad.term").toggle {
        pos = "float",
        id = "floatTerm",
        float_opts = {
            row = 0.05,
            col = 0.08,
            width = 0.8,
            height = 0.8,
        },
    }
end, { desc = "terminal toggle floating term" })
-----------------------Terminal-----------------------

--------------------------QuickFix --------------------------
map("n", "<leader>qf", function()
    vim.diagnostic.setqflist()
    vim.cmd "copen"
end, { desc = "Populate and open quickfix list" })
map("n", "cn", ":cnext<CR>", { silent = true, desc = "Next quickfix item" })
map("n", "cp", ":cprev<CR>", { silent = true, desc = "Previous quickfix item" })

--------------------------QuickFix --------------------------

--------------------------Fugitive --------------------------
map("n", "<leader>gs", ":Git<CR>", { noremap = true, silent = true, desc = "git status" })
map("n", "<leader>ga", ":Gwrite<CR>", { noremap = true, silent = true, desc = "Git add current file" })
map("n", "<leader>gc", ":Git commit<CR>", { noremap = true, silent = true, desc = "Git commit" })
map("n", "<leader>gp", ":Git push<CR>", { noremap = true, silent = true, desc = "Git push" })
map("n", "<leader>gP", ":Git pull<CR>", { noremap = true, silent = true, desc = "Git pull" })
map("n", "<leader>gd", ":Gdiffsplit<CR>", { noremap = true, silent = true, desc = "Git diff split" })
map("n", "<leader>gv", ":Gvdiffsplit<CR>", { noremap = true, silent = true, desc = "Git diff split" })
map("n", "<leader>gb", ":Git blame<CR>", { noremap = true, silent = true, desc = "Git blame" })
map("n", "<leader>gl", ":Git log<CR>", { noremap = true, silent = true, desc = "Git log" })
map("n", "<leader>gco", ":Git checkout ", { noremap = true, silent = false, desc = "Git checkout branch" })
map("n", "<leader>gr", ":Gread<CR>", { noremap = true, silent = true, desc = "Git restore file (Gread)" })
--------------------------Fugitive --------------------------

--------------------------Gitsigns --------------------------
map("n", "<leader>ts", ":Gitsigns stage_hunk<CR>")
map("n", "<leader>tr", ":Gitsigns reset_hunk<CR>")

map("n", "<leader>tS", ":Gitsigns stage_buffer<CR>")
map("n", "<leader>tR", ":Gitsigns reset_buffer<CR>")
map("n", "<leader>tp", ":Gitsigns preview_hunk<CR>")
map("n", "<leader>ti", ":Gitsigns preview_hunk_inline<CR>")

map("n", "<leader>td", ":Gitsigns diffthis<CR>")

map("n", "<leader>tq", ":Gitsigns setqflist<CR>")

-- Toggles
map("n", "<leader>tb", ":Gitsigns toggle_current_line_blame<CR>")
map("n", "<leader>tw", ":Gitsigns toggle_word_diff<CR>")
-------------------------Gitsigns ------------------------------

-------------------------nvim-tree -----------------------------
-- map("n", "<leader>e", ":NvimTreeOpen<CR>", { noremap = true, silent = true })

-- map("n", "<leader>e", ":NvimTreeFocus<CR>", { noremap = true, silent = true })
-- map("n", "<C-n>", ":NvimTreeClose<CR>", { noremap = true, silent = true })
-------------------------nvim-tree -----------------------------

-------------------------buffer line ----------------------------
-- map("n", "<Tab>", ":BufferLineCycleNext<CR>", { noremap = true, silent = true })
-- map("n", "<S-Tab>", ":BufferLineCyclePrev<CR>", { noremap = true, silent = true })
-------------------------buffer line ----------------------------

map("t", "<C-x>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

map("n", "<leader>x", "<CMD>bd<CR>", { noremap = true, silent = true, desc = "Close current buffer" })

map("n", "<leader>/", "gcc", { remap = true, silent = true, desc = "Toggle comment" })
map("v", "<leader>/", "gc", { remap = true, silent = true, desc = "Toggle comment" })

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

map("x", "J", ":m '>+1<CR>gv=gv", { noremap = true, silent = true }) -- restrict the motion to visual mode only, excluding selection mode
map("x", "K", ":m '<-2<CR>gv=gv", { noremap = true, silent = true })

map("n", "J", ":m .+1<CR>==", { noremap = true, silent = true })
map("n", "K", ":m .-2<CR>==", { noremap = true, silent = true })

map("n", "<C-l>", "<C-w>l", { noremap = true, silent = true })
map("n", "<C-k>", "<C-w>k", { noremap = true, silent = true })
map("n", "<C-h>", "<C-w>h", { noremap = true, silent = true })
map("n", "<C-j>", "<C-w>j", { noremap = true, silent = true })

map("i", "<left>", "<cmd>echo 'not today'<CR>")
map("i", "<right>", "<cmd>echo 'not today'<CR>")
map("i", "<up>", "<cmd>echo 'not today'<CR>")
map("i", "<down>", "<cmd>echo 'not today'<CR>")

-----------------------------------Telescope ------------------------------------
-- keymap("n", "<leader>ff", ":Telescope find_files<CR>", { noremap = true, silent = true }) -- this respects .gitignore
map(
    "n",
    "<leader>ff",
    ":Telescope find_files find_command=rg,--no-ignore,--hidden,--files prompt_prefix=🔍<CR>",
    { noremap = true, silent = true }
)
map("n", "<leader>fg", ":Telescope live_grep<CR>", { noremap = true, silent = true })
map("n", "<leader>fb", ":Telescope buffers<CR>", { noremap = true, silent = true })
map("n", "<leader>fh", ":Telescope help_tags<CR>", { noremap = true, silent = true })
map("n", "<leader>tm", ":Telescope marks<CR>", { noremap = true, silent = true })
---------------git bindingss ----------------
map("n", "<leader>tgc", ":Telescope git_commits<CR>", { noremap = true, silent = true })
map("n", "<leader>tgb", ":Telescope git_branches<CR>", { noremap = true, silent = true })
map("n", "<leader>tgs", ":Telescope git_status<CR>", { noremap = true, silent = true })
map("n", "<leader>tgS", ":Telescope git_stash<CR>", { noremap = true, silent = true })
-----------------------------------Telescope ------------------------------------
