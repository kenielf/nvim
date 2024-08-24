local char = "│"
if vim.g.tty then
    char = "|"
end

require("ibl").setup({
    indent = { char = char },
    scope = { enabled = true },
    exclude = {
        buftypes = { "terminal" },
        filetypes = { "dashboard" },
    },
})
