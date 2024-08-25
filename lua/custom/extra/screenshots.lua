local mocha = require("catppuccin.palettes").get_palette("mocha")
local flavour = require("catppuccin").flavour

local options = {
    font = "Iosevka Term=24;Noto Color Emoji=24",
    theme = "Catppuccin-" .. flavour,
    background = mocha.base,
    pad_horiz = 40,
    pad_vert = 40,
    shadow_blur_radius = 0,
    shadow_offset_x = 0,
    shadow_offset_y = 0,
    no_round_corner = true,
    no_window_controls = true,
    to_clipboard = true,
}

local silicon = require("silicon")
silicon.setup({ options })

vim.keymap.set(
    "v", "<leader>sc", silicon.screenshot,
    { desc = "Take a screenshot of the code", silent = true }
)
