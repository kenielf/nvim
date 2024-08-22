-- Enable listchars only on valid buffers
vim.api.nvim_create_autocmd('BufEnter', { callback = function()
    if vim.bo.filetype ~= "dashboard" and vim.bo.filetype ~= "neo-tree" then
        -- Line numbering
        vim.opt.number = true
        vim.opt.relativenumber = true

        -- Cursor column
        vim.opt.colorcolumn = "80"

        -- Cursor line
        vim.opt.cursorline = true

        -- Character markers
        vim.opt.list = true
        vim.opt.listchars:append "space:⋅"
        vim.opt.listchars:append "eol:↴"
    end
end })

