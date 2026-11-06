local function map(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { desc = desc, silent = true })
end

-- Quick actions
map("n", "<leader>Q", "<cmd>qa!<cr>", "Quick exit")
map("n", "<leader>W", "<cmd>w<cr>", "Quick save")
map("n", "<leader>ss", "<cmd>sort<cr>", "Quick sort")
map("n", "<leader>sS", "<cmd>sort!<cr>", "Quick sort (reverse)")
map("x", "<leader>ss", ":sort<cr>", "Sort selection")
map("x", "<leader>sS", ":sort!<cr>", "Sort selection (reverse)")
map("n", "<leader>ch", "<cmd>nohlsearch<cr>", "Clear highlighting")

-- Buffers
map({ "n", "x" }, "<c-left>", "<cmd>bprevious<cr>", "Previous buffer")
map({ "n", "x" }, "<c-right>", "<cmd>bnext<cr>", "Next buffer")
map("n", "<c-up>", function() Snacks.bufdelete() end, "Close buffer")

-- Plugins and tools
map("n", "<leader>pl", function() vim.pack.update(nil, { offline = true }) end, "Plugin status")
map("n", "<leader>pu", function() vim.pack.update() end, "Update plugins")
map("n", "<leader>ph", "<cmd>checkhealth custom<cr>", "Toolchain health")

-- Toggles
map("n", "<leader>uf", function()
    vim.g.format_on_save = not vim.g.format_on_save
    vim.notify("Format on save: " .. (vim.g.format_on_save and "on" or "off"))
end, "Toggle format on save")
map("n", "<leader>uh", function()
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = 0 }), { bufnr = 0 })
end, "Toggle inlay hints")
map("n", "<leader>ul", function()
    vim.lsp.codelens.enable(not vim.lsp.codelens.is_enabled({ bufnr = 0 }), { bufnr = 0 })
end, "Toggle code lens")
map("n", "<leader>ud", function()
    vim.diagnostic.enable(not vim.diagnostic.is_enabled({ bufnr = 0 }), { bufnr = 0 })
end, "Toggle diagnostics")
map("n", "<leader>uw", "<cmd>set wrap!<cr>", "Toggle wrap")
