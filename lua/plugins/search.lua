local plt = require("config.platform")

return {
    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            {
                "nvim-telescope/telescope-fzf-native.nvim",
                build = plt.is_windows
                    and "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release"
                    or  "make",
                -- Skip silently when build tools are absent
                cond = function()
                    if plt.is_windows then
                        return vim.fn.executable("cmake") == 1
                    end
                    return vim.fn.executable("make") == 1
                        and (vim.fn.executable("cc") == 1
                            or vim.fn.executable("gcc") == 1
                            or vim.fn.executable("clang") == 1)
                end,
            },
        },
        keys = {
            {
                "<leader>ff",
                function() require("telescope.builtin").find_files() end,
                desc = "Find files",
            },
            {
                "<leader>fg",
                function()
                    if not plt.find_bin("rg") then
                        vim.notify("live_grep requires ripgrep (rg)", vim.log.levels.WARN)
                        return
                    end
                    require("telescope.builtin").live_grep()
                end,
                desc = "Live grep",
            },
            {
                "<leader>fb",
                function() require("telescope.builtin").buffers() end,
                desc = "Buffers",
            },
            {
                "<leader>fs",
                function()
                    if not plt.find_bin("rg") then
                        vim.notify("grep_string requires ripgrep (rg)", vim.log.levels.WARN)
                        return
                    end
                    require("telescope.builtin").grep_string()
                end,
                desc = "Grep word under cursor",
            },
        },
        config = function()
            local telescope = require("telescope")
            telescope.setup({
                defaults = {
                    vimgrep_arguments = {
                        "rg", "--color=never", "--no-heading",
                        "--with-filename", "--line-number", "--column",
                        "--smart-case",
                    },
                },
                pickers = {
                    grep_string = { word_match = "-w" },
                },
            })
            pcall(telescope.load_extension, "fzf")
        end,
    },
}
