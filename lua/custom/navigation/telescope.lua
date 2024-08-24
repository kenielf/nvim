local telescope = require("telescope")

-- Projects
local project_dirs = {}
local add_dir_if_exists = function(file)
    if vim.fn.isdirectory(file) ~= true then
        table.insert(project_dirs, file)
    end
end

-- Directories
add_dir_if_exists("~/Projects")
add_dir_if_exists("~/.scripts")

-- Setup
telescope.setup({
    extensions = { project = { base_dirs = project_dirs, hidden_files = true, } },
})

local builtin = require('telescope.builtin')

--- Keymaps
-- General
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = "Find Files", silent = true })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = "Find via Grep", silent = true })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = "Find Buffers", silent = true })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = "Find Help", silent = true })

-- Projects
vim.keymap.set("n", "<leader>fp", "<cmd>Telescope project<cr>", { desc = "Find Projects", silent = true })

-- LSP
vim.keymap.set("n", "<leader>fd", "<cmd>Telescope diagnostics<cr>", { desc = "Find Diagnostics", silent = true })

--- Git ---
vim.keymap.set("n", "<leader>f<s-g>b", "<cmd>Telescope git_branches<cr>", { desc = "List Branches", silent = true })
vim.keymap.set("n", "<leader>f<s-g>c", "<cmd>Telescope git_bcommits<cr>", { desc = "List Branch Commits", silent = true })
vim.keymap.set("n", "<leader>f<s-g><s-c>", "<cmd>Telescope git_commits<cr>", { desc = "List All Commits", silent = true })
vim.keymap.set("n", "<leader>f<s-g>s", "<cmd>Telescope git_stash<cr>", { desc = "Stash", silent = true })

-- Keymaps
vim.keymap.set("n", "<leader>f<s-g>k", "<cmd>Telescope keymaps<cr>", { desc = "Find Keymaps", silent = true })
