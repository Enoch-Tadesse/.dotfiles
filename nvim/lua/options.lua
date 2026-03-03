require "nvchad.options"

-- add yours here!

-- local o = vim.o
-- o.cursorlineopt ='both' -- to enable cursorline!

-------------------------auto commands-----------------------
--- disable treesitter and lsp for syntax highlighting and uncomment this for no syntax
-- vim.api.nvim_create_autocmd("BufReadPost", {
--   pattern = "*",
--   callback = function()
--     vim.cmd("syntax off")
--   end,
-- })

local group = vim.api.nvim_create_augroup("AutoSave", { clear = true })

-- vim.cmd("syntax off")

-- rust pub mod adding for CF
vim.api.nvim_create_autocmd("BufNewFile", {
    pattern = "*/src/problems/*.rs",
    callback = function()
        local filename = vim.fn.expand("<afile>:t:r")
        -- Get the directory of the new file
        local dir = vim.fn.expand("<afile>:p:h") 
        -- Construct path to main.rs (up one level from src/problems to src/)
        local main_path = vim.fn.fnamemodify(dir, ":h") .. "/main.rs"

        -- Debug: Uncomment the line below if it still doesn't work to see the path
        -- vim.notify("Looking for main.rs at: " .. main_path)

        if vim.fn.filereadable(main_path) == 0 then
            return
        end

        local lines = vim.fn.readfile(main_path)
        local new_line = "    pub mod " .. filename .. ";"
        local exists = false
        local insert_idx = -1

        for i, line in ipairs(lines) do
            if line:match("pub mod " .. filename .. ";") then
                exists = true
                break
            end
            -- Match the start of your problems block
            if line:match("mod problems {") then
                insert_idx = i
            end
        end

        if not exists and insert_idx ~= -1 then
            table.insert(lines, insert_idx + 1, new_line)
            vim.fn.writefile(lines, main_path)
            vim.notify("✅ Added 'pub mod " .. filename .. "' to main.rs")
        end
    end,
})
-- rust pub mod adding for CF

vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged", "FocusLost" }, {
    pattern = "*",
    group = group,
    callback = function()
        -- Only save if the buffer is modifiable and has a file
        if vim.bo.modifiable and vim.fn.expand "%" ~= "" and vim.bo.modified then
            vim.cmd "silent! write"
        end
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = "dart",
    callback = function()
        vim.opt_local.tabstop = 2
        vim.opt_local.shiftwidth = 2
        vim.opt_local.softtabstop = 2
        vim.opt_local.expandtab = 2
    end,
})

vim.api.nvim_create_user_command("Rl", function()
    local filename = vim.fn.expand "%:p"
    vim.cmd "tabnew" -- open new tab
    local bufnr = vim.api.nvim_get_current_buf()

    vim.fn.termopen { "rustc", "--crate-name", "solution", filename }

    vim.api.nvim_create_autocmd("TermClose", {
        buffer = bufnr,
        once = true,
        callback = function()
            vim.schedule(function()
                -- Try to close the window, ignore errors
                pcall(function()
                    local win = vim.fn.bufwinnr(bufnr)
                    if win ~= -1 then
                        vim.api.nvim_win_close(win, true)
                    end
                end)
                -- Try to close the tab if empty, ignore errors
                pcall(function()
                    if vim.api.nvim_tabpage_get_win_count(0) == 0 then
                        vim.cmd "tabclose"
                    end
                end)
            end)
        end,
    })
end, {})
-- Create abbreviation so :rl expands to :Rl
vim.cmd "cnoreabbrev rl Rl"
-------------------------auto commands-----------------------

vim.keymap.set("n", "<leader>lw", function()
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
    vim.opt_local.breakindent = true
    vim.opt_local.showbreak = "↪ "
end, { desc = "Wrap text in LeetCode buffer" })

--------------------------------------------------------
vim.opt.completeopt = { "menuone", "noselect" } -- shows menu even if it is one and the first choice is not auto selected
vim.opt.fileencoding = "utf-8" -- default is utf-8 but just making sure
vim.opt.showmode = false -- show current mode at the bottom
-- vim.opt.title = true -- set terminal title
vim.opt.incsearch = true -- incremental search -- shows matches as you type
-- vim.opt.syntax = "on" -- enable syntax highlighting

vim.opt.guicursor = "" -- fat cursor
vim.opt.swapfile = false -- no swap file
vim.opt.backup = false -- no backup file

vim.hl.priorities.semantic_tokens = 0
vim.opt.clipboard = "unnamedplus" -- uses system clipboard
vim.opt.termguicolors = true
vim.opt.wrap = true -- no line wrap
vim.diagnostic.config {
    virtual_text = true, -- shows inline error messages
    signs = false, -- turns of signs like E, W, H, I ,U
    underline = true,
    update_in_insert = true,
    severity_sort = true,
}

vim.g.mapleader = " "
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = false -- use tabs instead of spaces -- use real tabs instead of spaces
vim.opt.smartindent = true -- smart indenting
vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = "yes"

-- Decrease update time
vim.opt.updatetime = 200

-- Decrease mapped sequence wait time
vim.opt.timeoutlen = 250
-- vim.opt.ttimeoutlen = 10 -- disable timeout for key sequences

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
-- vim.opt.list = true
-- vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
vim.opt.inccommand = "split"

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10
vim.opt.sidescrolloff = 10

-- if performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
-- instead raise a dialog asking if you wish to save the current file(s)
-- See `:help 'confirm'`
vim.opt.confirm = true

-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
