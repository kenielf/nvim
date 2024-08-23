-- Context Line
-- local highlights = require("custom.extras.highlight-utils")
require("barbecue").setup({
    theme = "catppuccin",
     attach_navic = false,
})

-- Context Block
require("treesitter-context").setup({
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

vim.keymap.set("n", "[c", function()
    require("treesitter-context").go_to_context(vim.v.count1)
end, { silent = true, desc = "Jump to context" })
