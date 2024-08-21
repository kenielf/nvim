-- Leader key
vim.g.mapleader = " "

-- Quick exit
vim.keymap.set("n", "<leader>Q", "<cmd>qa!<cr>", { desc = "Quick Exit", silent = true })

-- Quick save
vim.keymap.set("n", "<leader>W", "<cmd>w<cr>", { desc = "Quick Save", silent = true })

-- Buffer navigation
vim.keymap.set("n", "<C-Left>", "<Cmd>:bp<CR>", { desc = "Previous Buffer", noremap = true, silent = true })
vim.keymap.set("n", "<C-Right>", "<Cmd>:bn<CR>", { desc = "Next Buffer", noremap = true, silent = true })
local delete = require("custom.extra.buffers").smart_bufdelete
vim.keymap.set("n", "<C-Up>", delete, { desc = "Close Buffer", noremap = true, silent = true })
