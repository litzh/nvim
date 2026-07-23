return {
    {
        "saghen/blink.cmp",
        version = "*",
        lazy    = false,
        opts = {
            keymap  = { preset = "default" },
            sources = {
                default = { "lsp", "path", "snippets", "buffer" },
            },
            completion = { documentation = { auto_show = true } },
        },
    },
}
