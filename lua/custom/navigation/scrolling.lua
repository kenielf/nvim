local ns = require('neoscroll')
ns.setup({ mappings = {}, })

local keymap = {
    ["<C-u>"] = function() ns.ctrl_u({ duration = 250 }) end;
    ["<C-d>"] = function() ns.ctrl_d({ duration = 250 }) end;
    ["zt"]    = function() ns.zt({ half_win_duration = 250 }) end;
    ["zz"]    = function() ns.zz({ half_win_duration = 250 }) end;
    ["zb"]    = function() ns.zb({ half_win_duration = 250 }) end;
}
local modes = { 'n', 'v', 'x' }
for key, func in pairs(keymap) do
    vim.keymap.set(modes, key, func)
end

