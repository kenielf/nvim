-- Debug adapters, installed by custom/tools.lua. Java is set up by ftplugin/java.lua.
-- nvim-dap also reads .vscode/launch.json, which takes care of project-specific launches.
local M = {}

-- Reports a missing adapter clearly instead of nvim-dap's generic spawn error
local function adapter(bin, definition)
    return function(callback)
        if vim.fn.executable(bin) == 0 then
            vim.notify(("Debug adapter `%s` not found. Try :ToolsInstall, see :checkhealth custom."):format(bin),
                vim.log.levels.ERROR)
            return
        end
        callback(definition)
    end
end

local function ask_program(start)
    return function()
        return vim.fn.input("Executable: ", vim.fn.getcwd() .. "/" .. start, "file")
    end
end

local function ask_args()
    return require("dap.utils").splitstr(vim.fn.input("Arguments: "))
end

local function python_path()
    if vim.env.VIRTUAL_ENV then
        return vim.env.VIRTUAL_ENV .. "/bin/python"
    end
    for _, dir in ipairs({ ".venv", "venv" }) do
        local python = vim.fn.getcwd() .. "/" .. dir .. "/bin/python"
        if vim.fn.executable(python) == 1 then
            return python
        end
    end
    return "python3"
end

local function configure(dap)
    -- C, C++, Rust
    dap.adapters.codelldb = adapter("codelldb", { type = "executable", command = "codelldb" })
    local function native(start)
        return {
            {
                name = "Launch executable",
                type = "codelldb",
                request = "launch",
                program = ask_program(start),
                cwd = "${workspaceFolder}",
            },
            {
                name = "Launch executable with arguments",
                type = "codelldb",
                request = "launch",
                program = ask_program(start),
                args = ask_args,
                cwd = "${workspaceFolder}",
            },
            {
                name = "Attach to process",
                type = "codelldb",
                request = "attach",
                pid = function() return require("dap.utils").pick_process() end,
            },
        }
    end
    dap.configurations.c = native("")
    dap.configurations.cpp = native("")
    dap.configurations.rust = native("target/debug/")

    -- C#
    dap.adapters.coreclr = adapter("netcoredbg", {
        type = "executable",
        command = "netcoredbg",
        args = { "--interpreter=vscode" },
    })
    dap.configurations.cs = {
        {
            name = "Launch assembly",
            type = "coreclr",
            request = "launch",
            program = ask_program("bin/Debug/"),
            cwd = "${workspaceFolder}",
        },
        {
            name = "Attach to process",
            type = "coreclr",
            request = "attach",
            processId = function() return require("dap.utils").pick_process() end,
        },
    }

    -- Python
    dap.adapters.python = adapter("debugpy-adapter", { type = "executable", command = "debugpy-adapter" })
    dap.configurations.python = {
        {
            name = "Launch file",
            type = "python",
            request = "launch",
            program = "${file}",
            cwd = "${workspaceFolder}",
            pythonPath = python_path,
            console = "integratedTerminal",
        },
        {
            name = "Launch file with arguments",
            type = "python",
            request = "launch",
            program = "${file}",
            args = ask_args,
            cwd = "${workspaceFolder}",
            pythonPath = python_path,
            console = "integratedTerminal",
        },
    }

    -- Shell
    local bashdb = vim.env.MASON .. "/packages/bash-debug-adapter/extension/bashdb_dir"
    dap.adapters.bashdb = adapter("bash-debug-adapter", { type = "executable", command = "bash-debug-adapter" })
    local shell = {
        {
            name = "Launch script",
            type = "bashdb",
            request = "launch",
            program = "${file}",
            file = "${file}",
            cwd = "${workspaceFolder}",
            args = {},
            argsString = "",
            env = {},
            pathBash = "bash",
            pathBashdb = bashdb .. "/bashdb",
            pathBashdbLib = bashdb,
            pathCat = "cat",
            pathMkfifo = "mkfifo",
            pathPkill = "pkill",
            terminalKind = "integrated",
        },
    }
    dap.configurations.sh = shell
    dap.configurations.bash = shell

    -- Perl
    dap.adapters.perl = adapter("perl-debug-adapter", { type = "executable", command = "perl-debug-adapter" })
    dap.configurations.perl = {
        {
            name = "Launch script",
            type = "perl",
            request = "launch",
            program = "${file}",
            cwd = "${workspaceFolder}",
        },
    }

    -- Ansible, through the ansibug venv from custom/tools.lua
    dap.adapters.ansible = function(callback)
        local python = require("custom.tools").ansibug_python
        if vim.fn.executable(python) == 0 then
            vim.notify("ansibug isn't installed. Run :ToolsInstall, it needs `uv` and `ansible`.",
                vim.log.levels.ERROR)
            return
        end
        callback({ type = "executable", command = python, args = { "-m", "ansibug", "dap" } })
    end
    dap.configurations["yaml.ansible"] = {
        {
            name = "Run playbook",
            type = "ansible",
            request = "launch",
            playbook = "${file}",
        },
    }

    -- JavaScript and TypeScript
    local js_adapter = adapter("js-debug-adapter", {
        type = "server",
        host = "localhost",
        port = "${port}",
        executable = { command = "js-debug-adapter", args = { "${port}" } },
    })
    dap.adapters["pwa-node"] = js_adapter
    dap.adapters["pwa-chrome"] = js_adapter
    local web = {
        {
            name = "Launch file (Node)",
            type = "pwa-node",
            request = "launch",
            program = "${file}",
            cwd = "${workspaceFolder}",
        },
        {
            name = "Attach to process (Node)",
            type = "pwa-node",
            request = "attach",
            processId = function() return require("dap.utils").pick_process() end,
            cwd = "${workspaceFolder}",
        },
        {
            name = "Launch Chrome",
            type = "pwa-chrome",
            request = "launch",
            url = function() return vim.fn.input("URL: ", "http://localhost:3000") end,
            webRoot = "${workspaceFolder}",
        },
    }
    for _, ft in ipairs({ "javascript", "typescript", "javascriptreact", "typescriptreact" }) do
        dap.configurations[ft] = web
    end
end

local function setup_ui(dap)
    local ui = require("dapui")
    ui.setup()
    require("nvim-dap-virtual-text").setup({ commented = true })

    dap.listeners.before.attach.custom = ui.open
    dap.listeners.before.launch.custom = ui.open
    dap.listeners.before.event_terminated.custom = ui.close
    dap.listeners.before.event_exited.custom = ui.close

    local signs = {
        DapBreakpoint = { "●", "DiagnosticError" },
        DapBreakpointCondition = { "◆", "DiagnosticWarn" },
        DapBreakpointRejected = { "○", "DiagnosticHint" },
        DapLogPoint = { "◉", "DiagnosticInfo" },
        DapStopped = { "▶", "DiagnosticOk" },
    }
    for name, sign in pairs(signs) do
        vim.fn.sign_define(name, { text = sign[1], texthl = sign[2], linehl = "", numhl = "" })
    end
end

function M.setup()
    local dap = require("dap")
    configure(dap)
    setup_ui(dap)
end

return M
