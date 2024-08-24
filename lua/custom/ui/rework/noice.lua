require("noice").setup({
    override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
        ["cmp.entry.get_documentation"] = true,
    },
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

-- Notifications
local notifications = require("notify")
vim.keymap.set({ "n", "v" }, "<leader>cn", notifications.dismiss, { desc = "Dismiss notifications" })
