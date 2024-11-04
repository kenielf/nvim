local function create_option(key, icon, description, action)
    local options = {
        icon = icon,
        icon_hl = "file",
        desc = description,
        desc_hl = "group",
        key = key,
        key_hl = "group",
        key_format = " [%s]",
        action = action,
    }
    return options
end

local logo = {
    "╔════════════════════════════════════════════╗",
    "║    ▗▄  ▄▖             ▗▄         ▗▄  ▗▄▄▖  ║",
    "║    ▐█  █▌             ▝▀         ▐█  █▛▀▘  ║",
    "║    ▐█  █▌▗▄▄▄▄▄▄▄ ▄▄▄▖▗▄ ▄▄▄▄▄▄▄▖▐█  █▙▄▖  ║",
    "║    ▐█▄█▙▖▐█▀▀▀▀▜█ ▀▀▜▌▐█ █▛▀▀▀▀█▌▐█  ▀▀▀▘  ║",
    "║        █▌▐███████ █▌▐▌▐█ ███████▌▐█  █▌    ║",
    "║    ▐█  █▌         █▌▐▌▐█         ▐█  █▌    ║",
    "║    ▐█  █▌▐███████ █▌▐▌▐█ ███████▌▐█  █▌    ║",
    "║    ▐█  █▌         █▌▐▌▐█         ▐█  █▌    ║",
    "║    ▐█  █▌▐███████ █▌▐▌▐█ ███████▌▐█        ║",
    "║  ▗▄▄▄  █▌▐█▄▄▄▄▟█ █▌▐▙▄▄ █▙▄▄▄▄█▌▝▜█▀█▌    ║",
    "║  ▝▀▜█  █▌▝▀▀▀▀▀▀▀ ▀▘▝▀▀▀ ▀▀▀▀▀▀▀▘▐█  █▌    ║",
    "║  ▗▄▟█  █▌         ▄▖             ▐█  █▌    ║",
    "║  ▝▀▀▘  ▀▘         ▀▘             ▝▀  ▀▘    ║",
    "╚════════════════════════════════════════════╝",
    "",
}

local vimrc = os.getenv("MYVIMRC")
local parent_directory = vim.fn.fnameescape(vim.fn.fnamemodify(
    vimrc or vim.fn.expand("$HOME/.config/nvim/init.lua"), ':p:h'
))
local cfg_command = "e! ++p +cd\\ " .. parent_directory.. " " .. vimrc

require("dashboard").setup({
    theme = "doom",
    config = {
        header = logo,
        center = {
            create_option("n", " ", "New File", "ene!"),
            create_option("f", "󰱼 ", "Find File", "Telescope find_files"),
            create_option("t", "󱎸 ", "Find Text", "Telescope live_grep"),
            create_option("p", " ", "Projects", "Telescope project"),
            create_option("r", " ", "Recent Files", "Telescope oldfiles"),
            create_option("c", " ", "Configuration", cfg_command),
            create_option("q", " ", "Quit", "quit"),
        },
    }
})
