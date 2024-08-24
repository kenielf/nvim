-- Configured languages
local syntaxes = {
    -- Vim specific
    "vim", "vimdoc",

    -- Git
    "diff", "git_config", "git_rebase", "gitattributes", "gitcommit",
    "gitignore",

    -- Markup languages and configuration files
    "comment", "css", "dockerfile", "doxygen", "helm", "html", "htmldjango",
    "ini", "markdown", "markdown_inline", "nginx", "nix", "org", "passwd",
    "rasi", "requirements", "rst", "ssh_config", "sxhkdrc", "terraform",
    "tmux", "toml", "udev", "yaml", "zathurarc",

    -- Data formats
    "csv", "http", "json", "json5", "objdump", "strace", "xml",

    -- Query formats
    "graphql", "query", "soql", "sparql", "sql",

    -- Programming languages and frameworks
    "arduino", "asm", "awk", "bash", "c", "c_sharp", "clojure", "commonlisp",
    "cpp", "dart", "elixir", "erlang", "fsh", "fortran", "gdscript", "gdshader",
    "go", "godot_resource", "haskell", "java", "javascript", "kotlin", "llvm",
    "lua", "luadoc", "nasm", "ocaml", "pascal", "perl", "php", "phpdoc",
    "powershell", "prolog", "python", "r", "ruby", "rust", "scala", "svelte",
    "tsx", "typescript", "verilog", "vue",

    -- Shaders
    "glsl", "hlsl",

    -- Build tools
    "make", "meson", "ninja"
}

-- Auto_install
local install = false
if vim.fn.exepath("treesitter") ~= nil then
    install = true

    -- Add cli dependent syntaxes
    local extended_syntaxes = {
        -- Markup languages and configuration files
        "latex",

        -- Programming languages and frameworks
        "swift",
    }

    -- Extend original syntax table
    for key, value in pairs(extended_syntaxes) do syntaxes[key] = value end
end

-- Treesitter
require("nvim-treesitter.configs").setup({
    yati = { enable = true, default_lazy = true, },
    indent = false,
    highlight = { enable = true, additional_vim_regex_highlight = false, },
    ensure_installed = syntaxes,
    sync_install = false,
    auto_install = install,
})
