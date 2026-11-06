-- Native LSP: configs come from nvim-lspconfig's lsp/ directory, overrides from after/lsp/.
local M = {}

local function on_attach(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if not client then
        return
    end
    local buf = ev.buf

    local function map(mode, lhs, rhs, desc)
        vim.keymap.set(mode, lhs, rhs, { buffer = buf, desc = desc, silent = true, nowait = true })
    end

    -- Navigation
    map("n", "gd", function() Snacks.picker.lsp_definitions() end, "Go to definition")
    map("n", "gD", function() Snacks.picker.lsp_declarations() end, "Go to declaration")
    map("n", "gi", function() Snacks.picker.lsp_implementations() end, "Go to implementation")
    map("n", "go", function() Snacks.picker.lsp_type_definitions() end, "Go to type definition")
    map("n", "gr", function() Snacks.picker.lsp_references() end, "Go to references")
    map("n", "gs", vim.lsp.buf.signature_help, "Signature help")

    -- Actions
    map("n", "<F2>", vim.lsp.buf.rename, "Rename symbol")
    map("n", "<F4>", vim.lsp.buf.code_action, "Code action")
    map("n", "<leader>ln", vim.lsp.buf.rename, "Rename symbol")
    map({ "n", "x" }, "<leader>la", vim.lsp.buf.code_action, "Code action")
    map("n", "<leader>lc", vim.lsp.codelens.run, "Run code lens")
    map("n", "<leader>ls", function() Snacks.picker.lsp_symbols() end, "Document symbols")
    map("n", "<leader>lS", function() Snacks.picker.lsp_workspace_symbols() end, "Workspace symbols")
    map("n", "<leader>lw", vim.lsp.buf.workspace_diagnostics, "Load workspace diagnostics")
    map("n", "<leader>lr", "<cmd>lsp restart<cr>", "Restart language servers")
    map("n", "<leader>li", "<cmd>checkhealth vim.lsp<cr>", "LSP status")

    -- Features that are off by default
    if client:supports_method("textDocument/inlayHint", buf) then
        vim.lsp.inlay_hint.enable(true, { bufnr = buf })
    end
    if client:supports_method("textDocument/codeLens", buf) then
        vim.lsp.codelens.enable(true, { bufnr = buf })
    end
    if client:supports_method("textDocument/linkedEditingRange", buf) then
        vim.lsp.linked_editing_range.enable(true, { client_id = client.id })
    end
    if client:supports_method("textDocument/foldingRange", buf) then
        for _, win in ipairs(vim.fn.win_findbuf(buf)) do
            vim.wo[win][0].foldmethod = "expr"
            vim.wo[win][0].foldexpr = "v:lua.vim.lsp.foldexpr()"
        end
    end

    -- Breadcrumbs for the statusline
    if client:supports_method("textDocument/documentSymbol", buf) then
        require("custom.pack").load("nvim-navic")
        require("nvim-navic").attach(client, buf)
    end
end

function M.setup()
    vim.diagnostic.config({
        severity_sort = true,
        update_in_insert = false,
        underline = true,
        virtual_text = { spacing = 2, prefix = "●", source = "if_many" },
        float = { source = true },
        signs = vim.g.tty and true or {
            text = {
                [vim.diagnostic.severity.ERROR] = "󰅚",
                [vim.diagnostic.severity.WARN] = "󰀪",
                [vim.diagnostic.severity.INFO] = "󰋽",
                [vim.diagnostic.severity.HINT] = "󰌶",
            },
        },
    })

    vim.lsp.config("*", {
        capabilities = require("blink.cmp").get_lsp_capabilities(),
    })

    vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("custom.lsp", {}),
        callback = on_attach,
    })

    -- A server can exist without what it runs on (roslyn without .NET) and would error
    -- on every buffer, so those languages stay off until it's there
    local servers = {}
    for _, lang in ipairs(require("custom.languages")) do
        local usable = vim.iter(lang.requires or {}):all(function(bin)
            return vim.fn.executable(bin) == 1
        end)
        if usable then
            vim.list_extend(servers, lang.servers or {})
        end
    end
    vim.lsp.enable(servers)
end

return M
