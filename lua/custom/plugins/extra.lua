return {
    -- Screenshots, see custom/silicon.lua
    { "michaelrommel/nvim-silicon" },

    -- Discord. Publishes what is being edited, NVIM_NO_DISCORD=1 opts out for a session.
    {
        "vyfor/cord.nvim",
        event = "VeryLazy",
        build = "Cord update",
        cond = function()
            return vim.env.NVIM_NO_DISCORD == nil and #vim.api.nvim_list_uis() > 0
        end,
        config = function()
            require("cord").setup({
                editor = { tooltip = "How do I close this?" },
                display = { theme = "catppuccin", flavor = "dark", swap_icons = true },
                timestamp = { enabled = true, shared = true },
                idle = { enabled = false },
            })
        end,
    },
}
