return {
    {
        "nvim-treesitter/nvim-treesitter",
        lazy  = false,
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter").setup()

            vim.api.nvim_create_autocmd("FileType", {
                group = vim.api.nvim_create_augroup("treesitter_start", { clear = true }),
                callback = function(ev)
                    pcall(vim.treesitter.start, ev.buf)
                end,
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

            local function safe_call(fn, ...)
                local ok = pcall(fn, ...)
                if not ok then
                    vim.notify(
                        "Treesitter parser or textobjects query is unavailable for this buffer",
                        vim.log.levels.WARN
                    )
                end
            end

            local function map_select(lhs, query)
                vim.keymap.set({ "x", "o" }, lhs, function()
                    safe_call(sel.select_textobject, query, "textobjects")
                end)
            end
            map_select("af", "@function.outer")
            map_select("if", "@function.inner")
            map_select("ac", "@class.outer")
            map_select("ic", "@class.inner")
            map_select("aa", "@parameter.outer")
            map_select("ia", "@parameter.inner")

            local function map_move(lhs, fn, query)
                vim.keymap.set({ "n", "x", "o" }, lhs, function()
                    safe_call(fn, query, "textobjects")
                end)
            end
            map_move("]f", move.goto_next_start,     "@function.outer")
            map_move("[f", move.goto_previous_start, "@function.outer")
            map_move("]c", move.goto_next_start,     "@class.outer")
            map_move("[c", move.goto_previous_start, "@class.outer")
        end,
    },
}
