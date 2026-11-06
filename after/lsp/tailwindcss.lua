return {
    -- The stock config falls back to any .git directory, which would start the server
    -- for every HTML, CSS, JS and Markdown file. Only start it where Tailwind is in use.
    root_dir = function(bufnr, on_dir)
        local fname = vim.api.nvim_buf_get_name(bufnr)
        local markers = {
            "tailwind.config.js", "tailwind.config.cjs", "tailwind.config.mjs", "tailwind.config.ts",
            "postcss.config.js", "postcss.config.cjs", "postcss.config.mjs", "postcss.config.ts",
        }
        markers = require("lspconfig.util").insert_package_json(markers, "tailwindcss", fname)
        local root = vim.fs.root(fname, markers)
        if root then
            on_dir(root)
        end
    end,
}
