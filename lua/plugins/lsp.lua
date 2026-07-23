local plt = require("config.platform")

local function java_major(home)
    local release = home and (home .. "/release") or nil
    if not release or vim.fn.filereadable(release) ~= 1 then return nil end

    for _, line in ipairs(vim.fn.readfile(release)) do
        local version = line:match('^JAVA_VERSION="([^"]+)"')
        if version then
            return tonumber(version:match("^1%.(%d+)") or version:match("^(%d+)"))
        end
    end
end

local function sdkman_java_homes()
    if plt.is_windows then return {} end

    local base = vim.env.SDKMAN_CANDIDATES_DIR
        and (vim.env.SDKMAN_CANDIDATES_DIR .. "/java")
        or  (vim.fn.expand("~/.sdkman/candidates/java"))
    if not vim.uv.fs_stat(base) then return {} end

    local homes, seen = {}, {}
    local function add(path)
        local real = vim.uv.fs_realpath(path)
        if real and not seen[real] and java_major(real) then
            seen[real] = true
            table.insert(homes, real)
        end
    end

    add(base .. "/current")
    local handle = vim.uv.fs_scandir(base)
    if handle then
        while true do
            local entry = vim.uv.fs_scandir_next(handle)
            if not entry then break end
            if entry ~= "current" then add(base .. "/" .. entry) end
        end
    end

    table.sort(homes, function(a, b)
        return java_major(a) > java_major(b)
    end)
    return homes
end

local function java_runtimes()
    local runtimes = {}
    for _, home in ipairs(sdkman_java_homes()) do
        local major = java_major(home)
        table.insert(runtimes, {
            name = major == 8 and "JavaSE-1.8" or ("JavaSE-" .. major),
            path = home,
        })
    end
    return runtimes
end

local function java_launcher_home()
    local env_home = vim.env.JAVA_HOME
    if env_home and (java_major(env_home) or 0) >= 21 then
        return vim.uv.fs_realpath(env_home) or env_home
    end
    for _, home in ipairs(sdkman_java_homes()) do
        if java_major(home) >= 21 then return home end
    end

    local java_bin = plt.find_bin("java")
    if java_bin then
        local result = vim.system(
            { java_bin, "-XshowSettings:properties", "-version" },
            { text = true }
        ):wait(3000)
        local output = (result.stdout or "") .. "\n" .. (result.stderr or "")
        local home = output:match("java%.home%s*=%s*([^\r\n]+)")
        if home and (java_major(home) or 0) >= 21 then
            return vim.uv.fs_realpath(home) or home
        end
    end
end

local function jdtls_cmd(jdtls_bin)
    return function(dispatchers, config)
        local root = config.root_dir or vim.fn.getcwd()
        local project = vim.fs.basename(root) .. "-" .. vim.fn.sha256(root):sub(1, 12)
        local data_dir = vim.fn.stdpath("cache") .. "/jdtls/" .. project
        local cmd = { jdtls_bin, "-data", data_dir }

        for arg in (vim.env.JDTLS_JVM_ARGS or ""):gmatch("%S+") do
            table.insert(cmd, "--jvm-arg=" .. arg)
        end

        return vim.lsp.rpc.start(cmd, dispatchers, {
            cwd      = config.cmd_cwd,
            env      = config.cmd_env,
            detached = config.detached,
        })
    end
end

return {
    {
        "mason-org/mason.nvim",
        lazy = false,
        opts = {},
    },

    {
        "neovim/nvim-lspconfig",
        lazy         = false,
        dependencies = {
            "mason-org/mason.nvim",
            "saghen/blink.cmp",
        },
        config = function()
            local capabilities = require("blink.cmp").get_lsp_capabilities()
            capabilities.workspace = capabilities.workspace or {}
            capabilities.workspace.didChangeWatchedFiles = {
                dynamicRegistration = false,
            }
            local servers = {
                rust_analyzer = { bin = "rust-analyzer" },
                gopls         = { bin = "gopls" },
                clangd        = { bin = "clangd" },
                zls           = { bin = "zls" },
                bashls        = { bin = "bash-language-server" },
                pyright       = { bin = "pyright-langserver" },
                ts_ls         = { bin = "typescript-language-server" },
                sourcekit     = {
                    bin       = "sourcekit-lsp",
                    condition = plt.is_mac,
                    config    = { filetypes = { "swift" } },
                },
            }

            for name, server in pairs(servers) do
                if server.condition ~= false and plt.find_bin(server.bin) then
                    local config = vim.tbl_deep_extend(
                        "force",
                        server.config or {},
                        { capabilities = capabilities }
                    )
                    vim.lsp.config(name, config)
                    vim.lsp.enable(name)
                end
            end

            local jdtls_bin = plt.find_bin("jdtls")
            local java_home = jdtls_bin and java_launcher_home() or nil
            if jdtls_bin and java_home then
                vim.lsp.config("jdtls", {
                    cmd          = jdtls_cmd(jdtls_bin),
                    cmd_env      = { JAVA_HOME = java_home },
                    capabilities = capabilities,
                    settings = {
                        java = {
                            configuration = { runtimes = java_runtimes() },
                            eclipse       = { downloadSources = true },
                            maven         = { downloadSources = true },
                            references    = { includeDecompiledSources = true },
                            inlayHints    = { parameterNames = { enabled = "all" } },
                        },
                    },
                })
                vim.lsp.enable("jdtls")
            end
        end,
    },
}
