return {
    -- Colorscheme
    {
        "rebelot/kanagawa.nvim",
        lazy     = false,
        priority = 1000,
        config   = function() vim.cmd.colorscheme("kanagawa") end,
    },

    -- Statusline
    {
        "nvim-lualine/lualine.nvim",
        event = "VeryLazy",
        opts  = {
            options  = {
                theme                = "kanagawa",
                section_separators   = { left = "", right = "" },
                component_separators = { left = "|", right = "|" },
            },
            sections = {
                lualine_b = { "branch", "diff", "diagnostics" },
                lualine_c = { { "filename", path = 1 } },
            },
        },
    },
}
