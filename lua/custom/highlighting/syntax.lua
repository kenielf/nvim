-- Configured languages
local languages = {
    -- Vim specific
    "vim", "vimdoc",

    -- Git
    "diff", "git_config", "git_rebase", "gitattributes", "gitcommit",
    "gitignore",

    -- Markup languages and configuration files
    "comment", "css", "dockerfile", "doxygen", "helm", "html", "htmldjango",
    "ini", "latex", "markdown", "markdown_inline", "nginx", "nix", "org",
    "passwd", "rasi", "requirements", "rst", "ssh_config", "sxhkdrc",
    "terraform", "tmux", "toml", "udev", "yaml", "zathurarc",

    -- Data formats
    "csv", "http", "json", "json5", "objdump", "strace", "xml",

    -- Query formats
    "graphql", "query", "soql", "sparql", "sql",

    -- Programming languages and frameworks
    "arduino", "asm", "awk", "bash", "c", "c_sharp", "clojure", "commonlisp",
    "cpp", "dart", "elixir", "erlang", "fortran", "gdscript", "gdshader",
    "go", "godot_resource", "haskell", "java", "javascript", "kotlin", "llvm",
    "lua", "luadoc", "nasm", "ocaml", "pascal", "perl", "php", "phpdoc",
    "powershell", "prolog", "python", "r", "ruby", "rust", "scala", "svelte",
    "swift", "tsx", "typescript", "verilog", "vue",

    -- Shaders
    "glsl", "hlsl",

    -- Build tools
    "make", "meson", "ninja"
}

-- Auto_install
local install = false
if vim.fn.exepath("treesitter") ~= nil then
    install = true
end

-- Treesitter
require("nvim-treesitter.configs").setup({
    yati = { enable = true, default_lazy = true, },
    indent = false,
    ensure_installed = languages,
    sync_install = false,
    auto_install = install,
})

