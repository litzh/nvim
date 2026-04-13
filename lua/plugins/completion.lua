local plt = require("config.platform")

return {
    -- blink.cmp: completion engine
    {
        "saghen/blink.cmp",
        version      = "*",
        event        = "InsertEnter",
        dependencies = { "fang2hou/blink-copilot" },
        opts = {
            keymap  = { preset = "default" },
            sources = {
                default   = { "lsp", "path", "buffer", "copilot" },
                providers = {
                    copilot = {
                        name         = "copilot",
                        module       = "blink-copilot",
                        score_offset = 100,
                        async        = true,
                    },
                },
            },
            completion = { documentation = { auto_show = true } },
        },
    },

    -- GitHub Copilot (requires Node.js)
    {
        "github/copilot.vim",
        cond  = function() return plt.find_bin("node") ~= nil end,
        event = "InsertEnter",
        config = function()
            -- Disable copilot's own inline display; blink-copilot handles it.
            vim.g.copilot_filetypes = {
                ["*"]      = false,
                rust       = true,
                go         = true,
                python     = true,
                lua        = true,
                c          = true,
                java       = true,
                javascript = true,
                typescript = true,
            }
        end,
    },
}
