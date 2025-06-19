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
-------------------------auto commands-----------------------

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
    update_in_insert = false,
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
