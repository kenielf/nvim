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
        -- integrations = {
        --     notify = true,
        -- },
    })
    vim.cmd.colorscheme({args = {"catppuccin"}})
end

