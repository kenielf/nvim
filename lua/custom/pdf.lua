-- Paging for PDFs that snacks opens as images, and live reload for PDFs being built.
-- snacks caches a rendered page by file name and page, so each version of the PDF is
-- rendered from its own copy. The copy is taken once the file stops changing, which also
-- keeps a half-written PDF from a build in progress off the screen.
local M = {}

local snapshots = vim.fn.stdpath("cache") .. "/pdf"
local state = {} ---@type table<integer, {path: string, page: integer, pages: integer, snapshot?: string, mtime?: string, watcher?: uv.uv_fs_event_t, timer?: uv.uv_timer_t}>

---@return integer? pages nil while the file isn't a complete PDF
local function page_count(path)
    local result = vim.system({ "pdfinfo", path }, { text = true }):wait()
    return result.code == 0 and tonumber(result.stdout:match("Pages:%s*(%d+)")) or nil
end

local function mtime(path)
    local stat = vim.uv.fs_stat(path)
    return stat and ("%d.%d"):format(stat.mtime.sec, stat.mtime.nsec)
end

-- The copy and the pages snacks rendered from it, named after the copy
local function remove_snapshot(snapshot)
    vim.uv.fs_unlink(snapshot)
    local name = vim.fn.fnamemodify(snapshot, ":t:r")
    for _, file in ipairs(vim.fn.glob(Snacks.image.config.cache .. "/*-" .. name .. ".png*", false, true)) do
        vim.uv.fs_unlink(file)
    end
end

local function update_winbar(buf)
    local s = state[buf]
    for _, win in ipairs(vim.fn.win_findbuf(buf)) do
        vim.wo[win][0].winbar = (" %s  page %d/%d"):format(vim.fs.basename(s.path), s.page, s.pages)
    end
end

local function render(buf)
    local s = state[buf]
    Snacks.image.placement.clean(buf)
    Snacks.image.placement.new(buf, ("%s#page=%d"):format(s.snapshot, s.page), { conceal = true, auto_resize = true })
    update_winbar(buf)
end

-- Takes a copy of the current version, returns false while the PDF is incomplete
local function refresh(buf)
    local s = state[buf]
    local current = mtime(s.path)
    if not current or current == s.mtime then
        return true
    end
    local pages = page_count(s.path)
    if not pages then
        return false
    end
    vim.fn.mkdir(snapshots, "p")
    local snapshot = ("%s/%s-%s.pdf"):format(snapshots, vim.fn.sha256(s.path):sub(1, 8), current)
    if not vim.uv.fs_copyfile(s.path, snapshot) then
        return false
    end
    if s.snapshot then
        remove_snapshot(s.snapshot)
    end
    s.snapshot, s.mtime, s.pages = snapshot, current, pages
    s.page = math.min(s.page, pages)
    return true
end

local function go(buf, page)
    local s = state[buf]
    page = math.max(1, math.min(page, s.pages))
    if page ~= s.page then
        s.page = page
        render(buf)
    end
end

-- Builds usually write to a temporary file and rename it over the PDF, so the directory is
-- watched rather than the file. Changes settle for a moment before the page is rendered.
local function watch(buf)
    local s = state[buf]
    s.timer = vim.uv.new_timer()
    s.watcher = vim.uv.new_fs_event()
    local attempts = 0
    local function settle()
        if not state[buf] then
            return
        end
        if refresh(buf) then
            render(buf)
        elseif attempts < 20 then
            -- Still being written, or a build that failed halfway: check again for a while
            attempts = attempts + 1
            s.timer:start(500, 0, vim.schedule_wrap(settle))
        end
    end
    s.watcher:start(vim.fs.dirname(s.path), {}, function(_, name)
        if name == vim.fs.basename(s.path) then
            attempts = 0
            s.timer:start(300, 0, vim.schedule_wrap(settle))
        end
    end)
end

local function detach(buf)
    local s = state[buf]
    if not s then
        return
    end
    state[buf] = nil
    for _, handle in ipairs({ s.watcher, s.timer }) do
        if not handle:is_closing() then
            handle:close()
        end
    end
    if s.snapshot then
        remove_snapshot(s.snapshot)
    end
end

local function attach(buf)
    local path = vim.api.nvim_buf_get_name(buf)
    if state[buf] or not path:lower():match("%.pdf$") or vim.fn.executable("pdfinfo") == 0 then
        return
    end
    state[buf] = { path = path, page = 1, pages = 1 }
    if not refresh(buf) then
        state[buf] = nil
        return
    end
    render(buf)
    watch(buf)

    local function map(lhs, fn, desc)
        vim.keymap.set("n", lhs, fn, { buffer = buf, desc = desc })
    end
    map("]p", function() go(buf, state[buf].page + vim.v.count1) end, "Next PDF page")
    map("[p", function() go(buf, state[buf].page - vim.v.count1) end, "Previous PDF page")
    map("gg", function() go(buf, vim.v.count > 0 and vim.v.count or 1) end, "First PDF page, or [count]")
    map("G", function() go(buf, vim.v.count > 0 and vim.v.count or state[buf].pages) end, "Last PDF page, or [count]")

    vim.api.nvim_create_autocmd("BufWinEnter", { buffer = buf, callback = function() update_winbar(buf) end })
    vim.api.nvim_create_autocmd({ "BufWipeout", "BufDelete" }, { buffer = buf, once = true, callback = function() detach(buf) end })
end

function M.setup()
    vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("custom.pdf", {}),
        pattern = "image",
        desc = "PDF paging and live reload",
        callback = function(ev) attach(ev.buf) end,
    })
    vim.api.nvim_create_autocmd("VimLeavePre", {
        group = "custom.pdf",
        callback = function()
            for buf in pairs(state) do
                detach(buf)
            end
        end,
    })
end

return M
