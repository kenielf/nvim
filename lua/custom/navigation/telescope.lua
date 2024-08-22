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
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = "Find Files" })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = "Find via Grep" })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = "Find Buffers" })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = "Find Help" })

-- Projects
vim.keymap.set("n", "<leader>fp", "<CMD>Telescope project<CR>", { desc = "Find Projects" })

-- LSP
vim.keymap.set("n", "<leader>fd", "<CMD>Telescope diagnostics<CR>", { desc = "Find Diagnostics" })

--- Git ---
vim.keymap.set("n", "<leader>fGb", "<CMD>Telescope git_branches<CR>", { desc = "List Branches" })
vim.keymap.set("n", "<leader>fGc", "<CMD>Telescope git_bcommits<CR>", { desc = "List Branch Commits" })
vim.keymap.set("n", "<leader>fGC", "<CMD>Telescope git_commits<CR>", { desc = "List All Commits" })
vim.keymap.set("n", "<leader>fGs", "<CMD>Telescope git_stash<CR>", { desc = "" })

