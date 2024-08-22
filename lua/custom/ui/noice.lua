require("noice").setup({
    cmdline = {
        format = {
            cmdline = { icon = ">" },
            search_down = { icon = "󰍉 " },
            search_up = { icon = "󰍉 " },
            filter = { icon = "$" },
            lua = { icon = "󰢱 " },
            help = { icon = "?" },
        },
    },
    format = {
        level = {
            icons = {
                error = "✖",
                warn = "▼",
                info = "●",
            },
        },
    },
})
