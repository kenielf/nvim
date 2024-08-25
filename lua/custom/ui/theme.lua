if vim.g.tty then
    vim.cmd.colorscheme({ args = { "default" } })
else
    vim.opt.termguicolors = true
    local transparency = true
    if vim.g.neovide then
        transparency = false
    end

    -- Theme Integrations
    local integrations = {
        barbecue = {
            dim_dirname = true, -- directory name is dimmed by default
            bold_basename = true,
            dim_context = true,
            alt_background = false,
        },
        fidget = true,
        flash = true,
        gitsigns = true,
        illuminate = { enabled = true, lsp = false },
        indent_blankline = { enabled = true, colored_indent_levels = false, },
        lsp_trouble = true,
        mason = true,
        native_lsp = {
            enabled = true,
            virtual_text = {
                errors = { "italic" },
                hints = { "italic" },
                warnings = { "italic" },
                information = { "italic" },
                ok = { "italic" },
            },
            underlines = {
                errors = { "underline" },
                hints = { "underline" },
                warnings = { "underline" },
                information = { "underline" },
                ok = { "underline" },
            },
            inlay_hints = { background = true, },
        },
        neogit = true,
        neotree = true,
        noice = true,
        notify = true,
        nvim_surround = true,
        render_markdown = true,
        telescope = { enabled = true, style = "nvchad", },
        which_key = true,
        window_picker = true,
    }

    -- Configuring the theme
    require("catppuccin").setup({
        flavour = "mocha",
        show_end_of_buffer = true,
        transparent_background = transparency,
        integrations = integrations,
    })
    vim.cmd.colorscheme({ args = { "catppuccin" } })
end
