return {
    -- Parsers and queries. Highlighting itself is native, see autocmds.lua. Upstream
    -- doesn't support lazy-loading, and its plugin/ only defines a few commands.
    {
        "nvim-treesitter/nvim-treesitter",
        version = "main",
        eager = true,
        build = "TSUpdate",
        config = function()
            -- Filetypes without a parser of their own
            vim.treesitter.language.register("bash", { "ebuild", "eclass", "ksh" })
            vim.treesitter.language.register("slang", { "shaderslang" })
            vim.treesitter.language.register("c_sharp", { "cs" })
        end,
    },

    -- Gentoo filetypes
    {
        "gentoo/gentoo-syntax",
        eager = true,
        cond = function() return vim.uv.fs_stat("/etc/gentoo-release") ~= nil end,
    },

    -- Markdown: rendered in place, raw on the line being edited and in insert mode
    {
        "MeanderingProgrammer/render-markdown.nvim",
        ft = "markdown",
        deps = { "nvim-web-devicons" },
        config = function()
            require("render-markdown").setup({
                file_types = { "markdown" },
                render_modes = { "n", "c", "t" },
                anti_conceal = { enabled = true },
                heading = { sign = false, width = "block", min_width = 80 },
                code = { sign = false, width = "block", min_width = 80, left_pad = 2, right_pad = 2 },
                completions = { lsp = { enabled = true } },
            })
            vim.keymap.set("n", "<leader>um", "<cmd>RenderMarkdown toggle<cr>",
                { desc = "Toggle markdown rendering", silent = true })
        end,
    },

    -- Jumping
    {
        "folke/flash.nvim",
        keys = {
            { "<leader>sf", function() require("flash").jump() end, mode = { "n", "x", "o" }, desc = "Flash" },
            { "<leader>st", function() require("flash").treesitter() end, mode = { "n", "x", "o" }, desc = "Flash Treesitter" },
        },
        config = function()
            require("flash").setup({
                search = { mode = "fuzzy", incremental = true },
                modes = { search = { enabled = false }, char = { enabled = false } },
            })
        end,
    },

    -- Split and join
    {
        "Wansmer/treesj",
        keys = {
            { "<leader>mm", function() require("treesj").toggle() end, desc = "Toggle join line" },
            { "<leader>mM", function() require("treesj").toggle({ split = { recursive = true } }) end, desc = "Toggle join line (recursive)" },
            { "<leader>ms", function() require("treesj").split() end, desc = "Split line" },
            { "<leader>mS", function() require("treesj").split({ split = { recursive = true } }) end, desc = "Split line (recursive)" },
            { "<leader>mj", function() require("treesj").join() end, desc = "Join line" },
        },
        config = function()
            require("treesj").setup({ max_join_length = 10000, use_default_keymaps = false })
        end,
    },

    -- Surround
    {
        "kylechui/nvim-surround",
        event = "VeryLazy",
        config = function() require("nvim-surround").setup() end,
    },

    -- Pairs
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        config = function()
            require("nvim-autopairs").setup({ check_ts = true, disable_filetype = { "snacks_picker_input", "vim" } })
        end,
    },

    -- Todo comments
    {
        "folke/todo-comments.nvim",
        event = { "BufReadPost", "BufNewFile" },
        deps = { "plenary.nvim" },
        config = function()
            local todo = require("todo-comments")
            todo.setup({ highlight = { before = true } })
            vim.keymap.set("n", "<leader>Tn", todo.jump_next, { desc = "Next todo comment" })
            vim.keymap.set("n", "<leader>Tp", todo.jump_prev, { desc = "Previous todo comment" })
            vim.keymap.set("n", "<leader>Tl", function() Snacks.picker.todo_comments() end, { desc = "List todo comments" })
        end,
    },
    { "nvim-lua/plenary.nvim" },

    -- Colors. Language servers already render theirs through vim.lsp.document_color,
    -- this adds the same to any other buffer on request.
    {
        "catgoose/nvim-colorizer.lua",
        name = "nvim-colorizer.lua",
        cmd = "ColorizerToggle",
        keys = {
            { "<leader>C", "ColorizerToggle", desc = "Toggle colorizer" },
        },
        config = function()
            require("colorizer").setup({
                lazy_load = true,
                user_default_options = { RGB = true, RRGGBB = true, RRGGBBAA = true, names = false, rgb_fn = true, hsl_fn = true },
            })
        end,
    },
}
