-- LSP Zero
local lsp_zero = require("lsp-zero")
local navic = require("nvim-navic")

local lsp_attach = function(client, bufnr)
    local opts = { buffer = bufnr }

    vim.keymap.set("n", "<s-k>", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "g<s-d>", vim.lsp.buf.declaration, opts)
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
    vim.keymap.set("n", "go", vim.lsp.buf.type_definition, opts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
    vim.keymap.set("n", "gs", vim.lsp.buf.signature_help, opts)
    vim.keymap.set("n", "<F2>", vim.lsp.buf.rename, opts)
    vim.keymap.set({ "n", "x" }, "<F3>", function() vim.lsp.buf.format({ async = true }) end, opts)
    vim.keymap.set("n", "<F4>", vim.lsp.buf.code_action, opts)

    -- Navic
    if vim.b.lsp_attached then return end
    vim.b.lsp_attached = true
    if client.server_capabilities.documentSymbolProvider then
        navic.attach(client, bufnr)
    end
end

lsp_zero.extend_lspconfig({
    sign_text = true,
    lsp_attach = lsp_attach,
    capabilities = require("cmp_nvim_lsp").default_capabilities(),
})

-- Mason
local servers = {
    "dockerls", "docker_compose_language_service",
    "tsserver", "html", "cssls", "cssmodules_ls", "jsonls",
    "gopls",
    "texlab",
    "marksman",
    "jsonls",
    "lua_ls",
    "bashls",
    "pyright",
    "rust_analyzer",
    "clangd",
    "jdtls",
    "texlab",
}

local tools = {
    "black", "isort", "flake8"
}

local lspconfig = require("lspconfig")
require("mason").setup({})
require("mason-lspconfig").setup({
    ensure_installed = servers,
    handlers = {
        function(server_name) lspconfig[server_name].setup({}) end,
        jdtls = lsp_zero.noop,
        lua_ls = function()
            local lua_opts = lsp_zero.nvim_lua_ls()
            lspconfig.lua_ls.setup(lua_opts)
        end,
    }
})

require("mason-tool-installer").setup({
    ensure_installed = tools,
    auto_update = true,
})

local debuggers = {
    "python", "cppdb", "javadbg", "javatest"
}
require("mason-nvim-dap").setup({ ensure_installed = debuggers, automatic_installation = true })

vim.keymap.set("n", "<leader>pm", "<cmd>Mason<cr>", { desc = "Open Mason", silent = true })

-- Finish LSP Zero
lsp_zero.setup()

-- Completion and snippets
local cmp_autopairs = require("nvim-autopairs.completion.cmp")
local cmp = require("cmp")
local cmp_action = require("lsp-zero").cmp_action()
local cmp_format = lsp_zero.cmp_format()
local cmp_select = { behavior = cmp.SelectBehavior.Select }

local snippets = "~/.config/nvim/snippets"

local scissors = require("scissors")
scissors.setup({ snippetDir = snippets })
require("luasnip.loaders.from_vscode").lazy_load({ paths = { snippets, } })

vim.keymap.set("n", "<leader>se", require("scissors").editSnippet, { desc = "Edit snippet", silent = true })

-- when used in visual mode, prefills the selection as snippet body
vim.keymap.set({ "n", "x" }, "<leader>sa", scissors.addNewSnippet, { desc = "Add new snippet", silent = true })


cmp.setup({
    sources = {
        { name = "nvim_lsp" },
        { name = "luasnip" },
    },
    formatting = cmp_format,
    mapping = cmp.mapping.preset.insert({
        ["<c-y>"] = cmp.mapping.confirm({ select = true }),
        ["<c-p>"] = cmp.mapping.select_prev_item(cmp_select),
        ["<c-n>"] = cmp.mapping.select_next_item(cmp_select),
        ["<tab>"] = nil,
        ["<s-tab>"] = nil,
        ["<c-u>"] = cmp.mapping.scroll_docs(-4),
        ["<c-d>"] = cmp.mapping.scroll_docs(4),
        ["<c-f>"] = cmp_action.luasnip_jump_forward(),
        ["<c-b>"] = cmp_action.luasnip_jump_backward(),
    }),
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    }
})

cmp.setup.cmdline("/", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        { name = "buffer" }
    }
})

cmp.setup.cmdline(":", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        { name = "path" }
    }, {
        {
            name = "cmdline",
            option = {
                ignore_cmds = { "Man", "!" }
            }
        }
    })
})

cmp.event:on(
    "confirm_done",
    cmp_autopairs.on_confirm_done()
)
