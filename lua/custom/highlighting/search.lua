-- Highlight Search
require('hlslens').setup()

-- Set incremental search
vim.opt.incsearch = true

-- illuminate
require("illuminate").configure()

-- Keybinds
vim.api.nvim_set_keymap("n", "n",
    [[<cmd>execute("normal! " . v:count1 . "n")<cr><cmd>lua require("hlslens").start()<cr>]],
    { desc = "Next from Search", noremap = true, silent = true, })
vim.api.nvim_set_keymap("n", "<s-n>",
    [[<cmd>execute("normal! " . v:count1 . "N")<cr><cmd>lua require("hlslens").start()<cr>]],
    { desc = "Previous from Search", noremap = true, silent = true, })
vim.keymap.set("n", "<leader>ch", "<cmd>noh<cr>", { desc = "Clear highlighting", noremap = true, silent = true })
