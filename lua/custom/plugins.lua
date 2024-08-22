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

}

-- Load lazy plugin manager
require("lazy").setup({
    spec = plugins,
    checker = { enabled = true },
})

vim.keymap.set("n", "<leader>L", "<cmd>Lazy<cr>", { desc = "Open Lazy", silent = true })

