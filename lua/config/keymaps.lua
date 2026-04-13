vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<cr>")
vim.keymap.set("n", "<F5>",  "<cmd>nohlsearch<cr>")

-- Visual-line navigation for prose filetypes
vim.api.nvim_create_autocmd("FileType", {
    group   = vim.api.nvim_create_augroup("text_nav", { clear = true }),
    pattern = { "text", "markdown" },
    callback = function()
        vim.keymap.set({ "n", "v" }, "j", "gj", { buffer = true })
        vim.keymap.set({ "n", "v" }, "k", "gk", { buffer = true })
    end,
})

-- LSP keymaps applied to every LSP-attached buffer.
-- Note: Go buffers have vim-go override K/gi/gr (see plugins/lang.lua).
vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("lsp_keymaps", { clear = true }),
    callback = function(ev)
        local o = { buffer = ev.buf }
        vim.keymap.set("n", "gd",         vim.lsp.buf.definition,       o)
        vim.keymap.set("n", "gs",         vim.lsp.buf.document_symbol,  o)
        vim.keymap.set("n", "gS",         vim.lsp.buf.workspace_symbol, o)
        vim.keymap.set("n", "gr",         vim.lsp.buf.references,       o)
        vim.keymap.set("n", "gi",         vim.lsp.buf.implementation,   o)
        vim.keymap.set("n", "K",          vim.lsp.buf.hover,            o)
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename,           o)
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action,      o)
        vim.keymap.set("n", "<leader>e",  vim.diagnostic.open_float,    o)
        vim.keymap.set("n", "[g",         vim.diagnostic.goto_prev,     o)
        vim.keymap.set("n", "]g",         vim.diagnostic.goto_next,     o)
    end,
})
