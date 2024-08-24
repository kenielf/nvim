local tsj = require('treesj')

tsj.setup({
    max_join_length = 10000,
    use_default_keymaps = false,
})

vim.keymap.set("n", "<leader>mm", function() tsj.toggle() end, {desc = "Toggle join line"})
vim.keymap.set("n", "<leader>m<s-m>", function() tsj.toggle( {split = { recursive = true } } ) end, {desc = "Toggle join line"})

vim.keymap.set("n", "<leader>ms", function() tsj.split() end, { desc = "Split line" })
vim.keymap.set("n", "<leader>m<s-s>", function() tsj.split( {split = { recursive = true } } ) end, { desc = "Split line" })

vim.keymap.set("n", "<leader>mj", function() tsj.join() end, { desc = "Join line" })
vim.keymap.set("n", "<leader>m<s-j>", function() tsj.join( {split = { recursive = true } } ) end, { desc = "Join line" })

