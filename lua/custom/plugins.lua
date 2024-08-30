-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out,                            "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

-- Install plugins
local plugins = {
    --- UI ---
    -- Themes: Catppuccin
    {
        "catppuccin/nvim",
        name = "catppuccin",
        lazy = false,
        priority = 1000,
        config = function() require("custom.ui.theme") end,
    },

    -- Rework: UI Replacement
    {
        "folke/noice.nvim",
        event = "VeryLazy",
        dependencies = {
            "MunifTanjim/nui.nvim",
            "rcarriga/nvim-notify",
        },
        config = function() require("custom.ui.rework.noice") end,
    },

    {
        "stevearc/dressing.nvim",
        event = "VeryLazy",
        config = function() require("custom.ui.rework.dressing") end,
    },

    -- Rework: File Tree
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        lazy = false,
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons",
            "MunifTanjim/nui.nvim",
            {
                "s1n7ax/nvim-window-picker",
                config = function() require("custom.ui.utils.window-picker") end
            },
        },
        config = function() require("custom.ui.rework.file-tree") end
    },

    -- Indentation Markers
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        event = "VeryLazy",
        config = function() require("custom.ui.rework.indentation") end
    },

    -- Utils: Image Previews
    {
        "3rd/image.nvim",
        event = "VeryLazy",
        dependencies = {
            "vhyrro/luarocks.nvim",
            opts = { rocks = { "magick" }, },
            priority = 1000,
        },
        config = function() require("custom.ui.utils.images") end,
    },

    -- Utils: Dashboard
    {
        "nvimdev/dashboard-nvim",
        event = "VimEnter",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function() require("custom.ui.utils.dashboard") end,
    },

    -- Utils: Terminal
    {
        "akinsho/toggleterm.nvim",
        version = "*",
        event = "VeryLazy",
        config = function() require("custom.ui.utils.terminal") end,
    },

    -- Status: Buffers
    {
        "akinsho/bufferline.nvim",
        version = "*",
        lazy = false,
        dependencies = "nvim-tree/nvim-web-devicons",
        config = function() require("custom.ui.status.bufferline") end,
    },

    -- Status: Info Line
    {
        "nvim-lualine/lualine.nvim",
        lazy = false,
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function() require("custom.ui.status.lualine") end,
    },

    -- Status: Context
    {
        "utilyre/barbecue.nvim",
        name = "barbecue",
        event = "LspAttach",
        version = "*",
        dependencies = {
            "SmiteshP/nvim-navic",
            "nvim-treesitter/nvim-treesitter",
            "nvim-treesitter/nvim-treesitter-context",
            "nvim-tree/nvim-web-devicons",
        },
        config = function() require("custom.ui.status.context") end,
    },

    -- Status: LSP
    {
        "j-hui/fidget.nvim",
        event = "VeryLazy",
        config = function() require("custom.ui.status.fidget") end,
    },

    --- Behavior --
    -- TreeSitterJoiner
    {
        "Wansmer/treesj",
        event = "VeryLazy",
        config = function() require("custom.behavior.join") end
    },

    -- Comments
    {
        "numToStr/Comment.nvim",
        event = "VeryLazy",
        config = function() require("custom.behavior.comments") end,
    },

    -- Surround
    {
        "windwp/nvim-autopairs",
        version = "*",
        event = "VeryLazy",
        dependencies = { "kylechui/nvim-surround", version = "*" },
        config = function() require("custom.behavior.surround") end,
    },

    --- Git ---
    -- Neogit
    {
        "NeogitOrg/neogit",
        event = "VeryLazy",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "sindrets/diffview.nvim",
            "nvim-telescope/telescope.nvim"
        },
        config = function() require("custom.git.neogit") end,
    },

    -- Signs
    {
        "lewis6991/gitsigns.nvim",
        event = "VeryLazy",
        config = function() require("custom.git.signs") end
    },

    --- Highlighting ---
    -- Syntax Highlighting
    {
        "nvim-treesitter/nvim-treesitter",
        lazy = false,
        run = function() vim.cmd [[:TSUpdate]] end,
        dependencies = "yioneko/nvim-yati",
        config = function() require("custom.highlighting.syntax") end,
    },

    -- Search
    {
        "kevinhwang91/nvim-hlslens",
        event = "VeryLazy",
        dependencies = { "RRethy/vim-illuminate", event = "VeryLazy", },
        config = function() require("custom.highlighting.search") end,
    },

    -- Colorizer
    {
        "NvChad/nvim-colorizer.lua",
        event = "VeryLazy",
        config = function() require("custom.highlighting.colors") end,
    },

    -- Comments
    {
        "folke/todo-comments.nvim",
        event = "VeryLazy",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function() require("custom.highlighting.comments") end,
    },

    --- Keymaps ---
    -- Key Indicator
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        desc = "Keybinds",
        config = function() require("custom.keymaps.which-key") end,
    },

    --- Lsp ---
    -- LSP Zero
    {
        "VonHeikemen/lsp-zero.nvim",
        branch = "v4.x",
        lazy = false,
        dependencies = {
            -- LSP Support
            { "neovim/nvim-lspconfig" },
            { "williamboman/mason.nvim" },
            { "williamboman/mason-lspconfig.nvim" },
            { "jay-babu/mason-nvim-dap.nvim" },
            { "WhoIsSethDaniel/mason-tool-installer.nvim" },

            -- Autocompletion
            { "hrsh7th/nvim-cmp" },
            { "hrsh7th/cmp-buffer" },
            { "hrsh7th/cmp-path" },
            { "hrsh7th/cmp-cmdline" },
            {
                "saadparwaiz1/cmp_luasnip",
                version = "2.*",
                build = "make install_jsregexp",
                dependencies = {
                    "rafamadriz/friendly-snippets",
                    "chrisgrieser/nvim-scissors",
                },
            },
            { "hrsh7th/cmp-nvim-lsp" },
            { "hrsh7th/cmp-nvim-lua" },
            {
                "windwp/nvim-autopairs",
                event = "InsertEnter",
            },

            -- Formatter
            { "lukas-reineke/lsp-format.nvim" },

            -- Snippets
            { "L3MON4D3/LuaSnip" },
            { "rafamadriz/friendly-snippets" },
        },
        config = function() require("custom.lsp") end,
    },

    -- Diagnostics
    {
        "folke/trouble.nvim",
        event = "LspAttach",
        config = function() require("custom.lsp.trouble") end,
    },

    -- Debugger
    {
        "rcarriga/nvim-dap-ui",
        event = "LspAttach",
        dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
        config = function() require("custom.lsp.dap") end,
    },

    -- Extra Languages: Markdown
    {
        "OXY2DEV/markview.nvim",
        event = "VeryLazy",
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "nvim-tree/nvim-web-devicons"
        },
        config = function() require("custom.lsp.languages.markdown") end,
    },

    -- Extra Languages: Java
    {
        "mfussenegger/nvim-jdtls",
        event = "VeryLazy",
        config = function() require("custom.lsp.languages.java") end
    },

    --- Navigation ---
    -- Neoscroll
    {
        "karb94/neoscroll.nvim",
        event = "VeryLazy",
        config = function() require("custom.navigation.scrolling") end,
    },

    -- Telescope
    {
        "nvim-telescope/telescope.nvim",
        lazy = false,
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope-project.nvim",
            "benfowler/telescope-luasnip.nvim",
        },
        config = function() require("custom.navigation.telescope") end,
    },

    -- Flash
    {
        "folke/flash.nvim",
        event = "VeryLazy",
        config = function() require("custom.navigation.flash") end,
    },

    --- Extra ---
    -- Screenshots
    {
        "kenielf/silicon.nvim",
        event = "VeryLazy",
        config = function() require("custom.extra.screenshots") end,
    },

    -- Discord
    {
        "vyfor/cord.nvim",
        build = "./build",
        event = "VeryLazy",
        config = function() require("custom.extra.discord-integration") end,
    },

    -- Hardtime
    {
        "m4xshen/hardtime.nvim",
        event = "VeryLazy",
        dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },
        config = function() require("custom.extra.hardtime") end,
    },

    -- Startup Time
    { "dstein64/vim-startuptime", },
}

-- Load lazy plugin manager
local disabled_plugins = {
    -- NetRW
    "netrw", "netrwPlugin", "netrwSettings", "netrwFileHandlers",

    -- Html
    "2html_plugin", "tohtml",

    -- Scripting
    "getscript",
    "getscriptPlugin",

    -- Tar
    "tar", "tarPlugin",

    -- Vimball
    "vimball", "vimballPlugin",

    -- Zip
    "zip", "zipPlugin", "gzip",

    -- Vim
    "tutor", "rplugin", "syntax", "synmenu", "optwin", "compiler",
    "bugreport", "ftplugin",
}

require("lazy").setup({
    spec = plugins,
    checker = { enabled = true, frequency = 259200 }, -- Three days
    defaults = { lazy = true, },
    performance = { rtp = { disabled_plugins = disabled_plugins, }, },
})

vim.keymap.set("n", "<leader>pl", "<cmd>Lazy<cr>", { desc = "Open Lazy", silent = true })
