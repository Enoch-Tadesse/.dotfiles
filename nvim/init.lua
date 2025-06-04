vim.g.base46_cache = vim.fn.stdpath "data" .. "/base46/"
vim.g.mapleader = " "

------------------------uncomment for trash windows ------------------------------------

-- local joinpath = vim.fs and vim.fs.joinpath or function(...) return table.concat({...}, "/") end
-- local lazypath = joinpath(vim.fn.stdpath("data"), "lazy", "lazy.nvim")

------------------------uncomment for trash windows ------------------------------------

-- bootstrap lazy and all plugins
-----------------------comment this for windows ---------------------------
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
-----------------------comment this for windows ---------------------------

if not vim.uv.fs_stat(lazypath) then
    local repo = "https://github.com/folke/lazy.nvim.git"
    vim.fn.system { "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath }
end

vim.opt.rtp:prepend(lazypath)

local lazy_config = require "configs.lazy"

-- load plugins
require("lazy").setup({
    {
        "NvChad/NvChad",
        lazy = false,
        branch = "v2.5",
        import = "nvchad.plugins",
    },

    { import = "plugins" },
}, lazy_config)

-- load theme
dofile(vim.g.base46_cache .. "defaults")
dofile(vim.g.base46_cache .. "statusline")

require "options"
require "mappings"
require "configs.telescope"
require "nvchad.autocmds"

vim.schedule(function()
    -- require "mappings"
    -- require "configs.telescope"
end)
