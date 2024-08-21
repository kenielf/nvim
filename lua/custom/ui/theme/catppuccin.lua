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
        --     cmp = true,
        --     neogit = true,
        --     lsp_trouble = true,
        --     gitsigns = true,
        --     nvimtree = true,
        --     neotree = true,
        --     navic = {
        --         enabled = false,
        --         custom_bg = "NONE"
        --     },
        --     treesitter = true,
        --     treesitter_context = true,
        --     illuminate = {
        --         enabled = true,
        --         lsp = false,
        --     },
        --     mason = true,
        --     flash = true,
        --     noice = true,
        --     which_key = true,
        --     telescope = true,
        --     notify = true,
        --     indent_blankline = {
        --         enabled = true,
        --         scope_color = mocha.blue,
        --     },
        --     mini = {
        --         enabled = true,
        --         indentscope_color = "",
        --     },
        --     native_lsp = {
        --         underlines = {
        --             errors = { "undercurl" },
        --             hints = { "undercurl" },
        --             warnings = { "undercurl" },
        --             information = { "undercurl" },1
        --         },
        --         inlay_hints = {
        --             background = false,
        --         },
        --     }
        --     -- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
        -- },
    })
    vim.cmd.colorscheme({args = {"catppuccin"}})
end

