local cord = require("cord")

cord.setup({
    log_level = "off",
    timer = { interval = 1000 },
    editor = { tooltip = ":q to leave" },
    display = {
        show_repository = false,
        show_cursor_position = false,
        swap_fields = true,
        swap_icons = true,
    },
    lsp = { show_problem_count = true },
    idle = { enable = false },
})
