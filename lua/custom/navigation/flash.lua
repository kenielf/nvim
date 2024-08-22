local flash = require("flash")
flash.setup({
    mode = "fuzzy",
    incremental = true,
    exclude = {
        "notify",
        "cmp_menu",
        "noice",
        "flash_prompt",
        function(win) return not vim.api.nvim_win_get_config(win).focusable end,
    },
})

vim.keymap.set({ "n", "x", "o" }, "<leader>sf", function() flash.jump() end, {desc = "Flash", silent = true})
vim.keymap.set({ "n", "x", "o" }, "<leader>st", function() flash.treesitter() end, {desc = "Flash Treesitter", silent = true})
