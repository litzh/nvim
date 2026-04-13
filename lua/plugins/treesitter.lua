return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        -- New API: require("nvim-treesitter").setup() only takes { install_dir }.
        -- Highlight and indent are enabled via vim.treesitter directly (always-on
        -- in Neovim 0.9+). The setup call here just ensures parsers are installed.
        config = function()
            require("nvim-treesitter").setup()

            -- Install parsers on startup (async, non-blocking)
            require("nvim-treesitter.install").install({
                "c", "cpp", "rust", "go", "python",
                "javascript", "typescript", "tsx",
                "bash", "lua", "zig",
                "haskell", "swift", "typst", "java",
                "json", "toml", "yaml",
                "markdown", "markdown_inline",
                "vim", "vimdoc", "regex", "query",
            })
        end,
    },

    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        branch       = "main",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        config = function()
            local sel  = require("nvim-treesitter-textobjects.select")
            local move = require("nvim-treesitter-textobjects.move")

            require("nvim-treesitter-textobjects").setup({
                select = { lookahead = true },
                move   = { set_jumps = true },
            })

            -- Select text objects
            local function map_select(lhs, query)
                vim.keymap.set({ "x", "o" }, lhs, function()
                    sel.select_textobject(query, "textobjects")
                end)
            end
            map_select("af", "@function.outer")
            map_select("if", "@function.inner")
            map_select("ac", "@class.outer")
            map_select("ic", "@class.inner")
            map_select("aa", "@parameter.outer")
            map_select("ia", "@parameter.inner")

            -- Move between text objects
            local function map_move(lhs, fn, query)
                vim.keymap.set({ "n", "x", "o" }, lhs, function()
                    fn(query, "textobjects")
                end)
            end
            map_move("]f", move.goto_next_start,     "@function.outer")
            map_move("[f", move.goto_previous_start, "@function.outer")
            map_move("]c", move.goto_next_start,     "@class.outer")
            map_move("[c", move.goto_previous_start, "@class.outer")
        end,
    },
}
