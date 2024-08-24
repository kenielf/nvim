local dap = require("dap")

vim.keymap.set("n", "<leader><s-d>b", dap.toggle_breakpoint, { desc = "Toggle breakpoint", silent = true })
vim.keymap.set("n", "<leader><s-d>c", dap.continue, { desc = "Resume execution", silent = true })
vim.keymap.set("n", "<leader><s-d>s", dap.step_over, { desc = "Step over", silent = true })

-- UI
local ui = require("dapui")
ui.setup()
vim.keymap.set("n", "<leader><s-d><s-d>", ui.toggle, { desc = "Toggle debugger interface", silent = true })
