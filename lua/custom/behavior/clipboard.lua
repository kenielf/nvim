-- Use system clipboard (scheduled for performance)
vim.schedule(function()
    vim.opt.clipboard = "unnamedplus"
end)
