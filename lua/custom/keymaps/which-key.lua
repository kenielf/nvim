require("which-key").setup({
    preset = "helix",
    icons = { mappings = false, rules = false },
    plugins = { marks = false, register = false, },
    show_help = false,
    keys = { scroll_up = "<c-k>", scroll_down = "<c-j>" },
})
