return {
    {
        "stevearc/conform.nvim",
        opts = {
            formatters_by_ft = {
                c    = { "clang_format" },
                cpp  = { "clang_format" },
                rust = { "rustfmt" },
                java = { "google-java-format" },
            },
            formatters = {
                clang_format = {
                    -- Prefer a project-level .clang-format file when present.
                    -- The inline style below is the fallback.
                    prepend_args = function()
                        local found = vim.fs.find(".clang-format", {
                            upward = true,
                            path   = vim.fn.expand("%:p:h"),
                        })
                        if #found > 0 then return {} end
                        return {
                            "--style={"
                            .. "BasedOnStyle: LLVM, "
                            .. "AccessModifierOffset: -4, "
                            .. "AlignConsecutiveAssignments: false, "
                            .. "AlignConsecutiveDeclarations: false, "
                            .. "AlignOperands: true, "
                            .. "AlignTrailingComments: false, "
                            .. "AlwaysBreakTemplateDeclarations: Yes, "
                            .. "BreakBeforeBraces: Attach, "
                            .. "BreakConstructorInitializers: BeforeComma, "
                            .. "ColumnLimit: 120, "
                            .. "ContinuationIndentWidth: 8, "
                            .. "IncludeCategories: ["
                            ..   "{Regex: '^<.*', Priority: 1}, "
                            ..   "{Regex: '^\".*', Priority: 2}, "
                            ..   "{Regex: '.*', Priority: 3}"
                            .. "], "
                            .. "IncludeIsMainRegex: '([-_](test|unittest))?$', "
                            .. "IndentCaseLabels: false, "
                            .. "IndentWidth: 4, "
                            .. "InsertNewlineAtEOF: true, "
                            .. "MaxEmptyLinesToKeep: 2, "
                            .. "SpaceAfterTemplateKeyword: false, "
                            .. "SpaceBeforeRangeBasedForLoopColon: false, "
                            .. "SpacesInAngles: false, "
                            .. "TabWidth: 4"
                            .. "}",
                        }
                    end,
                },
            },
            format_on_save = function(bufnr)
                local ft = vim.bo[bufnr].filetype
                if ft == "c" or ft == "cpp" or ft == "rust" or ft == "java" then
                    return { timeout_ms = 1000, lsp_format = "never" }
                end
            end,
        },
    },
}
