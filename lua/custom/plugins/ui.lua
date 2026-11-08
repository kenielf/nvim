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
}

local function pick(source, opts)
    return function() Snacks.picker[source](opts) end
end

return {
    -- Theme
    {
        "catppuccin/nvim",
        name = "catppuccin",
        eager = true,
        config = function()
            if vim.g.tty then
                vim.cmd.colorscheme("default")
                return
            end
            require("catppuccin").setup({
                flavour = "mocha",
                show_end_of_buffer = true,
                transparent_background = not vim.g.is_neovide,
                auto_integrations = true,
                lsp_styles = {
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
                    inlay_hints = { background = true },
                },
            })
            vim.cmd.colorscheme("catppuccin")
        end,
    },

    -- Picker, file tree, notifications, terminal, indent guides, dashboard and more.
    -- Every module loads on first use, so one plugin replaces about ten.
    {
        "folke/snacks.nvim",
        eager = true,
        config = function()
            require("snacks").setup({
                bigfile = { enabled = true },
                explorer = { enabled = true, replace_netrw = true },
                image = { enabled = not vim.g.tty, doc = { enabled = false } },
                indent = {
                    enabled = true,
                    indent = { char = vim.g.tty and "|" or "│" },
                    animate = { enabled = false },
                },
                input = { enabled = true },
                notifier = { enabled = true, timeout = 3000 },
                scroll = {
                    enabled = not vim.g.tty and not vim.g.is_neovide,
                    animate = { duration = { step = 15, total = 250 } },
                },
                terminal = { win = { position = "float", border = "rounded" } },
                words = { enabled = true },
                picker = {
                    ui_select = true,
                    sources = {
                        explorer = {
                            hidden = true,
                            layout = { layout = { position = "right", width = 40 } },
                        },
                        projects = { dev = { "~/Projects", "~/.scripts" } },
                    },
                },
                dashboard = {
                    enabled = true,
                    preset = {
                        header = table.concat(logo, "\n"),
                        keys = {
                            { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
                            { icon = "󰱼 ", key = "f", desc = "Find File", action = pick("files") },
                            { icon = "󱎸 ", key = "t", desc = "Find Text", action = pick("grep") },
                            { icon = " ", key = "p", desc = "Projects", action = pick("projects") },
                            { icon = " ", key = "r", desc = "Recent Files", action = pick("recent") },
                            {
                                icon = " ",
                                key = "c",
                                desc = "Configuration",
                                action = pick("files", { cwd = vim.fn.stdpath("config") }),
                            },
                            { icon = " ", key = "q", desc = "Quit", action = ":qa" },
                        },
                    },
                    sections = {
                        { section = "header" },
                        { section = "keys", gap = 1, padding = 1 },
                    },
                },
            })

            local function map(mode, lhs, rhs, desc)
                vim.keymap.set(mode, lhs, rhs, { desc = desc, silent = true })
            end

            -- Find
            map("n", "<leader>ff", pick("files"), "Find files")
            map("n", "<leader>fg", pick("grep"), "Find via grep")
            map("n", "<leader>fb", pick("buffers"), "Find buffers")
            map("n", "<leader>fh", pick("help"), "Find help")
            map("n", "<leader>fp", pick("projects"), "Find projects")
            map("n", "<leader>fr", pick("recent"), "Recent files")
            map("n", "<leader>fd", pick("diagnostics"), "Find diagnostics")
            map("n", "<leader>fk", pick("keymaps"), "Find keymaps")
            map("n", "<leader>fn", pick("notifications"), "Notification history")
            map({ "n", "x" }, "<leader>cn", function() Snacks.notifier.hide() end, "Dismiss notifications")
            map("n", "<leader>fR", pick("resume"), "Resume last picker")
            map({ "n", "x" }, "<leader>fw", pick("grep_word"), "Grep word or selection")

            -- Git pickers
            map("n", "<leader>fGb", pick("git_branches"), "List branches")
            map("n", "<leader>fGc", pick("git_log_file"), "List file commits")
            map("n", "<leader>fGC", pick("git_log"), "List all commits")
            map("n", "<leader>fGs", pick("git_stash"), "Stash")

            -- Side panels
            map("n", "<a-1>", function() Snacks.explorer() end, "Toggle file tree")
            map("n", "<a-2>", pick("buffers", {
                layout = { preset = "sidebar", layout = { position = "right" } },
            }), "Buffer list")
            map("n", "<a-3>", pick("git_status", {
                layout = { preset = "sidebar", layout = { position = "right" } },
            }), "Git changes")

            -- Terminal
            map({ "n", "i", "t" }, "<c-t>", function() Snacks.terminal.toggle() end, "Toggle terminal")

            -- Jump between references to the word under the cursor
            map("n", "]]", function() Snacks.words.jump(vim.v.count1) end, "Next reference")
            map("n", "[[", function() Snacks.words.jump(-vim.v.count1) end, "Previous reference")
        end,
    },

    -- Library
    { "nvim-tree/nvim-web-devicons" },
    { "SmiteshP/nvim-navic", config = function()
        require("nvim-navic").setup({ highlight = true, lazy_update_context = true })
    end },

    -- Floating command line and messages
    { "MunifTanjim/nui.nvim" },
    {
        "folke/noice.nvim",
        event = "VeryLazy",
        deps = { "nui.nvim" },
        cond = function() return not vim.g.tty end,
        config = function()
            require("noice").setup({
                cmdline = {
                    format = {
                        cmdline = { icon = ">" },
                        search_down = { icon = "󰍉 " },
                        search_up = { icon = "󰍉 " },
                        filter = { icon = "$" },
                        lua = { icon = "󰢱 " },
                        help = { icon = "?" },
                    },
                },
                format = {
                    level = { icons = { error = "✖", warn = "▼", info = "●" } },
                },
                -- These have owners already: snacks for vim.notify, blink for signature
                -- help, the statusline for progress and Neovim for hover
                notify = { enabled = false },
                lsp = {
                    progress = { enabled = false },
                    hover = { enabled = false },
                    signature = { enabled = false },
                },
            })
        end,
    },

    -- Statusline
    {
        "nvim-lualine/lualine.nvim",
        event = "VeryLazy",
        deps = { "nvim-web-devicons" },
        config = function()
            local function breadcrumbs()
                return require("nvim-navic").get_location()
            end
            local function has_breadcrumbs()
                return package.loaded["nvim-navic"] and require("nvim-navic").is_available()
            end
            local kube = require("custom.kube")

            require("lualine").setup({
                options = {
                    globalstatus = true,
                    theme = vim.g.tty and "auto" or "catppuccin-nvim",
                    icons_enabled = not vim.g.tty,
                    disabled_filetypes = { statusline = { "snacks_dashboard" } },
                },
                sections = {
                    lualine_b = { "filename" },
                    lualine_c = {
                        "branch",
                        "diagnostics",
                        { breadcrumbs, cond = has_breadcrumbs },
                    },
                    lualine_x = {
                        {
                            kube.status,
                            cond = kube.available,
                            color = function()
                                if kube.is_dangerous() then
                                    local error = vim.api.nvim_get_hl(0, { name = "DiagnosticError", link = false })
                                    return { fg = error.fg and ("#%06x"):format(error.fg), gui = "bold" }
                                end
                            end,
                        },
                        { vim.ui.progress_status },
                        "searchcount",
                        "encoding",
                        { "fileformat", symbols = { unix = "LF", dos = "CRLF", mac = "CR" } },
                        "filetype",
                    },
                },
            })

            vim.api.nvim_create_autocmd({ "LspProgress", "Progress" }, {
                callback = function() vim.cmd.redrawstatus() end,
            })
        end,
    },

    -- Buffer tabs
    {
        "akinsho/bufferline.nvim",
        event = "VeryLazy",
        deps = { "nvim-web-devicons" },
        config = function()
            require("bufferline").setup({
                options = {
                    numbers = "ordinal",
                    diagnostics = "nvim_lsp",
                    always_show_bufferline = true,
                    show_buffer_icons = not vim.g.tty,
                    offsets = {
                        { filetype = "snacks_layout_box", text = "Files" },
                    },
                },
                highlights = not vim.g.tty and require("catppuccin.special.bufferline").get_theme() or nil,
            })
        end,
    },

    -- Sticky scope header
    {
        "nvim-treesitter/nvim-treesitter-context",
        event = { "BufReadPost", "BufNewFile" },
        config = function()
            local context = require("treesitter-context")
            context.setup({
                max_lines = 5,
                multiline_threshold = 10,
                trim_scope = "outer",
                mode = "cursor",
                separator = vim.g.tty and "-" or "─",
                zindex = 20,
            })
            vim.keymap.set("n", "<leader>gc", function() context.go_to_context(vim.v.count1) end,
                { silent = true, desc = "Jump to context" })
        end,
    },

    -- Keymap hints
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        config = function()
            local wk = require("which-key")
            wk.setup({
                preset = "helix",
                icons = { mappings = false, rules = false },
                plugins = { marks = false, registers = false },
                show_help = false,
                keys = { scroll_up = "<c-k>", scroll_down = "<c-j>" },
            })
            wk.add({
                { "<leader>c", group = "Clear" },
                { "<leader>D", group = "Debugger" },
                { "<leader>f", group = "Find" },
                { "<leader>fG", group = "Git" },
                { "<leader>g", group = "Go to" },
                { "<leader>G", group = "Git" },
                { "<leader>l", group = "LSP" },
                { "<leader>m", group = "Join / split" },
                { "<leader>p", group = "Plugins and tools" },
                { "<leader>r", group = "Tests" },
                { "<leader>s", group = "Sort, jump, snippets, screenshots" },
                { "<leader>T", group = "Todo comments" },
                { "<leader>u", group = "Toggles" },
            })
        end,
    },

    -- Diagnostics panel
    {
        "folke/trouble.nvim",
        cmd = "Trouble",
        keys = {
            { "<leader>t", "Trouble diagnostics toggle", desc = "Toggle diagnostics" },
        },
        config = function()
            require("trouble").setup({ focus = true, warn_no_results = false, open_no_results = true })
        end,
    },
}
