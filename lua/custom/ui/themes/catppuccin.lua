if vim.g.tty then
    vim.cmd.colorscheme({args = {"default"}})
else
    vim.opt.termguicolors = true
    local transparency = true
    if vim.g.neovide then
        transparency = false
    end
    require("catppuccin").setup({
        flavour = "mocha",
        show_end_of_buffer = true,
        transparent_background = transparency,
        integrations = {
            notify = true,
            neotree = true,
            window_picker = true,
            illuminate = { enabled = true, lsp = false },
            indent_blankline = { enabled = true, colored_indent_levels = false, },
            telescope = { enabled = true, style = "nvchad", },
        },
    })
    vim.cmd.colorscheme({args = {"catppuccin"}})
end

