-- :checkhealth custom
local M = {}

local function has(bin)
    return vim.fn.executable(bin) == 1
end

-- Same check the installer uses, so this agrees with what :ToolsInstall will do
local function missing_tools(lang)
    local registry = require("mason-registry")
    return vim.tbl_filter(function(tool)
        local ok, pkg = pcall(registry.get_package, tool)
        return not (ok and require("custom.tools").present(pkg))
    end, lang.tools or {})
end

local function check_language(lang)
    local health = vim.health
    health.start(lang.name)

    local blocked = false
    for _, bin in ipairs(lang.requires or {}) do
        if has(bin) then
            health.ok(("`%s` found"):format(bin))
        else
            blocked = true
            health.warn(("`%s` not found, so this language's tools are skipped"):format(bin),
                "Install it, then restart Neovim and its tools install on their own.")
        end
    end

    if lang.started_by then
        health.info("Language server started by " .. lang.started_by)
    end
    if not blocked then
        local missing = missing_tools(lang)
        if #missing > 0 then
            health.warn("Not installed: " .. table.concat(missing, ", "), "Run :ToolsInstall")
        elseif lang.tools then
            health.ok("Tools installed: " .. table.concat(lang.tools, ", "))
        end
    end

    for bin, feature in pairs(lang.optional or {}) do
        if has(bin) then
            health.ok(("`%s` found"):format(bin))
        else
            health.info(("`%s` not found, optional: %s"):format(bin, feature))
        end
    end
end

function M.check()
    local health = vim.health

    health.start("Build tools")
    for _, bin in ipairs({ "git", "curl", "tar", "unzip", "gzip" }) do
        if has(bin) then
            health.ok(("`%s` found"):format(bin))
        else
            health.error(("`%s` not found, Mason and vim.pack need it"):format(bin))
        end
    end
    if has("cc") or has("gcc") or has("clang") then
        health.ok("C compiler found")
    else
        health.warn("No C compiler found, treesitter parsers can't be built")
    end
    if has("tree-sitter") then
        health.ok("`tree-sitter` found: " .. vim.fn.exepath("tree-sitter"))
    else
        health.warn("`tree-sitter` not found, treesitter parsers can't be built", "Run :ToolsInstall")
    end
    for bin, feature in pairs({ rg = "grep picker", fd = "file picker", npm = "Node-based tools", magick = "image previews" }) do
        if has(bin) then
            health.ok(("`%s` found"):format(bin))
        else
            health.warn(("`%s` not found, needed for: %s"):format(bin, feature))
        end
    end

    require("custom.pack").load("mason.nvim")
    for _, lang in ipairs(require("custom.languages")) do
        check_language(lang)
    end

    health.start("Debugging")
    if has("perl") and vim.system({ "perl", "-MPadWalker", "-e", "1" }):wait().code ~= 0 then
        health.warn("Perl module PadWalker not found, perl-debug-adapter requires it",
            "Install dev-perl/PadWalker or run `cpan PadWalker`")
    end

    health.start("Screenshots")
    local silicon = require("custom.silicon")
    if not silicon.is_installed() then
        health.error("`silicon` not found, screenshots are unavailable",
            "Install it with your package manager or `cargo install silicon`")
        return
    end
    health.ok("`silicon` found: " .. vim.fn.exepath("silicon"))
    local fonts = silicon.list_fonts() or {}
    local current = silicon.current_font()
    if vim.iter(fonts):any(function(font) return font.name == current end) then
        health.ok(("Font `%s` is installed (%d fonts available)"):format(current, #fonts))
    else
        health.warn(("Font `%s` isn't installed"):format(current), "Pick another with :SiliconFont")
    end
    if os.getenv("WAYLAND_DISPLAY") and not has("wl-copy") then
        health.warn("`wl-copy` not found, screenshots can't reach the clipboard")
    elseif os.getenv("DISPLAY") and not has("xclip") then
        health.warn("`xclip` not found, screenshots can't reach the clipboard")
    end
end

return M
