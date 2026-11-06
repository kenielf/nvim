-- Thin lazy-loading layer on top of the native vim.pack.
--
-- vim.pack installs and updates plugins, everything is registered as an optional
-- package and :packadd-ed on demand. Spec fields:
--   [1]      "owner/repo"
--   name     directory name, defaults to the repository name
--   version  branch, tag or vim.version.range()
--   eager    load during startup
--   event    autocmd event(s) or "VeryLazy" (just after the first redraw)
--   ft       filetype(s)
--   cmd      user command(s)
--   keys     { lhs, rhs, desc = "", mode = "n" }, rhs is a function or an ex command
--   deps     plugin names to load first
--   cond     function, the plugin is installed but never loaded if it returns false
--   build    ex command or function, ran after install and update
--   config   function, ran after loading
-- A spec without any trigger is a library, loaded only through deps or M.load().
local M = {}

local specs = {}
local loaded = {}

local function name_of(spec)
    return spec.name or spec[1]:match("[^/]+$")
end

local function enabled(spec)
    return not spec.cond or spec.cond()
end

function M.load(name)
    local spec = specs[name]
    if not spec then
        error("unknown plugin: " .. name)
    end
    if loaded[name] or not enabled(spec) then
        return
    end
    loaded[name] = true
    for _, dep in ipairs(spec.deps or {}) do
        M.load(dep)
    end
    vim.cmd.packadd(name)
    if spec.config then
        local ok, err = xpcall(spec.config, debug.traceback)
        if not ok then
            vim.notify(("Failed to configure %s:\n%s"):format(name, err), vim.log.levels.ERROR)
        end
    end
end

local function list(value)
    return type(value) == "table" and value or { value }
end

local function setup_keys(name, spec)
    for _, key in ipairs(spec.keys or {}) do
        local lhs, rhs = key[1], key[2]
        vim.keymap.set(key.mode or "n", lhs, function()
            M.load(name)
            if type(rhs) == "function" then
                rhs()
            else
                vim.cmd(rhs)
            end
        end, { desc = key.desc, silent = true })
    end
end

local function setup_cmds(name, spec)
    for _, cmd in ipairs(list(spec.cmd or {})) do
        vim.api.nvim_create_user_command(cmd, function(args)
            vim.api.nvim_del_user_command(cmd)
            M.load(name)
            vim.cmd({
                cmd = cmd,
                args = args.fargs,
                bang = args.bang,
                range = args.range > 0 and { args.line1, args.line2 } or nil,
                mods = args.smods,
            })
        end, {
            nargs = "*",
            bang = true,
            range = true,
            complete = function(_, line)
                vim.api.nvim_del_user_command(cmd)
                M.load(name)
                return vim.fn.getcompletion(line, "cmdline")
            end,
        })
    end
end

local function setup_events(name, spec)
    for _, event in ipairs(list(spec.event or {})) do
        vim.api.nvim_create_autocmd(event == "VeryLazy" and "User" or event, {
            pattern = event == "VeryLazy" and "VeryLazy" or nil,
            once = true,
            callback = function() M.load(name) end,
        })
    end
    if spec.ft then
        vim.api.nvim_create_autocmd("FileType", {
            pattern = list(spec.ft),
            once = true,
            callback = function() M.load(name) end,
        })
    end
end

local function setup_build()
    vim.api.nvim_create_autocmd("PackChanged", {
        callback = function(ev)
            local spec = specs[ev.data.spec.name]
            if not spec or not spec.build or ev.data.kind == "delete" or not enabled(spec) then
                return
            end
            vim.schedule(function()
                M.load(ev.data.spec.name)
                local ok, err = pcall(function()
                    if type(spec.build) == "function" then
                        spec.build()
                    else
                        vim.cmd(spec.build)
                    end
                end)
                if not ok then
                    vim.notify(("Build of %s failed:\n%s"):format(ev.data.spec.name, err), vim.log.levels.WARN)
                end
            end)
        end,
    })
end

---@param groups table[] Lists of plugin specs
function M.setup(groups)
    local pack_specs = {}
    for _, group in ipairs(groups) do
        for _, spec in ipairs(group) do
            local name = name_of(spec)
            specs[name] = spec
            table.insert(pack_specs, {
                src = "https://github.com/" .. spec[1],
                name = name,
                version = spec.version,
            })
        end
    end

    setup_build()
    vim.pack.add(pack_specs, { confirm = false, load = function() end })

    for name, spec in pairs(specs) do
        if enabled(spec) then
            setup_keys(name, spec)
            setup_cmds(name, spec)
            setup_events(name, spec)
        end
    end

    -- Eager plugins keep their declaration order, the colorscheme comes first
    for _, group in ipairs(groups) do
        for _, spec in ipairs(group) do
            if spec.eager then
                M.load(name_of(spec))
            end
        end
    end

    vim.api.nvim_create_autocmd("VimEnter", {
        once = true,
        callback = function()
            vim.schedule(function()
                vim.api.nvim_exec_autocmds("User", { pattern = "VeryLazy", modeline = false })
            end)
        end,
    })

    vim.api.nvim_create_user_command("PackClean", function()
        local unused = vim.tbl_map(function(plugin)
            return plugin.spec.name
        end, vim.tbl_filter(function(plugin)
            return not plugin.active
        end, vim.pack.get()))
        if #unused == 0 then
            vim.notify("No unused plugins")
        elseif vim.fn.confirm("Delete " .. table.concat(unused, ", ") .. "?", "&Yes\n&No", 2) == 1 then
            vim.pack.del(unused)
        end
    end, { desc = "Delete plugins no longer in the config" })
end

return M
