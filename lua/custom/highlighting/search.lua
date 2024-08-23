-- Highlight Search
require('hlslens').setup()

-- Set incremental search
vim.opt.incsearch = true

-- illuminate
require("illuminate").configure()

-- Keybinds
vim.api.nvim_set_keymap('n', 'n',
    [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]],
    { desc = "Next from Search", noremap = true, silent = true, })
vim.api.nvim_set_keymap('n', '<s-n>',
    [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]],
    { desc = "Next from Search", noremap = true, silent = true, })
vim.keymap.set("n", "<leader>ch", "<cmd>noh<cr>", { desc = "Clear highlighting", noremap = true, silent = true })
