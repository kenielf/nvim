require 'window-picker'.setup({
    hint = "floating-big-letter",
    filter_rules = {
        bo = {
            filetype = { "neo-tree", "neo-tree-popup", "notify" },
            buftype = { 'terminal', "quickfix" },
        },
    },
})
