-- vimtex builds and views, texlab completes, renames labels and reports chktex warnings
return {
    settings = {
        texlab = {
            build = { onSave = false },
            chktex = { onOpenAndSave = vim.fn.executable("chktex") == 1, onEdit = false },
        },
    },
}
