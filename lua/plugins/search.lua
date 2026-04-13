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
                    return vim.fn.executable("make") == 1 and vim.fn.executable("gcc") == 1
                end,
            },
        },
        keys = {
            { "<leader>ff", "<cmd>Telescope find_files<cr>",  desc = "Find files" },
            { "<leader>fg", "<cmd>Telescope live_grep<cr>",   desc = "Live grep" },
            { "<leader>fb", "<cmd>Telescope buffers<cr>",     desc = "Buffers" },
            -- <leader>fs: whole-word grep (mirrors old ack.vim -w behaviour)
            { "<leader>fs", "<cmd>Telescope grep_string<cr>", desc = "Grep word under cursor" },
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
