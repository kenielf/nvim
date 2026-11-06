return {
    on_attach = function(client)
        -- basedpyright's hover is the useful one
        client.server_capabilities.hoverProvider = false
    end,
}
