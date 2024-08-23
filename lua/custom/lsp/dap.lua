local dap = require("dap")

vim.keymap.set("n", "<leader>Db", function() dap.toggle_breakpoint() end, { desc = "Toggle breakpoint", silent = true })
vim.keymap.set("n", "<leader>Dc", function() dap.continue() end, { desc = "Resume execution", silent = true })
vim.keymap.set("n", "<leader>Ds", function() dap.step_over() end, { desc = "Step over", silent = true })

-- UI
local ui = require("dapui")
ui.setup()
vim.keymap.set("n", "<leader>DD", function() ui.toggle() end, { desc = "Toggle DAP UI", silent = true })
