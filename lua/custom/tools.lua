-- Installs language tools and treesitter parsers, tolerating a machine that lacks
-- part of the toolchain: anything that can't be installed yet is skipped and reported.
local M = {}

local stamp_file = vim.fn.stdpath("state") .. "/custom-tools.stamp"

-- What Mason needs on the system to install a package from each source
local source_requirements = {
    npm = "npm",
    pypi = "python3",
    nuget = "dotnet",
    cargo = "cargo",
    golang = "go",
    gem = "gem",
    luarocks = "luarocks",
    composer = "composer",
    opam = "opam",
}

local function has(bin)
    return vim.fn.executable(bin) == 1
end

-- ansibug runs playbooks with the Python it's installed in, so it gets a venv that also
-- sees the system Python's packages, where Ansible and its collections are installed
M.ansibug_python = vim.fn.stdpath("data") .. "/ansibug/bin/python"

-- neotest-java runs tests with JUnit's console launcher, the version it pins and checks
---@return { version: string, sha256: string, path: string }
function M.junit_jar()
    require("custom.pack").load("neotest-java")
    local defaults = require("neotest-java.default_config")
    local pinned = defaults.default_junit_jar_version
    return { version = pinned.version, sha256 = pinned.sha256, path = defaults.default_junit_jar_filepath:to_string() }
end

---@return string[] packages, string[] parsers, table<string, string> skipped package -> reason
local function wanted()
    local packages, parsers, skipped = {}, {}, {}
    for _, lang in ipairs(require("custom.languages")) do
        vim.list_extend(parsers, lang.parsers or {})
        local missing = vim.tbl_filter(function(bin) return not has(bin) end, lang.requires or {})
        for _, tool in ipairs(lang.tools or {}) do
            if #missing > 0 then
                skipped[tool] = table.concat(missing, ", ")
            elseif not vim.tbl_contains(packages, tool) then
                table.insert(packages, tool)
            end
        end
    end
    return packages, parsers, skipped
end

-- Changes when the tool list changes or a prerequisite appears, so a newly installed
-- JDK or .NET SDK is picked up on the next start without checking everything each time
local function fingerprint()
    local packages, parsers, skipped = wanted()
    local parts = vim.list_extend(vim.list_extend({}, packages), parsers)
    for name in pairs(skipped) do
        table.insert(parts, "skipped:" .. name)
    end
    for _, bin in pairs(source_requirements) do
        table.insert(parts, bin .. "=" .. tostring(has(bin)))
    end
    table.insert(parts, "ansibug=" .. tostring(has("ansible") and has("uv") and vim.uv.fs_stat(M.ansibug_python) ~= nil))
    table.insert(parts, "junit=" .. tostring(has("java") and vim.uv.fs_stat(M.junit_jar().path) ~= nil))
    table.sort(parts)
    return vim.fn.sha256(table.concat(parts, ","))
end

local function read_stamp()
    local file = io.open(stamp_file, "r")
    if not file then
        return nil
    end
    local stamp = file:read("*a")
    file:close()
    return stamp
end

local function write_stamp()
    vim.fn.mkdir(vim.fn.fnamemodify(stamp_file, ":h"), "p")
    local file = io.open(stamp_file, "w")
    if file then
        file:write(fingerprint())
        file:close()
    end
end

function M.present(pkg)
    if pkg:is_installed() then
        return true
    end
    return vim.iter(vim.tbl_keys(pkg.spec.bin or {})):any(has)
end

