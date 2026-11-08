-- Current Kubernetes context and namespace for the statusline. kubectl only runs when a
-- kubeconfig file changes, a redraw only compares modification times.
local M = {}

-- Contexts matching this Lua pattern are shown as dangerous
vim.g.kube_danger_pattern = vim.g.kube_danger_pattern or "prod"

local state = { stamp = nil, context = nil, namespace = nil }

local function kubeconfigs()
    local env = vim.env.KUBECONFIG
    if env and env ~= "" then
        return vim.split(env, ":", { trimempty = true })
    end
    return { vim.fn.expand("~/.kube/config") }
end

-- Changes whenever a kubeconfig file is written or KUBECONFIG points elsewhere
local function stamp()
    local parts = {}
    for _, path in ipairs(kubeconfigs()) do
        local stat = vim.uv.fs_stat(path)
        table.insert(parts, path .. "@" .. (stat and stat.mtime.sec .. "." .. stat.mtime.nsec or "-"))
    end
    return table.concat(parts, ",")
end

local function refresh()
    vim.system({
        "kubectl", "config", "view", "--minify",
        "-o", "jsonpath={.current-context}{'\\t'}{.contexts[0].context.namespace}",
    }, { text = true }, vim.schedule_wrap(function(result)
        local context, namespace = (result.stdout or ""):match("^([^\t]*)\t?(.*)$")
        state.context = result.code == 0 and context ~= "" and context or nil
        state.namespace = namespace ~= "" and namespace or "default"
        vim.cmd.redrawstatus()
    end))
end

---@return string
function M.status()
    local current = stamp()
    if current ~= state.stamp then
        state.stamp = current
        refresh()
    end
    if not state.context then
        return ""
    end
    return ("%s%s/%s"):format(vim.g.tty and "k8s:" or "󱃾 ", state.context, state.namespace)
end

local has_kubectl
function M.available()
    if has_kubectl == nil then
        has_kubectl = vim.fn.executable("kubectl") == 1
    end
    return has_kubectl
end

function M.is_dangerous()
    return state.context ~= nil and state.context:find(vim.g.kube_danger_pattern) ~= nil
end

return M
