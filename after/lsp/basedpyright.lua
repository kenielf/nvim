return {
    settings = {
        basedpyright = {
            -- ruff handles imports and style
            disableOrganizeImports = true,
            analysis = {
                typeCheckingMode = "standard",
                autoImportCompletions = true,
                diagnosticMode = "openFilesOnly",
            },
        },
    },
}
