local ns = require('neoscroll')
ns.setup({ mappings = {}, })

local keymap = {
    ["<c-u>"] = { callback = function() ns.ctrl_u({ duration = 250 }) end, desc = "Scroll up" };
    ["<c-d>"] = { callback = function() ns.ctrl_d({ duration = 250 }) end, desc = "Scroll down" };
    ["zt"]    = { callback = function() ns.zt({ half_win_duration = 250 }) end, desc = "Top current line" };
    ["zz"]    = { callback = function() ns.zz({ half_win_duration = 250 }) end, desc = "Center current line" };
    ["zb"]    = { callback = function() ns.zb({ half_win_duration = 250 }) end, desc = "Bottom current line" };
}
local modes = { 'n', 'v', 'x' }
for key, func in pairs(keymap) do
    vim.keymap.set(modes, key, func.callback, { desc = func.desc, silent = true })
end

