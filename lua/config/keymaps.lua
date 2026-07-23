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
vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("lsp_keymaps", { clear = true }),
    callback = function(ev)
        local function opts(desc)
            return { buffer = ev.buf, desc = desc }
        end

        vim.keymap.set("n", "gd",         vim.lsp.buf.definition,       opts("Go to definition"))
        vim.keymap.set("n", "gs",         vim.lsp.buf.document_symbol,  opts("Document symbols"))
        vim.keymap.set("n", "gS",         vim.lsp.buf.workspace_symbol, opts("Workspace symbols"))
        vim.keymap.set("n", "gr",         vim.lsp.buf.references,       opts("References"))
        vim.keymap.set("n", "gi",         vim.lsp.buf.implementation,   opts("Implementation"))
        vim.keymap.set("n", "K",          vim.lsp.buf.hover,            opts("Hover documentation"))
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename,           opts("Rename symbol"))
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action,      opts("Code action"))
        vim.keymap.set("n", "<leader>e",  vim.diagnostic.open_float,    opts("Show diagnostic"))
        vim.keymap.set("n", "[g", function()
            vim.diagnostic.jump({ count = -1, float = true })
        end, opts("Previous diagnostic"))
        vim.keymap.set("n", "]g", function()
            vim.diagnostic.jump({ count = 1, float = true })
        end, opts("Next diagnostic"))
    end,
})
