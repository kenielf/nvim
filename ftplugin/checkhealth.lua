-- Neovim keeps the report as a listed buffer after `q` closes its tab, it'd linger in the bufferline
vim.bo.buflisted = false
vim.bo.bufhidden = "wipe"
