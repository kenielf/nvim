local M = {}
-- Start Module

-- Get all buffers
M.list_active_bufs = function()
    local buffers = vim.api.nvim_list_bufs()
    local active_buffers = {}
    for _, buffer in pairs(buffers) do
        local valid = vim.api.nvim_buf_is_valid(buffer)
        local listed = vim.api.nvim_get_option_value('buflisted', {buf=buffer})
        if valid and listed then
            table.insert(active_buffers, buffer)
        end
    end
    return active_buffers
end

-- Smartly delete buffers
M.smart_bufdelete = function()
    local active_buffers = M.list_active_bufs()
    if #active_buffers <= 1 then
        local bufname = vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf())
        if not (string.len(bufname) < 1) then
            vim.cmd [[ silent! enew | bd# ]]
        end
    else
        vim.cmd [[ silent! bp | bd# ]]
    end
end

-- End module
return M
