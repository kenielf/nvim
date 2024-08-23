require("trouble").setup({
    auto_close = true,
    focus = true,
    warn_no_results = false,
    open_no_results = true,
    win = {
        icons = {
            indent = {
                middle = " ",
                last = " ",
                top = " ",
                ws = "│    ",
            },
        },
        modes = {
            diagnostics = {
                groups = {
                    { "filename", format = "{file_icon} {basename:Title} {count}" },
                },
            },
        },
    },
    preview = {
        type = "float",
        relative = "editor",
        border = "rounded",
        title = "Preview",
        title_pos = "center",
        position = { 0, -2 },
        size = { width = 0.3, height = 0.3 },
        zindex = 200,
    },
})

vim.keymap.set(
    "n", "<leader>t", "<CMD>Trouble diagnostics toggle<CR>"
)
