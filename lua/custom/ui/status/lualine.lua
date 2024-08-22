local ignore = {
    "neo-tree", "neo-tree-popup",
    "notify", "help",
}

require("lualine").setup({
    options = {
        globalstatus = true,
        theme = "catppuccin",
        disabled_filetypes = ignore,
        ignore_focus = ignore,
    },
    sections = {
        lualine_b = {
            "filename",
        },
        lualine_c = {
            "branch",
            "diagnostics",
        },
        lualine_x = {
            "encoding",
            { "fileformat", symbols = { unix = "LF", dos = "CRLF", mac = "CR" } },
        },
    }
})
