local plt = require("config.platform")

return {
    -- Mason: manages LSP / formatter binary installation
    {
        "williamboman/mason.nvim",
        build = ":MasonUpdate",
        opts  = {},
    },

    -- nvim-lspconfig: provides lsp/*.lua config files (cmd, filetypes, root_dir).
    -- We use vim.lsp.config / vim.lsp.enable (Neovim 0.11+ native API) and do
    -- NOT call require('lspconfig') directly — that path is deprecated in v3.
    {
        "neovim/nvim-lspconfig",
        lazy = false,
        config = function()
            local ok, blink = pcall(require, "blink.cmp")
            local capabilities = ok
                and blink.get_lsp_capabilities()
                or  vim.lsp.protocol.make_client_capabilities()

            local servers = {
                rust_analyzer = {},
                clangd        = {
                    cmd = {
                        "clangd",
                        "--experimental-modules-support",
                    },
                },
                zls           = {},
                bashls        = {},
                pyright       = {},
                ts_ls         = {},
                -- sourcekit-lsp only exists on macOS
                sourcekit     = plt.is_mac and {} or nil,
                -- jdtls is handled by nvim-jdtls (needs per-project workspace)
            }

            for name, cfg in pairs(servers) do
                if cfg ~= nil then
                    cfg.capabilities = capabilities
                    vim.lsp.config(name, cfg)   -- merges into lsp/<name>.lua config
                    vim.lsp.enable(name)
                end
            end
        end,
    },

    -- Java LSP (jdtls requires per-project workspace — nvim-jdtls handles this)
    {
        "mfussenegger/nvim-jdtls",
        ft = "java",
        config = function()
            local jdtls     = require("jdtls")
            local jdtls_dir = vim.fn.stdpath("data") .. "/mason/packages/jdtls"
            local workspace = vim.fn.stdpath("data") .. "/jdtls-workspaces/"
                .. vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")

            local launcher = vim.fn.glob(
                jdtls_dir .. "/plugins/org.eclipse.equinox.launcher_*.jar", true)
            if launcher == "" then
                vim.notify("jdtls not found — run :MasonInstall jdtls", vim.log.levels.WARN)
                return
            end

            local config_dir = jdtls_dir
                .. (plt.is_windows and "/config_win"
                    or plt.is_mac   and "/config_mac"
                    or               "/config_linux")

            -- Prefer SDKMAN's active Java, fall back to PATH
            local sdkman_java = vim.fn.expand("$SDKMAN_CANDIDATES_DIR/java/current/bin/java")
            local java_bin    = vim.uv.fs_stat(sdkman_java) and sdkman_java
                                or plt.find_bin("java")
            if not java_bin then
                vim.notify("No java binary found; jdtls will not start", vim.log.levels.WARN)
                return
            end
            local java_home = java_bin:gsub(plt.is_windows and "\\bin\\java%.exe$" or "/bin/java$", "")

            -- Build runtime list from installed SDKMAN versions
            local runtimes = {}
            local sdkman_dir = vim.fn.expand("$SDKMAN_CANDIDATES_DIR/java")
            if vim.uv.fs_stat(sdkman_dir) then
                local handle = vim.uv.fs_scandir(sdkman_dir)
                if handle then
                    while true do
                        local entry = vim.uv.fs_scandir_next(handle)
                        if not entry then break end
                        local major = entry ~= "current" and entry:match("^(%d+)")
                        if major then
                            local path = sdkman_dir .. "/" .. entry
                            table.insert(runtimes, {
                                name    = "JavaSE-" .. major,
                                path    = path,
                                default = (path == java_home),
                            })
                        end
                    end
                end
            end

            local ok, blink = pcall(require, "blink.cmp")
            jdtls.start_or_attach({
                cmd = {
                    java_bin,
                    "-Declipse.application=org.eclipse.jdt.ls.core.id1",
                    "-Dosgi.bundles.defaultStartLevel=4",
                    "-Declipse.product=org.eclipse.jdt.ls.core.product",
                    "-Dlog.level=ALL",
                    "-Xmx2g",
                    "--add-modules=ALL-SYSTEM",
                    "--add-opens", "java.base/java.util=ALL-UNNAMED",
                    "--add-opens", "java.base/java.lang=ALL-UNNAMED",
                    "-jar", launcher,
                    "-configuration", config_dir,
                    "-data", workspace,
                },
                root_dir     = jdtls.setup.find_root({ "pom.xml", "build.gradle", ".git" }),
                capabilities = ok and blink.get_lsp_capabilities()
                               or  vim.lsp.protocol.make_client_capabilities(),
                settings = {
                    java = {
                        configuration = { runtimes = runtimes },
                        eclipse       = { downloadSources = true },
                        maven         = { downloadSources = true },
                        references    = { includeDecompiledSources = true },
                        inlayHints    = { parameterNames = { enabled = "all" } },
                    },
                },
            })
        end,
    },
}
