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
        config = function()
            require("custom.ui.noice")
            require("custom.ui.visual-markers")
        end,
        dependencies = {
            "MunifTanjim/nui.nvim",
            "rcarriga/nvim-notify",
        },
    }
}

-- Load lazy plugin manager
require("lazy").setup({
    spec = plugins,
    checker = { enabled = true },
})

vim.keymap.set("n", "<leader>L", "<cmd>Lazy<cr>", { desc = "Open Lazy", silent = true })
