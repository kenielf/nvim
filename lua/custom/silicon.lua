-- Code screenshots through nvim-silicon, with a system font search and a clear
-- notification when the silicon binary is missing.
local M = {}

local state_file = vim.fn.stdpath("state") .. "/silicon.json"
local font_size = 24
local main_fonts = { "IosevkaTerm Nerd Font Mono", "Iosevka Nerd Font" }
local fallback_fonts = { "Noto Color Emoji", "Noto Serif CJK JP" }

function M.is_installed()
    return vim.fn.executable("silicon") == 1
end

local function ensure_installed()
    if M.is_installed() then
        return true
    end
    vim.notify(
        "silicon isn't installed, so screenshots are unavailable.\n"
            .. "Install it with your package manager or `cargo install silicon`.",
        vim.log.levels.ERROR,
        { title = "Silicon" }
    )
    return false
end

function M.picked_font()
    local ok, state = pcall(function()
        return vim.json.decode(table.concat(vim.fn.readfile(state_file), "\n"))
    end)
    return ok and type(state) == "table" and state.font or nil
end

local installed_cache
local function installed_fonts()
    if not installed_cache then
        local result = vim.system({ "silicon", "--list-fonts" }, { text = true }):wait()
        if result.code ~= 0 then
            return {}
        end
        installed_cache = {}
        for family in vim.gsplit(result.stdout, "\n", { trimempty = true }) do
            installed_cache[family] = true
        end
    end
    return installed_cache
end

-- The installed main and fallback fonts, in order. silicon only logs a missing font and
-- still exits 0, so anything not installed has to be left out here.
function M.font_stack()
    local installed = installed_fonts()
    local main_candidates = vim.list_extend({ M.picked_font() }, main_fonts)
    local stack, seen = { main = {}, fallback = {}, missing = {} }, {}
    local function add(list, candidates)
        for _, font in ipairs(candidates) do
            if not seen[font] then
                seen[font] = true
                table.insert(installed[font] and list or stack.missing, font)
            end
        end
    end
    add(stack.main, main_candidates)
    add(stack.fallback, fallback_fonts)
    return stack
end

-- The --font value, or nil and an error when none of the main fonts are installed
local function font_option()
    local stack = M.font_stack()
    if #stack.main == 0 then
        local tried = vim.list_extend({ M.picked_font() }, main_fonts)
        return nil, "None of the screenshot fonts are installed: "
            .. table.concat(tried, ", ") .. ".\nPick one with :SiliconFont."
    end
    local fonts = {}
    for _, font in ipairs(vim.list_extend(vim.list_extend({}, stack.main), stack.fallback)) do
        table.insert(fonts, font .. "=" .. font_size)
    end
    return table.concat(fonts, ";")
end

-- Loads the plugin and points it at the current font stack, false when there is none
local function prepare()
    if not ensure_installed() then
        return false
    end
    local font, err = font_option()
    if not font then
        vim.notify(err, vim.log.levels.ERROR, { title = "Silicon" })
        return false
    end
    M.plugin().options.font = font
    return true
end

local function user_command(args)
    if prepare() then
        M.plugin().usercmd(args)
    end
end

local function define_command(force)
    vim.api.nvim_create_user_command("Silicon", user_command,
        { range = true, force = force, desc = "Screenshot range or buffer to the clipboard" })
end

local plugin_ready = false

function M.plugin()
    local silicon_plugin
    if not plugin_ready then
        plugin_ready = true
        -- Its setup() refuses to redefine :Silicon
        vim.api.nvim_del_user_command("Silicon")
        require("custom.pack").load("nvim-silicon")
        silicon_plugin = require("nvim-silicon")
        local palette = require("catppuccin.palettes").get_palette("mocha")
        silicon_plugin.setup({
            theme = "Catppuccin Mocha",
            background = palette.base,
            pad_horiz = 40,
            pad_vert = 40,
            tab_width = 4,
            shadow_blur_radius = 0,
            shadow_offset_x = 0,
            shadow_offset_y = 0,
            no_round_corner = true,
            no_window_controls = true,
            to_clipboard = true,
        })
        define_command(true)
    end
    return silicon_plugin or require("nvim-silicon")
end

function M.shoot()
    if prepare() then
        M.plugin().shoot()
    end
end

function M.set_font(font)
    vim.fn.mkdir(vim.fn.fnamemodify(state_file, ":h"), "p")
    vim.fn.writefile({ vim.json.encode({ font = font }) }, state_file)
    vim.notify("Screenshot font: " .. font, vim.log.levels.INFO, { title = "Silicon" })
