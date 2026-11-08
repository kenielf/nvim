return {
    -- Screenshots, see custom/silicon.lua
    { "michaelrommel/nvim-silicon" },

    -- LaTeX, see custom/tex.lua. vimtex has to be loaded before the first .tex buffer sets
    -- its filetype, and it only loads its code then, so it's eager.
    {
        "lervag/vimtex",
        eager = true,
        cond = function() return vim.fn.executable("latexmk") == 1 end,
        config = function() require("custom.tex").setup() end,
    },

    -- Kubernetes cluster browser. Release tags come with a prebuilt library, so no Rust is needed.
    { "saghen/blink.lib" },
    {
        "ramilito/kubectl.nvim",
        version = vim.version.range("2.*"),
        deps = { "blink.lib" },
        cmd = { "Kubectl", "Kubens", "Kubectx" },
        keys = {
            {
                "<leader>k",
                function()
                    local kubectl = require("kubectl")
                    -- Not toggle({ tab = true }), which leaves the new tab's empty buffer behind.
                    -- bufhidden=wipe doesn't help, the plugin sets bufhidden on the current buffer.
                    if not kubectl.is_open then
                        vim.cmd.tabnew()
                        local placeholder = vim.api.nvim_get_current_buf()
                        vim.api.nvim_create_autocmd("BufHidden", {
                            buffer = placeholder,
                            once = true,
                            callback = vim.schedule_wrap(function()
                                if vim.api.nvim_buf_is_valid(placeholder) then
                                    vim.api.nvim_buf_delete(placeholder, { force = true })
                                end
                            end),
                        })
                    end
                    kubectl.toggle()
                end,
                desc = "Kubernetes",
            },
        },
        cond = function() return vim.fn.executable("kubectl") == 1 end,
        -- Setup downloads the library for the installed tag. Running it after an install or
        -- update, through the build hook, has the library ready by the time it's opened.
        build = function() end,
        config = function() require("kubectl").setup() end,
    },

    -- Discord. Publishes what is being edited, NVIM_NO_DISCORD=1 opts out for a session.
    {
        "vyfor/cord.nvim",
        event = "VeryLazy",
        build = "Cord update",
        cond = function()
            return vim.env.NVIM_NO_DISCORD == nil and #vim.api.nvim_list_uis() > 0
        end,
        config = function()
            require("cord").setup({
                editor = { tooltip = "How do I close this?" },
                display = { theme = "catppuccin", flavor = "dark", swap_icons = true },
                timestamp = { enabled = true, shared = true },
                idle = { enabled = false },
            })
        end,
    },
}
