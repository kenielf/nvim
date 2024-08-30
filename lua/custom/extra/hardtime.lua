require("hardtime").setup({ enabled = false, })

vim.keymap.set("n", "<leader><s-h>h", "<cmd>Hardtime toggle<cr>", { desc = "Toggle Hardtime", silent = true })
