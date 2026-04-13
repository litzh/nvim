return {
    { "tpope/vim-fugitive" },

    {
        "lewis6991/gitsigns.nvim",
        event = "BufReadPre",
        opts  = {
            signs = {
                add    = { text = "+" },
                change = { text = "~" },
                delete = { text = "-" },
            },
            on_attach = function(bufnr)
                local gs = require("gitsigns")
                local o  = { buffer = bufnr }
                vim.keymap.set("n", "]h",         gs.next_hunk,  o)
                vim.keymap.set("n", "[h",         gs.prev_hunk,  o)
                vim.keymap.set("n", "<leader>hs", gs.stage_hunk, o)
                vim.keymap.set("n", "<leader>hu", gs.reset_hunk, o)
                vim.keymap.set("n", "<leader>hb", gs.blame_line, o)
            end,
        },
    },
}
