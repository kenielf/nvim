local snippet_dir = vim.fn.stdpath("config") .. "/snippets"

return {
    -- Server configs, used as data only (lsp/*.lua). Enabled on the first real file
    -- so that an empty start or the dashboard doesn't pay for any of it.
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        deps = { "blink.cmp" },
        config = function() require("custom.lsp").setup() end,
    },

    -- Completion and signature help
    { "rafamadriz/friendly-snippets" },
    {
        "saghen/blink.cmp",
        version = vim.version.range("1.*"),
        event = { "InsertEnter", "CmdlineEnter" },
        deps = { "friendly-snippets" },
        config = function()
            require("blink.cmp").setup({
                keymap = {
                    preset = "none",
                    ["<c-space>"] = { "show", "show_documentation", "hide_documentation" },
                    ["<c-e>"] = { "hide", "fallback" },
                    ["<c-y>"] = { "select_and_accept", "fallback" },
                    ["<c-p>"] = { "select_prev", "fallback" },
                    ["<c-n>"] = { "select_next", "fallback" },
                    ["<c-u>"] = { "scroll_documentation_up", "fallback" },
                    ["<c-d>"] = { "scroll_documentation_down", "fallback" },
                    ["<c-f>"] = { "snippet_forward", "fallback" },
                    ["<c-b>"] = { "snippet_backward", "fallback" },
                },
                completion = {
                    accept = { auto_brackets = { enabled = true } },
                    documentation = { auto_show = true, auto_show_delay_ms = 200 },
                    list = { selection = { preselect = true, auto_insert = false } },
                },
                signature = { enabled = true },
                cmdline = {
                    completion = {
                        menu = { auto_show = true },
                        -- Otherwise the first <tab> skips the first item
                        list = { selection = { preselect = false } },
                    },
                },
                fuzzy = { implementation = "prefer_rust_with_warning" },
                snippets = { preset = "default" },
                sources = {
                    default = { "lsp", "path", "snippets", "buffer" },
                    per_filetype = { lua = { inherit_defaults = true, "lazydev" } },
                    providers = {
                        lazydev = {
                            name = "LazyDev",
                            module = "lazydev.integrations.blink",
                            score_offset = 100,
                        },
                        snippets = {
                            opts = {
                                search_paths = { snippet_dir },
                                extended_filetypes = { javascript = { "html" } },
                            },
                        },
                    },
                },
            })
        end,
    },

    -- Snippet editing
    {
        "chrisgrieser/nvim-scissors",
        keys = {
            { "<leader>se", function() require("scissors").editSnippet() end, desc = "Edit snippet" },
            { "<leader>sa", function() require("scissors").addNewSnippet() end, mode = { "n", "x" }, desc = "Add new snippet" },
        },
        config = function() require("scissors").setup({ snippetDir = snippet_dir }) end,
    },

    -- Neovim API completion while editing this config
    {
        "folke/lazydev.nvim",
        ft = "lua",
        config = function()
            require("lazydev").setup({
                library = { { path = "${3rd}/luv/library", words = { "vim%.uv" } } },
            })
        end,
    },

    -- Formatting
    {
        "stevearc/conform.nvim",
        event = "VeryLazy",
        cmd = "ConformInfo",
        keys = {
            {
                "<F3>",
                function() require("conform").format({ async = true }) end,
                mode = { "n", "x" },
                desc = "Format",
            },
        },
        config = function()
            local formatters_by_ft = {}
            for _, lang in ipairs(require("custom.languages")) do
                formatters_by_ft = vim.tbl_extend("force", formatters_by_ft, lang.formatters or {})
            end
            require("conform").setup({
                formatters_by_ft = formatters_by_ft,
                default_format_opts = { lsp_format = "fallback" },
                notify_no_formatters = true,
                format_on_save = function()
                    if vim.g.format_on_save then
                        return { timeout_ms = 1000 }
                    end
                end,
            })
        end,
    },

    -- Installer for language tools, see custom/tools.lua
    {
        "mason-org/mason.nvim",
        cmd = { "Mason", "MasonInstall", "MasonUninstall", "MasonUpdate", "MasonLog" },
        keys = {
            { "<leader>pm", "Mason", desc = "Open Mason" },
        },
        config = function()
            -- PATH is handled in options.lua, with system binaries taking priority
            require("mason").setup({ PATH = "skip" })
        end,
    },

    -- Java, started from ftplugin/java.lua
    { "mfussenegger/nvim-jdtls" },
}
