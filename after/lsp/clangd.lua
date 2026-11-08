local function is_index_designator(hint)
    local label = hint.label
    if type(label) == "table" then
        label = table.concat(vim.tbl_map(function(part) return part.value end, label))
    end
    return label:match("^%[%d+%]=$") ~= nil
end

return {
    cmd = {
        "clangd",
        "--background-index",
        "--clang-tidy",
        "--header-insertion=iwyu",
        "--completion-style=detailed",
        "--function-arg-placeholders",
        "--fallback-style=llvm",
        "-j=4",
    },
    init_options = {
        usePlaceholders = true,
        completeUnimported = true,
        clangdFileStatus = true,
    },
    handlers = {
        ["textDocument/inlayHint"] = function(err, result, ctx)
            if result then
                result = vim.tbl_filter(function(hint) return not is_index_designator(hint) end, result)
            end
            return vim.lsp.inlay_hint.on_inlayhint(err, result, ctx)
        end,
    },
}
