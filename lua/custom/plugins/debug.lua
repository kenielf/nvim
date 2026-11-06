local function dap(method, ...)
    local args = { ... }
    return function() require("dap")[method](unpack(args)) end
end

return {
    { "nvim-neotest/nvim-nio" },
    { "rcarriga/nvim-dap-ui", deps = { "nvim-nio" } },
    { "theHamsta/nvim-dap-virtual-text" },
    {
        "mfussenegger/nvim-dap",
        cmd = { "DapContinue", "DapToggleBreakpoint", "DapNew" },
        deps = { "nvim-dap-ui", "nvim-dap-virtual-text" },
        keys = {
            { "<F5>", dap("continue"), desc = "Start or continue" },
            { "<F9>", dap("toggle_breakpoint"), desc = "Toggle breakpoint" },
            { "<F10>", dap("step_over"), desc = "Step over" },
            { "<F11>", dap("step_into"), desc = "Step into" },
            { "<F12>", dap("step_out"), desc = "Step out" },
            { "<leader>Db", dap("toggle_breakpoint"), desc = "Toggle breakpoint" },
            {
                "<leader>DB",
                function() require("dap").set_breakpoint(vim.fn.input("Condition: ")) end,
                desc = "Conditional breakpoint",
            },
            { "<leader>Dc", dap("continue"), desc = "Start or continue" },
            { "<leader>Ds", dap("step_over"), desc = "Step over" },
            { "<leader>Di", dap("step_into"), desc = "Step into" },
            { "<leader>Do", dap("step_out"), desc = "Step out" },
            { "<leader>Dr", dap("run_last"), desc = "Run last" },
            { "<leader>Dt", dap("terminate"), desc = "Terminate" },
            { "<leader>DD", function() require("dapui").toggle() end, desc = "Toggle debugger interface" },
            {
                "<leader>De",
                function() require("dapui").eval() end,
                mode = { "n", "x" },
                desc = "Evaluate",
            },
        },
        config = function() require("custom.debug").setup() end,
    },
}
