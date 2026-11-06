local group = vim.api.nvim_create_augroup("custom", {})
local function autocmd(event, opts)
    opts.group = group
    vim.api.nvim_create_autocmd(event, opts)
end

-- Native treesitter: highlighting and folds for any filetype with an installed parser
autocmd("FileType", {
    desc = "Start treesitter",
    callback = function(ev)
        if pcall(vim.treesitter.start, ev.buf) and vim.api.nvim_get_current_buf() == ev.buf then
            vim.wo[0][0].foldmethod = "expr"
            vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
        end
    end,
})

-- Panels that shouldn't keep Neovim or a tab open once the code they sit next to is gone
local function is_panel(win)
    local filetype = vim.bo[vim.api.nvim_win_get_buf(win)].filetype
    return filetype:find("^snacks_picker") ~= nil
        or filetype:find("^dapui_") ~= nil
        or vim.tbl_contains({ "snacks_layout_box", "trouble", "dap-repl" }, filetype)
end

local function is_float(win)
    return vim.api.nvim_win_get_config(win).relative ~= ""
end

autocmd("QuitPre", {
    desc = "Close panels when quitting the last code window",
    callback = function()
        local current = vim.api.nvim_get_current_win()
        if is_float(current) or is_panel(current) then
            return
        end

        local panels = {}
        for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
            if is_panel(win) then
                table.insert(panels, win)
            elseif win ~= current and not is_float(win) then
                return -- Another code window remains, so this :quit only closes the current one
            end
        end
        for _, win in ipairs(panels) do
            -- Closing a layout's root also closes its children
            if vim.api.nvim_win_is_valid(win) then
                pcall(vim.api.nvim_win_close, win, true)
            end
        end
    end,
})

autocmd("TextYankPost", {
    desc = "Highlight yanked text",
    callback = function() vim.hl.on_yank({ timeout = 150 }) end,
})

autocmd("BufReadPost", {
    desc = "Restore the last cursor position",
    callback = function(ev)
        local mark = vim.api.nvim_buf_get_mark(ev.buf, '"')
        if mark[1] > 0 and mark[1] <= vim.api.nvim_buf_line_count(ev.buf)
            and vim.bo[ev.buf].filetype ~= "gitcommit" then
            pcall(vim.api.nvim_win_set_cursor, 0, mark)
        end
    end,
})

autocmd("VimResized", {
    desc = "Keep splits balanced",
    callback = function() vim.cmd.tabdo("wincmd =") end,
})

autocmd("BufWritePre", {
    desc = "Create missing parent directories",
    callback = function(ev)
        if not ev.match:match("^%w+://") then
            vim.fn.mkdir(vim.fn.fnamemodify(ev.match, ":p:h"), "p")
        end
    end,
})
