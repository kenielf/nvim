require("toggleterm").setup({
    direction = 'float',
    float_opts = { border = 'curved' }
})

vim.keymap.set({ "n", "i", "t" }, "<c-t>", "<cmd>ToggleTerm<cr>",
    { desc = "Toggle terminal", noremap = true, silent = true })
