local function neogit(popup)
    return function() require("neogit").open(popup and { popup } or nil) end
end

return {
    -- Signs and blame
    {
        "lewis6991/gitsigns.nvim",
        event = { "BufReadPost", "BufNewFile" },
        config = function()
            local signs = require("gitsigns")
            signs.setup({
                current_line_blame = true,
                current_line_blame_opts = { virt_text_pos = "right_align", delay = 250 },
            })
            vim.keymap.set({ "n", "x" }, "<leader>GB", signs.toggle_current_line_blame,
                { desc = "Toggle git blame", silent = true })
            vim.keymap.set("n", "]c", function()
                if vim.wo.diff then
                    vim.cmd.normal({ "]c", bang = true })
                else
                    signs.nav_hunk("next")
                end
            end, { desc = "Next hunk", silent = true })
            vim.keymap.set("n", "[c", function()
                if vim.wo.diff then
                    vim.cmd.normal({ "[c", bang = true })
                else
                    signs.nav_hunk("prev")
                end
            end, { desc = "Previous hunk", silent = true })
            vim.keymap.set("n", "<leader>Gh", signs.preview_hunk, { desc = "Preview hunk", silent = true })
        end,
    },

    -- Diff views. Maintained fork, sindrets/diffview.nvim has been idle since 2024.
    { "dlyongemallo/diffview-plus.nvim" },

    -- Status, commit, merge, rebase
    {
        "NeogitOrg/neogit",
        cmd = "Neogit",
        deps = { "plenary.nvim", "diffview-plus.nvim" },
        keys = {
            { "<leader>Gs", neogit(), desc = "Git status" },
            { "<leader>Gl", neogit("log"), desc = "Git log" },
            { "<leader>Gc", neogit("commit"), desc = "Git commit" },
            { "<leader>Gp", neogit("pull"), desc = "Git pull" },
            { "<leader>GP", neogit("push"), desc = "Git push" },
            { "<leader>Gm", neogit("merge"), desc = "Git merge" },
            { "<leader>Gr", neogit("revert"), desc = "Git revert" },
            { "<leader>Gb", neogit("branch"), desc = "Git branch" },
            { "<leader>GS", neogit("stash"), desc = "Git stash" },
            { "<leader>GR", neogit("reset"), desc = "Git reset" },
            { "<leader>Gd", "DiffviewOpen", desc = "Diff view" },
        },
        config = function()
            require("neogit").setup({ integrations = { snacks = true, diffview = true } })
        end,
    },
}
