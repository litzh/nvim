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
                local function opts(desc)
                    return { buffer = bufnr, desc = desc }
                end
                vim.keymap.set("n", "]h", function()
                    gs.nav_hunk("next")
                end, opts("Next Git hunk"))
                vim.keymap.set("n", "[h", function()
                    gs.nav_hunk("prev")
                end, opts("Previous Git hunk"))
                vim.keymap.set("n", "<leader>hs", gs.stage_hunk, opts("Stage Git hunk"))
                vim.keymap.set("n", "<leader>hu", gs.reset_hunk, opts("Reset Git hunk"))
                vim.keymap.set("n", "<leader>hb", gs.blame_line, opts("Blame line"))
            end,
        },
    },
}
