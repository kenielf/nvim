local mocha = require("catppuccin.palettes").get_palette("mocha")
local flavour = require("catppuccin").flavour

require("nvim-silicon").setup({
    font = "Iosevka Term=24;Noto Color Emoji=24",
    theme = "Catppuccin-" .. flavour,
    debug = false,
    background = mocha.crust,
    pad_horiz = 40,
    pad_vert = 40,
    no_round_corner = true,
    no_window_controls = true,
    shadow_blur_radius = 0,
    shadow_offset_x = 0,
    shadow_offset_y = 0,
    to_clipboard = true,
})

vim.keymap.set(
    {"n", "v"}, "<leader>sc", function() require("nvim-silicon").shoot() end,
    { desc = "Take a screenshot of the code", silent = true }
)

