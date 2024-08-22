local highlights = require("catppuccin.groups.integrations.bufferline").get()
require("bufferline").setup({
    options = {
        numbers = "ordinal",
        diagnostics = "lsp",
    },
    highlights = highlights,
})
