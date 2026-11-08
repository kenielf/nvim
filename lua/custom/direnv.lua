-- Loads the .envrc of the working directory, like direnv's shell hook does for the shell.
-- direnv reports what to set and unset as JSON, and keeps its own state in DIRENV_* variables,
-- so leaving a project restores the environment Neovim had before entering it.
-- Language servers keep the environment they started with, :lsp restart picks up a new one.
local M = {}

local blocked = {} -- .envrc files already reported as blocked

local function apply(changes)
    local loaded = false
    for name, value in pairs(changes) do
        vim.env[name] = value ~= vim.NIL and value or nil
        loaded = loaded or not name:find("^DIRENV_")
    end
    if loaded then
        vim.cmd.redrawstatus()
        vim.api.nvim_exec_autocmds("User", { pattern = "DirenvLoaded", modeline = false })
    end
end

function M.load()
    vim.system({ "direnv", "export", "json" }, { text = true, cwd = vim.fn.getcwd() }, vim.schedule_wrap(function(result)
        local envrc = (result.stderr or ""):match("direnv: error (%S+) is blocked")
        if envrc and not blocked[envrc] then
            blocked[envrc] = true
            vim.notify(("%s is blocked, run :DirenvAllow to load it"):format(vim.fn.fnamemodify(envrc, ":~")),
                vim.log.levels.WARN)
        end
        local ok, changes = pcall(vim.json.decode, result.stdout or "")
        if ok and type(changes) == "table" then
            apply(changes)
        end
    end))
end

function M.setup()
    if vim.fn.executable("direnv") == 0 then
        return
    end
    local group = vim.api.nvim_create_augroup("custom.direnv", {})
    vim.api.nvim_create_autocmd({ "VimEnter", "DirChanged" }, { group = group, callback = M.load })
    vim.api.nvim_create_autocmd("BufWritePost", {
        group = group,
        pattern = ".envrc",
        desc = "An edited .envrc is blocked until allowed, an allowed one reloads",
        callback = M.load,
    })
    if vim.v.vim_did_enter == 1 then
        M.load()
    end

    vim.api.nvim_create_user_command("DirenvAllow", function()
        vim.system({ "direnv", "allow" }, { cwd = vim.fn.getcwd() }, vim.schedule_wrap(function(result)
            if result.code ~= 0 then
                vim.notify(vim.trim(result.stderr or "direnv allow failed"), vim.log.levels.ERROR)
                return
            end
            blocked = {}
            M.load()
        end))
    end, { desc = "Allow the working directory's .envrc and load it" })
    vim.api.nvim_create_user_command("DirenvReload", M.load, { desc = "Reload the working directory's .envrc" })
end

return M
