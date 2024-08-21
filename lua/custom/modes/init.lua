-- Sets the global variables used in other modules
local tty_env = os.getenv("DISPLAY")
if tty_env == nil or tty_env == "" then
    vim.g.tty = true
else
    vim.g.tty = false
    local neovide_env = vim.fn.exists('g:neovide') ~= 0
    if neovide_env then
        vim.g.neovide = true
    else
        vim.g.neovide = false
    end
end