local function install_parsers(parsers, done)
    if not has("tree-sitter") then
        vim.notify("tree-sitter CLI missing, parsers not installed", vim.log.levels.WARN)
        return done(false)
    end
    if not (has("cc") or has("gcc") or has("clang")) then
        vim.notify("No C compiler found, parsers not installed", vim.log.levels.WARN)
        return done(false)
    end
    require("custom.pack").load("nvim-treesitter")
    local ts = require("nvim-treesitter")
    ts.install(parsers, { summary = true }):await(function()
        vim.schedule(function()
            local installed = ts.get_installed("parsers")
            local failed = vim.tbl_filter(function(parser)
                return not vim.tbl_contains(installed, parser)
            end, parsers)
            if #failed > 0 then
                vim.notify("Parsers not installed: " .. table.concat(failed, ", "), vim.log.levels.WARN)
            end
            done(#failed == 0)
        end)
    end)
end

---@param failures string[]
local function install_ansibug(failures, done)
    if not (has("ansible") and has("uv")) or vim.uv.fs_stat(M.ansibug_python) then
        return done()
    end
    local venv = vim.fs.dirname(vim.fs.dirname(M.ansibug_python))
    local function fail(result)
        table.insert(failures, "ansibug: " .. vim.trim(result.stderr or ""))
        vim.fn.delete(venv, "rf")
        done()
    end
    vim.system({ "uv", "venv", "--system-site-packages", "--python", vim.fn.exepath("python3"), venv }, {},
        vim.schedule_wrap(function(created)
            if created.code ~= 0 then
                return fail(created)
            end
            vim.system({ "uv", "pip", "install", "--python", M.ansibug_python, "ansibug" }, {},
                vim.schedule_wrap(function(installed)
                    if installed.code ~= 0 then
                        return fail(installed)
                    end
                    done()
                end))
        end))
end

-- Same download and checksum as :NeotestJava setup, without its prompt
---@param failures string[]
local function install_junit(failures, done)
    local jar = M.junit_jar()
    if not (has("java") and has("curl")) or vim.uv.fs_stat(jar.path) then
        return done()
    end
    local url = ("https://repo1.maven.org/maven2/org/junit/platform/junit-platform-console-standalone/%s/%s")
        :format(jar.version, vim.fs.basename(jar.path))
    local partial = jar.path .. ".part"
    vim.fn.mkdir(vim.fs.dirname(jar.path), "p")
    vim.system({ "curl", "-fsSL", "-o", partial, url }, {}, vim.schedule_wrap(function(result)
        local sha = result.code == 0 and require("neotest-java.util.checksum").sha256(partial)
        if sha == jar.sha256 then
            vim.uv.fs_rename(partial, jar.path)
        else
            table.insert(failures, "JUnit console launcher: "
                .. (result.code ~= 0 and vim.trim(result.stderr or "") or "checksum mismatch"))
            vim.fn.delete(partial)
        end
        done()
    end))
end

---@param force boolean? Check everything even if nothing appears to have changed
function M.ensure(force)
    if not force and read_stamp() == fingerprint() then
        return
    end

    local packages, parsers, skipped = wanted()
    require("custom.pack").load("mason.nvim")
    local registry = require("mason-registry")

    registry.refresh(vim.schedule_wrap(function()
        local queue, failures = {}, {}
        -- tree-sitter is only needed by nvim-treesitter's installer, not at runtime
        for _, name in ipairs(vim.list_extend({ "tree-sitter-cli" }, packages)) do
            local ok, pkg = pcall(registry.get_package, name)
            if not ok then
                table.insert(failures, name .. " (unknown package)")
            elseif not M.present(pkg) and not pkg:is_installing() then
                local kind = pkg.spec.source.id:match("^pkg:(%w+)/")
                local requirement = source_requirements[kind]
                if requirement and not has(requirement) then
                    skipped[name] = requirement
                else
                    table.insert(queue, pkg)
                end
            end
        end

        if next(skipped) then
            local lines = vim.tbl_map(function(name)
                return ("%s (needs %s)"):format(name, skipped[name])
            end, vim.fn.sort(vim.tbl_keys(skipped)))
            vim.notify("Skipped, see :checkhealth custom:\n" .. table.concat(lines, "\n"), vim.log.levels.INFO)
        end

        local function finish()
            install_ansibug(failures, function()
                install_junit(failures, function()
                    install_parsers(parsers, function(parsers_ok)
                        if #failures > 0 then
                            vim.notify("Failed to install:\n" .. table.concat(failures, "\n"), vim.log.levels.ERROR)
                        elseif parsers_ok then
                            write_stamp()
                        end
                        vim.api.nvim_exec_autocmds("User", { pattern = "CustomToolsDone", modeline = false })
                    end)
                end)
            end)
        end

        if #queue == 0 then
            return finish()
        end

        vim.notify(("Installing %d tools with Mason"):format(#queue))
        local remaining = #queue
        for _, pkg in ipairs(queue) do
            pkg:install({}, vim.schedule_wrap(function(success, err)
                if not success then
                    table.insert(failures, ("%s: %s"):format(pkg.name, err))
                end
                remaining = remaining - 1
                if remaining == 0 then
                    finish()
                end
            end))
        end
    end))
end

function M.setup()
    vim.api.nvim_create_user_command("ToolsInstall", function() M.ensure(true) end,
        { desc = "Install missing language tools and parsers" })

    vim.api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
        once = true,
        callback = function()
            vim.defer_fn(function() M.ensure(false) end, 100)
        end,
    })
end

return M
