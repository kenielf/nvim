return {
    settings = {
        ["rust-analyzer"] = {
            check = { command = vim.fn.executable("cargo-clippy") == 1 and "clippy" or "check" },
            cargo = { allFeatures = true },
            procMacro = { enable = true },
            inlayHints = {
                closureReturnTypeHints = { enable = "with_block" },
                lifetimeElisionHints = { enable = "skip_trivial" },
            },
        },
    },
}
