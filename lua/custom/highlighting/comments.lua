require("todo-comments").setup({
    highlight = { before = true, }
})

local todo = require("todo-comments")
-- TODO: Improve this
vim.keymap.set("n", "]t", function() todo.jump_next() end, { desc = "Next todo comment" })

vim.keymap.set("n", "[t", function() todo.jump_prev() end, { desc = "Previous todo comment" })
