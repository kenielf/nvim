local todo = require("todo-comments")
todo.setup( {highlight = { before = true } } )

vim.keymap.set("n", "<leader><s-t>n", function() todo.jump_next() end, { desc = "Next todo comment" })
vim.keymap.set("n", "<leader><s-t>p", function() todo.jump_prev() end, { desc = "Previous todo comment" })
