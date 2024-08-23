local signs = require("gitsigns")
signs.setup({
    current_line_blame = true,
    current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = "right_align",
        delay = 250,
    }
})

vim.keymap.set({"n", "v"}, "<leader><s-g>B", function() signs.toggle_current_line_blame() end, { desc = "Toggle git blame", silent = true })

