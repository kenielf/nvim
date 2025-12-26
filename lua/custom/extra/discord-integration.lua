local M = {}

M.setup = function()
    return {
        display = {
            theme = "catppuccin",
            flavor = "dark",
            swap_icons = true,
        }
    }
end
-- M.setup({
--     display = {
--         theme = "catppuccin",
--         flavor = "mocha",
--         swap_icons = true,
--     }
    -- log_level = "off",
    -- timer = { interval = 1000 },
    -- editor = { tooltip = ":q to leave" },
    -- display = {
    --     show_repository = false,
    --     show_cursor_position = false,
    --     swap_fields = true,
    --     swap_icons = true,
    -- },
    -- lsp = { show_problem_count = true },
    -- idle = { enable = false },
-- })

return M
