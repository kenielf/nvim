local backend
local term = os.getenv("TERM")
if term == "xterm-kitty" then
    backend = "kitty"
else
    -- Make sure that ueberzug is installed if terminal is not kitty
    local ueberzug = vim.fn.exepath("ueberzug")
    if ueberzug == "" then
        os.exit(1)
    end

    -- Set "ueberzug" as backend
    backend = "ueberzug"
end

-- Configure image previews
require("image").setup({
    backend = backend,
})

