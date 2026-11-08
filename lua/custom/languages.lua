-- Single source of truth for language support. To add a language, add an entry here.
--   servers     vim.lsp configs to enable (from nvim-lspconfig, overrides in after/lsp/)
--   started_by  how a server that isn't enabled through vim.lsp is started
--   tools       Mason packages, skipped when the same binary is already on the system
--   parsers     treesitter parsers
--   formatters  conform.nvim formatters by filetype, falls back to the language server
--   requires    executables the language can't work without, its tools are skipped
--               and reported in :checkhealth custom until they exist
--   optional    executables that only add features, as { bin = "what it adds" }
local prettier = { "prettierd", "prettier", stop_after_first = true }

return {
    {
        name = "C / C++",
        servers = { "clangd" },
        tools = { "clangd", "clang-format", "codelldb" },
        parsers = { "c", "cpp", "doxygen", "asm", "nasm", "make", "cmake", "meson", "ninja" },
        formatters = { c = { "clang-format" }, cpp = { "clang-format" } },
    },
    {
        name = "C#",
        requires = { "dotnet" },
        servers = { "roslyn_ls" },
        tools = { "roslyn-language-server", "netcoredbg", "csharpier" },
        parsers = { "c_sharp" },
        formatters = { cs = { "csharpier" } },
    },
    {
        name = "Java",
        requires = { "java", "python3" }, -- Mason's jdtls launcher is a Python script
        started_by = "ftplugin/java.lua (nvim-jdtls)",
        tools = { "jdtls", "java-debug-adapter", "java-test" },
        parsers = { "java" },
    },
    {
        name = "Python",
        requires = { "python3" },
        servers = { "basedpyright", "ruff" },
        tools = { "basedpyright", "ruff", "debugpy" },
        parsers = { "python", "requirements" },
        formatters = { python = { "ruff_organize_imports", "ruff_format" } },
    },
    {
        name = "Shell",
        servers = { "bashls" },
        tools = { "bash-language-server", "shellcheck", "shfmt", "bash-debug-adapter" },
        parsers = { "bash", "zsh", "powershell", "awk" },
        formatters = { sh = { "shfmt" }, bash = { "shfmt" }, ksh = { "shfmt" } },
    },
    {
        name = "Perl",
        requires = { "perl" },
        servers = { "perlnavigator" },
        tools = { "perlnavigator", "perl-debug-adapter" },
        parsers = { "perl" },
        formatters = { perl = { "perltidy" } },
        optional = {
            perltidy = "formatting (Perl::Tidy)",
            perlcritic = "linting through perlnavigator (Perl::Critic)",
        },
    },
    {
        name = "Rust",
        requires = { "cargo" },
        servers = { "rust_analyzer" },
        tools = { "rust-analyzer", "codelldb" },
        parsers = { "rust" },
        formatters = { rust = { "rustfmt" } },
        optional = { ["cargo-clippy"] = "clippy diagnostics on save" },
    },
    {
        name = "JavaScript / Web",
        requires = { "node" },
        servers = { "vtsls", "eslint", "html", "cssls", "jsonls", "tailwindcss", "emmet_language_server" },
        tools = {
            "vtsls", "eslint-lsp", "html-lsp", "css-lsp", "json-lsp",
            "tailwindcss-language-server", "emmet-language-server",
            "js-debug-adapter", "prettierd",
        },
        parsers = {
            "javascript", "jsdoc", "typescript", "tsx", "html", "css", "scss",
            "json", "json5", "vue", "svelte", "graphql", "http",
        },
        formatters = {
            javascript = prettier, javascriptreact = prettier,
            typescript = prettier, typescriptreact = prettier,
            html = prettier, css = prettier, scss = prettier,
            json = prettier, jsonc = prettier,
            vue = prettier, svelte = prettier, graphql = prettier,
        },
    },
    {
        -- tofu-ls reads the configuration on its own, the tofu CLI is only needed to format
        name = "OpenTofu",
        servers = { "tofu_ls" },
        tools = { "tofu-ls" },
        parsers = { "terraform", "hcl" },
        formatters = {
            opentofu = { "tofu_fmt" }, ["opentofu-vars"] = { "tofu_fmt" },
            terraform = { "tofu_fmt" }, ["terraform-vars"] = { "tofu_fmt" },
        },
        optional = { tofu = "formatting (tofu fmt)" },
    },
    {
        name = "Ansible",
        requires = { "ansible" },
        servers = { "ansiblels" },
        tools = { "ansible-language-server", "ansible-lint" },
        parsers = { "jinja", "jinja_inline" },
    },
    {
        -- Plain manifests are validated by yamlls, see after/lsp/yamlls.lua
        name = "Helm",
        requires = { "helm" },
        servers = { "helm_ls" },
        tools = { "helm-ls" },
        parsers = { "helm" },
    },
    {
        name = "Shaders",
        servers = { "glsl_analyzer", "wgsl_analyzer", "slangd" },
        tools = { "glsl_analyzer", "wgsl-analyzer", "slang", "clang-format" },
        parsers = { "glsl", "hlsl", "wgsl", "slang", "gdshader" },
        formatters = { glsl = { "clang-format" }, hlsl = { "clang-format" } },
    },
    {
        name = "Lua",
        servers = { "lua_ls" },
        tools = { "lua-language-server", "stylua" },
        parsers = { "lua", "luadoc", "vim", "vimdoc", "query" },
        formatters = { lua = { "stylua" } },
    },
    {
        name = "Markdown and config files",
        servers = { "marksman", "yamlls", "taplo", "neocmake" },
        tools = { "marksman", "yaml-language-server", "taplo", "neocmakelsp" },
        parsers = {
            "markdown", "markdown_inline", "yaml", "toml", "xml", "ini", "dockerfile", "sql",
            "regex", "diff", "git_config", "git_rebase", "gitattributes", "gitcommit", "gitignore",
        },
        formatters = { markdown = prettier, yaml = prettier, toml = { "taplo" } },
    },
}
