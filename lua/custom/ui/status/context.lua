-- Context Line
require("barbecue").setup({
    theme = "catppuccin",
    attach_navic = false,
})

-- Context Block
local tscontext = require("treesitter-context")
tscontext.setup({
    enable = true,
    max_lines = 0,
    min_window_height = 0,
    line_numbers = true,
    multiline_threshold = 10,
    trim_scope = "outer",
    mode = "cursor",
    separator = "─",
    zindex = 20,
    on_attach = nil,
})

vim.keymap.set("n", "<leader>gc", function() tscontext.go_to_context(vim.v.count1) end,
    { silent = true, desc = "Jump to context" })
