-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
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
    -- Colorscheme
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        config = function() require("custom.ui.themes.catppuccin") end,
    },

    -- UI Replacement
    {
        "folke/noice.nvim",
        event = "VeryLazy",
        dependencies = {
            "MunifTanjim/nui.nvim",
            "rcarriga/nvim-notify",
        },
        config = function()
            require("custom.ui.noice")
            require("custom.ui.visual-markers")
        end,
    },
    -- File Tree
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons",
            "MunifTanjim/nui.nvim",
            {
                "s1n7ax/nvim-window-picker",
                config = function() require("custom.ui.window-picker") end
            },
        },
        config = function() require("custom.ui.file-tree") end
    },

    -- Image Previews
    {
        "3rd/image.nvim",
        dependencies = {
            "vhyrro/luarocks.nvim",
            opts = { rocks = { "magick" }, },
            priority = 1000,
        },
        config = function() require("custom.ui.images") end,
    },

    -- Keybinds
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        config = function() require("custom.keymaps.which-key") end,
        desc = "Keybinds",
    },

    -- Dashboard
    {
        'nvimdev/dashboard-nvim',
        event = 'VimEnter',
        config = function() require("custom.ui.dashboard") end,
        dependencies = { "nvim-tree/nvim-web-devicons" }
    },

    -- Buffers
    {
        "akinsho/bufferline.nvim",
        version = "*",
        config = function() require("custom.ui.status.bufferline") end,
        dependencies = 'nvim-tree/nvim-web-devicons',
    },

    {
        "nvim-lualine/lualine.nvim",
        config = function() require("custom.ui.status.lualine") end,
        dependencies = { "nvim-tree/nvim-web-devicons" }
    },

    {
        "utilyre/barbecue.nvim",
        name = "barbecue",
        version = "*",
        config = function()
            require("custom.ui.status.context")
        end,
        dependencies = {
            "SmiteshP/nvim-navic",
            "nvim-treesitter/nvim-treesitter",
            "nvim-treesitter/nvim-treesitter-context",
            "nvim-tree/nvim-web-devicons", -- optional dependency
        },
    },



    --- Syntax Highlighting & Contextual Hints ---
    {
        "nvim-treesitter/nvim-treesitter",
        run = function() vim.cmd [[:TSUpdate]] end,
        config = function() require("custom.highlighting.syntax") end,
        dependencies = "yioneko/nvim-yati"
    },

    -- Search
    {
        "kevinhwang91/nvim-hlslens",
        config = function() require("custom.highlighting.search") end,
        dependencies = "RRethy/vim-illuminate",
    },

    -- Colorizer
    {
        "NvChad/nvim-colorizer.lua",
        config = function() require("custom.highlighting.colors") end,
    },

    -- Comments
    {
        "folke/todo-comments.nvim",
        config = function() require("custom.highlighting.comments") end,
        dependencies = { "nvim-lua/plenary.nvim" },
    },

    -- Indentation Markers
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        config = function() require("custom.ui.indentation") end
    },

    -- Neoscroll
    {
        "karb94/neoscroll.nvim",
        config = function() require("custom.navigation.scrolling") end,
    },

    -- Telescope
    {
        "nvim-telescope/telescope.nvim",
        config = function() require("custom.navigation.telescope") end,
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope-project.nvim",
            "benfowler/telescope-luasnip.nvim",
        },
    },

    -- Flash
    {
        "folke/flash.nvim",
        event = "VeryLazy",
        config = function()
            require("custom.navigation.flash")
        end,
    },

    -- TreeSitterJoiner
    {
        "Wansmer/treesj",
        config = function() require("custom.behavior.join") end
    },

    -- Toggleterm
    {
        'akinsho/toggleterm.nvim',
        version = "*",
        event = "VeryLazy",
        config = function() require("custom.ui.terminal") end,
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
        config = function() require("custom.behavior.surround") end,
        dependencies = { "kylechui/nvim-surround", version = "*" },
    },

    -- LSP ---
    {
        "VonHeikemen/lsp-zero.nvim",
        branch = 'v4.x',
        dependencies = {
            -- LSP Support
            { 'neovim/nvim-lspconfig' },
            { 'williamboman/mason.nvim' },
            { 'williamboman/mason-lspconfig.nvim' },
            { "jay-babu/mason-nvim-dap.nvim" },
            { 'WhoIsSethDaniel/mason-tool-installer.nvim' },

            -- Autocompletion
            { 'hrsh7th/nvim-cmp' },
            { 'hrsh7th/cmp-buffer' },
            { 'hrsh7th/cmp-path' },
            { 'hrsh7th/cmp-cmdline' },
            { 'saadparwaiz1/cmp_luasnip', version = "2.*", build = "make install_jsregexp", dependencies = { "rafamadriz/friendly-snippets" },
 },
            { 'hrsh7th/cmp-nvim-lsp' },
            { 'hrsh7th/cmp-nvim-lua' },
            {
                'windwp/nvim-autopairs',
                event = "InsertEnter",
            },

            -- Formatter
            { 'lukas-reineke/lsp-format.nvim' },

            -- Snippets
            { 'L3MON4D3/LuaSnip' },
            { 'rafamadriz/friendly-snippets' },

            -- Specific Language Tweaks
            {
                "mfussenegger/nvim-jdtls",
                --lazy = false,
                config = function()
                    require("custom.lsp.languages.java")
                end
            },
        },
        config = function()
            require("custom.lsp")
        end,
    },

    -- Diagnostics
    {
        'folke/trouble.nvim',
        config = function()
            require('custom.lsp.trouble')
        end,
    },

    -- Debugger
    {
        "rcarriga/nvim-dap-ui",
        config = function() require("custom.lsp.dap") end,
        dependencies = {"mfussenegger/nvim-dap", "nvim-neotest/nvim-nio"}
    },

    -- Git stuff
    -- Neogit
    {
        "NeogitOrg/neogit",
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
        config = function() require("custom.git.signs") end
    },
}

-- Load lazy plugin manager
require("lazy").setup({
    spec = plugins,
    checker = { enabled = true },
})

vim.keymap.set("n", "<leader>L", "<cmd>Lazy<cr>", { desc = "Open Lazy", silent = true })

