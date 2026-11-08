-- Kubernetes manifests get the kubernetes schema file by file, recognized by their apiVersion
-- and kind. Associating it with every YAML file would validate compose files, CI configs and
-- the like as manifests. The server then picks the schema for each kind, CRDs included.
local function is_manifest(buf)
    local api_version, kind = false, false
    for _, line in ipairs(vim.api.nvim_buf_get_lines(buf, 0, 200, false)) do
        api_version = api_version or line:find("^apiVersion:") ~= nil
        kind = kind or line:find("^kind:") ~= nil
        if api_version and kind then
            return true
        end
    end
    return false
end

local function associate(client, buf)
    local manifests = client.settings.yaml.schemas.kubernetes
    local path = vim.api.nvim_buf_get_name(buf)
    if path ~= "" and not vim.tbl_contains(manifests, path) and is_manifest(buf) then
        table.insert(manifests, path)
        client:notify("workspace/didChangeConfiguration", { settings = client.settings })
    end
end

return {
    settings = {
        yaml = {
            schemas = { kubernetes = {} },
            keyOrdering = false,
        },
    },
    on_attach = function(client, buf)
        associate(client, buf)
        -- A manifest written from scratch only has its apiVersion and kind once saved
        vim.api.nvim_create_autocmd("BufWritePost", {
            buffer = buf,
            callback = function() associate(client, buf) end,
        })
    end,
}
