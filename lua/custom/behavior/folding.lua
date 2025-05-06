-- Folding Options
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldenable = false

-- Update folds on read
vim.api.nvim_create_autocmd("User", {
    pattern = "TreesitterFold",  -- Custom event defined below
    callback = function() vim.cmd("normal! zx|zR") end
})

local compute_folds = function(args)
    local tsp = require("nvim-treesitter.parsers")
    local buf = args.buf
    local lang = tsp.get_buf_lang(buf)
    if tsp.has_parser(lang) then
        vim.defer_fn(function()
            vim.api.nvim_exec_autocmds("User", { pattern = "TreesitterFold" })
        end, 50)
    end
end

vim.api.nvim_create_autocmd("BufEnter", {
    callback = compute_folds
})

