-- Test runner. An adapter joins only when its toolchain exists. Adapters find tests through
-- treesitter, with the parsers custom/tools.lua installs for each language.
local function has(bin)
    return vim.fn.executable(bin) == 1
end

local function adapters()
    local list = {}
    if has("python3") then
        table.insert(list, require("neotest-python")({ dap = { justMyCode = true } }))
    end
    if has("ctest") then
        table.insert(list, require("neotest-ctest").setup({}))
    end
    if has("dotnet") then
        table.insert(list, require("neotest-vstest"))
    end
    if has("java") then
        table.insert(list, require("neotest-java")({}))
    end
    if has("node") then
        table.insert(list, require("neotest-vitest"))
        table.insert(list, require("neotest-jest")({}))
    end
    return list
end

local function neotest(fn)
    return function() fn(require("neotest")) end
end

-- debugpy would also stop where a failing test's exception reaches pytest and neotest's
-- runner, so a test debug session only stops on breakpoints. Script debugging keeps its
-- exception stops, the setting is restored once the session is configured.
local function debug_nearest(t)
    require("custom.pack").load("nvim-dap")
    local dap = require("dap")
    local previous = dap.defaults.python.exception_breakpoints
    dap.defaults.python.exception_breakpoints = {}
    dap.listeners.after.configurationDone["custom.neotest"] = function()
        dap.defaults.python.exception_breakpoints = previous
        dap.listeners.after.configurationDone["custom.neotest"] = nil
    end
    t.run.run({ strategy = "dap" })
end

return {
    { "nvim-neotest/neotest-python" },
    { "orjangj/neotest-ctest" },
    { "nsidorenco/neotest-vstest" },
    { "rcasia/neotest-java" },
    { "marilari88/neotest-vitest" },
    { "nvim-neotest/neotest-jest" },
    {
        "nvim-neotest/neotest",
        cmd = "Neotest",
        deps = {
            "nvim-nio", "plenary.nvim",
            "neotest-python", "neotest-ctest", "neotest-vstest", "neotest-java", "neotest-vitest", "neotest-jest",
        },
        keys = {
            { "<leader>rr", neotest(function(t) t.run.run() end), desc = "Run nearest test" },
            { "<leader>rf", neotest(function(t) t.run.run(vim.fn.expand("%")) end), desc = "Run file" },
            { "<leader>ra", neotest(function(t) t.run.run(vim.fn.getcwd()) end), desc = "Run all tests" },
            { "<leader>rl", neotest(function(t) t.run.run_last() end), desc = "Run last" },
            { "<leader>rd", neotest(debug_nearest), desc = "Debug nearest test" },
            { "<leader>rx", neotest(function(t) t.run.stop() end), desc = "Stop" },
            { "<leader>rs", neotest(function(t) t.summary.toggle() end), desc = "Test summary" },
            {
                "<leader>ro",
                neotest(function(t) t.output.open({ enter = true, auto_close = true }) end),
                desc = "Test output",
            },
            { "<leader>rO", neotest(function(t) t.output_panel.toggle() end), desc = "Output panel" },
            { "<leader>rw", neotest(function(t) t.watch.toggle(vim.fn.expand("%")) end), desc = "Watch file" },
            { "]t", neotest(function(t) t.jump.next({ status = "failed" }) end), desc = "Next failed test" },
            { "[t", neotest(function(t) t.jump.prev({ status = "failed" }) end), desc = "Previous failed test" },
        },
        config = function()
            require("neotest").setup({
                adapters = adapters(),
                status = { virtual_text = true },
                output = { open_on_run = false },
                quickfix = { enabled = false },
            })
        end,
    },
}
