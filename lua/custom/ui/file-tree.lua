require("neo-tree").setup({
    close_if_last_window = true,
    disable_netrw = true,
    hijack_netrw = true,
    hijack_cursor = true,
    auto_reload_on_write = true,
    hijack_unnamed_buffer_when_opening = true,
    update_focused_file = {
        enable = true,
        update_root = true,
    },
    name = { trailing_slash = true, },
    window = { position = "right", width = 40 },
    filesystem = { follow_current_file = { enabled = true }, },
    use_libuv_file_watcher = true,
    renderer = {
        group_empty = true,
        root_folder_label = false,
        highlight_git = false,
        highlight_opened_files = "none",
        add_trailing = true,

        indent_markers = {
            enable = true,
        },

        icons = {
            padding = "  ",
            show = {
                file = true,
                folder = true,
                folder_arrow = true,
                git = true,
            },

            glyphs = {
                default = "󰈚",
                symlink = "",
                folder = {
                    default = "",
                    empty = "",
                    empty_open = "",
                    open = "",
                    symlink = "",
                    symlink_open = "",
                    arrow_open = "",
                    arrow_closed = "",
                },
                git = {
                    unstaged = "✗",
                    staged = "✓",
                    unmerged = "",
                    renamed = "➜",
                    untracked = "★",
                    deleted = "",
                    ignored = "◌",
                },
            },
        },
    },
    filters = {
        dotfiles = true,
    },
    git = {
        enable = true,
        ignore = true,
    },
    filesystem_watchers = {
        enable = true,
    },
    actions = {
        open_file = {
            resize_window = true,
        },
    },
})

vim.keymap.set("n", "<A-1>", "<cmd>Neotree toggle filesystem<cr>", { desc = "Toggle File Tree", silent = true })
vim.keymap.set("n", "<A-2>", "<cmd>Neotree toggle buffers<cr>", { desc = "Toggle Buffer Tree", silent = true })
vim.keymap.set("n", "<A-3>", "<cmd>Neotree toggle git_status<cr>", { desc = "Toggle Git Tree", silent = true })
