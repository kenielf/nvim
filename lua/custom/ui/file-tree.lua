require("neo-tree").setup({
    close_if_last_window = true,
    name = { trailing_slash = true, },
    window = { position = "right", width = 30 },
    filesystem = { follow_current_file = { enabled = true }, },
    use_libuv_file_watcher = true,
})

vim.keymap.set("n", "<A-1>", "<cmd>Neotree toggle filesystem<cr>", { desc = "Toggle File Tree", silent = true })
vim.keymap.set("n", "<A-2>", "<cmd>Neotree toggle buffers<cr>", { desc = "Toggle Buffer Tree", silent = true })
vim.keymap.set("n", "<A-3>", "<cmd>Neotree toggle git_status<cr>", { desc = "Toggle Git Tree", silent = true })
