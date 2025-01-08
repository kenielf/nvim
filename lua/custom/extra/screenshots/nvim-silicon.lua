local mocha = require("catppuccin.palettes").get_palette("mocha")
local flavour = require("catppuccin").flavour:gsub("^%l", string.upper)

local silicon = require("nvim-silicon")
silicon.setup({
    font = "Iosevka NF=24;Iosevka Term=24;Noto Color Emoji=24",
    theme = "Catppuccin" .. flavour,
    background = mocha.base,
    pad_horiz = 40,
    pad_vert = 40,
    tab_width = 4,
    shadow_blur_radius = 0,
    shadow_offset_x = 0,
    shadow_offset_y = 0,
    no_round_corner = true,
    no_window_controls = true,
    to_clipboard = true,
})

vim.keymap.set(
    "v", "<leader>sc", silicon.shoot,
    { desc = "Take a screenshot of the code", silent = true }
)
