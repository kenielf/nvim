-- jdtls is started per project by nvim-jdtls, which handles what the plain vim.lsp
-- config doesn't: jdt:// sources, the debug and test bundles, and refactoring commands.
if vim.fn.executable("java") == 0 then
    if not vim.g.java_missing_notified then
        vim.g.java_missing_notified = true
        vim.notify("No `java` on PATH, so jdtls can't start. jdtls needs JDK 21 or newer.", vim.log.levels.WARN)
    end
    return
end
if vim.fn.executable("jdtls") == 0 then
    if not vim.g.jdtls_missing_notified then
        vim.g.jdtls_missing_notified = true
        vim.notify("jdtls isn't installed yet. Try :ToolsInstall.", vim.log.levels.WARN)
    end
    return
end

local pack = require("custom.pack")
pack.load("nvim-jdtls")
local jdtls = require("jdtls")

local root = vim.fs.root(0, { "gradlew", "mvnw", "pom.xml", "build.gradle", "build.gradle.kts", "settings.gradle", ".git" })
    or vim.fn.getcwd()
local workspace = vim.fn.stdpath("cache") .. "/jdtls/" .. vim.fn.sha256(root):sub(1, 12) .. "-" .. vim.fs.basename(root)

local mason = vim.env.MASON .. "/packages/"
local bundles = vim.fn.glob(mason .. "java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar", true, true)
for _, jar in ipairs(vim.fn.glob(mason .. "java-test/extension/server/*.jar", true, true)) do
    -- Not OSGi bundles, jdtls can't load these two
    local name = vim.fs.basename(jar)
    if not name:find("com.microsoft.java.test.runner", 1, true) and not name:find("jacocoagent", 1, true) then
        table.insert(bundles, jar)
    end
end

-- Every installed JDK, so each project runs on the Java version it targets
-- whichever one `eselect java-vm` has as the system default
local function java_runtimes()
    local runtimes, seen = {}, {}
    local dirs = vim.fn.glob("/usr/lib*/openjdk-*", true, true)
    vim.list_extend(dirs, vim.fn.glob("/opt/openjdk-bin-*", true, true))
    for _, dir in ipairs(dirs) do
        local ok, release = pcall(vim.fn.readfile, dir .. "/release")
        local version = ok and table.concat(release, "\n"):match('JAVA_VERSION="(%d+)')
        if version and not seen[version] then
            seen[version] = true
            table.insert(runtimes, { name = "JavaSE-" .. version, path = dir })
        end
    end
    return runtimes
end

local extended_capabilities = jdtls.extendedClientCapabilities
extended_capabilities.resolveAdditionalTextEditsSupport = true

local cmd = { "jdtls", "-data", workspace }
local lombok = mason .. "jdtls/lombok.jar"
if vim.uv.fs_stat(lombok) then
    table.insert(cmd, "--jvm-arg=-javaagent:" .. lombok)
end

pack.load("blink.cmp")
jdtls.start_or_attach({
    cmd = cmd,
    root_dir = root,
    capabilities = require("blink.cmp").get_lsp_capabilities(),
    init_options = {
        bundles = bundles,
        extendedClientCapabilities = extended_capabilities,
    },
    settings = {
        java = {
            eclipse = { downloadSources = true },
            maven = { downloadSources = true },
            configuration = {
                updateBuildConfiguration = "interactive",
                runtimes = java_runtimes(),
            },
            implementationsCodeLens = { enabled = true },
            referencesCodeLens = { enabled = true },
            inlayHints = { parameterNames = { enabled = "all" } },
            signatureHelp = { enabled = true },
            contentProvider = { preferred = "fernflower" },
            format = { enabled = true },
            completion = {
                favoriteStaticMembers = {
                    "org.junit.jupiter.api.Assertions.*",
                    "org.hamcrest.Matchers.*",
                    "org.mockito.Mockito.*",
                    "java.util.Objects.requireNonNull",
                },
            },
            sources = { organizeImports = { starThreshold = 9999, staticStarThreshold = 9999 } },
            codeGeneration = { useBlocks = true },
        },
    },
    on_attach = function(_, buf)
        pack.load("nvim-dap")
        jdtls.setup_dap({ hotcodereplace = "auto" })
        require("jdtls.dap").setup_dap_main_class_configs()

        local function map(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { buffer = buf, desc = desc, silent = true })
        end
        map("n", "<a-o>", jdtls.organize_imports, "Organize imports")
        map("n", "<leader>Jv", jdtls.extract_variable, "Extract variable")
        map("x", "<leader>Jv", function() jdtls.extract_variable(true) end, "Extract variable")
        map("n", "<leader>Jc", jdtls.extract_constant, "Extract constant")
        map("x", "<leader>Jc", function() jdtls.extract_constant(true) end, "Extract constant")
        map("x", "<leader>Jm", function() jdtls.extract_method(true) end, "Extract method")
        map("n", "<leader>Jt", jdtls.test_class, "Test class")
        map("n", "<leader>JT", jdtls.test_nearest_method, "Test nearest method")
    end,
})
