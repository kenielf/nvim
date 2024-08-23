local neogit = require('neogit')
neogit.setup({
    integrations = {
        telescope = true,
        diffview = true,
    }
})

-- Informational
vim.keymap.set("n", "<leader><s-g>s", function() neogit.open() end, { desc = "Git Status", silent = true })
vim.keymap.set("n", "<leader><s-g>l", function() neogit.open({ "log" }) end, { desc = "Git Log", silent = true })

-- Commits
vim.keymap.set("n", "<leader><s-g>c", function() neogit.open({ "commit" }) end, { desc = "Git Commit", silent = true })
vim.keymap.set("n", "<leader><s-g>p", function() neogit.open({ "pull" }) end, { desc = "Git Pull", silent = true })
vim.keymap.set("n", "<leader><s-g>P", function() neogit.open({ "push" }) end, { desc = "Git Push", silent = true })
vim.keymap.set("n", "<leader><s-g>m", function() neogit.open({ "merge" }) end, { desc = "Git Merge", silent = true })
vim.keymap.set("n", "<leader><s-g>r", function() neogit.open({ "revert" }) end, { desc = "Git Revert", silent = true })

-- Branches
vim.keymap.set("n", "<leader><s-g>b", function() neogit.open({ "branch" }) end, { desc = "Git Branch", silent = true })
vim.keymap.set("n", "<leader><s-g>S", function() neogit.open({ "stash" }) end, { desc = "Git Stash", silent = true })
vim.keymap.set("n", "<leader><s-g>R", function() neogit.open({ "reset" }) end, { desc = "Git Reset", silent = true })

