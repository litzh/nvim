-- Language-specific plugins: syntax, tooling, and per-filetype keymaps.
local plt = require("config.platform")

return {
    -- Rust: keep for :RustFmt and rustfmt integration; autosave handled by conform
    {
        "rust-lang/rust.vim",
        ft = "rust",
        config = function()
            vim.g.rustfmt_emit_files = 1
            vim.g.rustfmt_autosave   = 0
        end,
    },

    -- Go: vim-go provides tooling (GoTest, GoImplements, GoReferrers, etc.)
    -- beyond what gopls offers. Its LSP/completion/def features are disabled
    -- to avoid conflict with nvim-lspconfig.
    {
        "fatih/vim-go",
        build = ":GoUpdateBinaries",
        ft    = "go",
        config = function()
            vim.g.go_fmt_command             = "goimports"
            vim.g.go_def_mapping_enabled     = 0
            vim.g.go_doc_keywordprg_enabled  = 0
            vim.g.go_code_completion_enabled = 0
        end,
        init = function()
            -- gi/gr intentionally shadow LSP bindings in Go buffers.
            -- Other LSP navigation remains available via gd / K / gS etc.
            vim.api.nvim_create_autocmd("FileType", {
                group   = vim.api.nvim_create_augroup("go_maps", { clear = true }),
                pattern = "go",
                callback = function()
                    local o = { buffer = true }
                    vim.keymap.set("n", "<C-k>", "<cmd>GoInfo<CR>",         o)
                    vim.keymap.set("n", "gi",    "<cmd>GoImplements<CR>",   o)
                    vim.keymap.set("n", "gr",    "<cmd>GoReferrers<CR>",    o)
                    vim.keymap.set("n", "gb",    "<cmd>GoDefStack<CR>",     o)
                end,
            })
        end,
    },

    -- Markdown
    {
        "preservim/vim-markdown",
        ft = "markdown",
        config = function()
            vim.g.vim_markdown_folding_disabled = 1
        end,
    },

    -- Syntax-only: languages not fully covered by treesitter
    { "neovimhaskell/haskell-vim", ft = "haskell" },
    { "pprovost/vim-ps1",          ft = "ps1" },
    { "voldikss/vim-mma",          ft = { "mma", "wl" } },
    { "ron-rs/ron.vim",            ft = "ron" },
    { "rhysd/vim-wasm",            ft = "wat" },
    { "keith/swift.vim",           ft = "swift", cond = plt.is_mac },
}