end

-- silicon's own list has the exact names it accepts, fontconfig adds which are monospaced
function M.list_fonts()
    local result = vim.system({ "silicon", "--list-fonts" }, { text = true }):wait()
    if result.code ~= 0 then
        return nil, result.stderr
    end

    local mono = {}
    if vim.fn.executable("fc-list") == 1 then
        local fc = vim.system({ "fc-list", ":spacing=100", "family" }, { text = true }):wait()
        for line in vim.gsplit(fc.stdout or "", "\n", { trimempty = true }) do
            for family in vim.gsplit(line, ",", { plain = true }) do
                mono[family] = true
            end
        end
        fc = vim.system({ "fc-list", ":spacing=90", "family" }, { text = true }):wait()
        for line in vim.gsplit(fc.stdout or "", "\n", { trimempty = true }) do
            for family in vim.gsplit(line, ",", { plain = true }) do
                mono[family] = true
            end
        end
    end

    local fonts, seen = {}, {}
    for family in vim.gsplit(result.stdout, "\n", { trimempty = true }) do
        if not seen[family] then
            seen[family] = true
            -- fontconfig doesn't flag every Nerd Font variant as monospaced
            table.insert(fonts, { name = family, mono = mono[family] or family:find("Mono") ~= nil })
        end
    end
    table.sort(fonts, function(a, b)
        if a.mono ~= b.mono then
            return a.mono
        end
        return a.name:lower() < b.name:lower()
    end)
    return fonts
end

local function preview_lines(font)
    local lines = {
        font.name,
        "",
        font.mono and "Monospaced" or "Proportional, code will not line up",
    }
    if vim.fn.executable("fc-list") == 1 then
        local fc = vim.system({ "fc-list", font.name, "style" }, { text = true }):wait()
        local styles, seen = {}, {}
        for line in vim.gsplit(fc.stdout or "", "\n", { trimempty = true }) do
            local style = line:match("style=([^,]+)")
            if style and not seen[style] then
                seen[style] = true
                table.insert(styles, style)
            end
        end
        table.sort(styles)
        if #styles > 0 then
            vim.list_extend(lines, { "", "Styles:" })
            for _, style in ipairs(styles) do
                table.insert(lines, "  " .. style)
            end
        end
    end
    return lines
end

function M.pick_font()
    if not ensure_installed() then
        return
    end
    local fonts, err = M.list_fonts()
    if not fonts then
        vim.notify("Couldn't list fonts: " .. (err or ""), vim.log.levels.ERROR, { title = "Silicon" })
        return
    end

    local stack = M.font_stack()
    local current = {}
    for _, font in ipairs(vim.list_extend(stack.main, stack.fallback)) do
        current[font] = true
    end
    local items = {}
    for _, font in ipairs(fonts) do
        table.insert(items, {
            text = font.name,
            font = font,
            current = current[font.name] or false,
        })
    end

    Snacks.picker.pick({
        title = "Screenshot Font",
        items = items,
        format = function(item)
            return {
                { item.current and "● " or "  ", "SnacksPickerSelected" },
                { item.text },
                { item.font.mono and "  mono" or "", "Comment" },
            }
        end,
        preview = function(ctx)
            ctx.preview:reset()
            ctx.preview:set_lines(preview_lines(ctx.item.font))
            ctx.preview:set_title(ctx.item.text)
        end,
        confirm = function(picker, item)
            picker:close()
            if item then
                M.set_font(item.text)
            end
        end,
    })
end

function M.setup()
    define_command(false)

    vim.api.nvim_create_user_command("SiliconFont", function(args)
        if args.args == "" then
            M.pick_font()
        else
            M.set_font(args.args)
        end
    end, {
        nargs = "?",
        desc = "Search system fonts for screenshots",
        complete = function(lead)
            if not M.is_installed() then
                return {}
            end
            local names = vim.tbl_map(function(font) return font.name end, M.list_fonts() or {})
            return vim.tbl_filter(function(name)
                return name:lower():find(lead:lower(), 1, true) ~= nil
            end, names)
        end,
    })

    vim.keymap.set("x", "<leader>sc", M.shoot, { desc = "Screenshot selection", silent = true })
    vim.keymap.set("n", "<leader>sF", M.pick_font, { desc = "Search screenshot fonts", silent = true })
end

return M
