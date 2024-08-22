require("colorizer").setup({
    buftypes = {
        "*",
        -- exclude prompt and popup buftypes from highlight
        "!prompt",
        "!popup",
    },
    user_default_options = {
        RGB = true,
        RRGGBB = true,
        RRGGBBAA = true,
        names = false,
        rgb_fn = true,
        hsl_fn = true,
    },
})

vim.keymap.set("n", "<leader><s-c>", "<cmd>ColorizerToggle<cr>", { desc = "Toggle Colorizer", silent = true })
