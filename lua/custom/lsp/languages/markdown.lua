require("markview").setup({
    modes = { "n", "no", "c" },

    hybrid_modes = { "n" },

    -- This is nice to have
    callbacks = {
        on_enable = function (_, win)
            vim.wo[win].conceallevel = 2;
            vim.wo[win].concealcursor = "c";
        end
    }
})
