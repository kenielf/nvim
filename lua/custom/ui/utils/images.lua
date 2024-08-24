local backend
local term = os.getenv("TERM")
if term == "xterm-kitty" then
    backend = "kitty"
else
    -- Make sure that ueberzug is installed if terminal is not kitty
    local ueberzug = vim.fn.exepath("ueberzug")
    if ueberzug == "" then
        return
    end

    -- Set "ueberzug" as backend
    backend = "ueberzug"
end

-- Make sure that this is a terminal
if not vim.g.tty and vim.g.neovide then
    return
end

-- Configure image previews
require("image").setup({
    backend = backend,
})
