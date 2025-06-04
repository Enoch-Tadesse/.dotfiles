require("FTerm").setup {
    border = "double", -- You can customize the border type (e.g., single, double, rounded, etc.)
    cmd = os.getenv "SHELL",
    width = 0.8, -- Adjust the width of the floating terminal (relative to the Neovim window)
    height = 0.8, -- Adjust the height of the floating terminal (relative to the Neovim window)
    -- cmd = "bash", -- You can specify the terminal shell here (e.g., bash, zsh, fish)
    direction = "float", -- Ensures the terminal opens as a floating window
    close_on_exit = true, -- Close the terminal automatically when the process exits
}
vim.keymap.set("n", "<A-i>", '<CMD>lua require("FTerm").toggle()<CR>', { noremap = true, silent = true })
vim.keymap.set("t", "<A-i>", '<C-\\><C-n><CMD>lua require("FTerm").toggle()<CR>', { noremap = true, silent = true })
