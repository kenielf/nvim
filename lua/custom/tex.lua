-- LaTeX: vimtex compiles (latexmk), views and adds motions, text objects and the table of
-- contents, texlab completes and checks (see after/lsp/texlab.lua). vimtex's mappings live
-- under <localleader>l: \ll compile continuously, \lv view, \lt contents, \le errors, \lc clean.
local M = {}

local synctex
-- zathura only links libsynctex when it's built with it
function M.zathura_synctex()
    if synctex == nil then
        local result = vim.fn.executable("ldd") == 1 and vim.system({ "ldd", vim.fn.exepath("zathura") }, { text = true }):wait()
        synctex = not result or result.code ~= 0 or result.stdout:find("libsynctex") ~= nil
    end
    return synctex
end

function M.setup()
    if vim.fn.executable("zathura") == 1 then
        if M.zathura_synctex() then
            -- Jumps to the cursor's spot in the PDF, Ctrl+click in zathura jumps back
            vim.g.vimtex_view_method = "zathura"
        else
            -- Without SyncTeX, zathura only shows the PDF, it reloads on its own after a build
            vim.g.vimtex_view_method = "general"
            vim.g.vimtex_view_general_viewer = "zathura"
            vim.g.vimtex_view_general_options = "@pdf"
        end
    end
    vim.g.vimtex_complete_enabled = 0 -- texlab completes
    vim.g.vimtex_quickfix_mode = 2 -- errors open the quickfix list without taking the cursor
    vim.g.vimtex_quickfix_open_on_warning = 0
end

return M
