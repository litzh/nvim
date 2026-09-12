local formatters_by_ft = {
    c    = { "clang_format" },
    cpp  = { "clang_format" },
    rust = { "rustfmt" },
    go   = { "goimports" },
    java = { "google-java-format" },
}

return {
    {
        "stevearc/conform.nvim",
        opts = {
            formatters_by_ft = formatters_by_ft,
            formatters = {
                clang_format = {
                    prepend_args = function(_, ctx)
                        local found = vim.fs.find(".clang-format", {
                            upward = true,
                            path   = ctx.dirname,
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
                local formatters = formatters_by_ft[vim.bo[bufnr].filetype]
                if not formatters then return nil end

                local info = require("conform").get_formatter_info(formatters[1], bufnr)
                if not info.available then return nil end
                return { timeout_ms = 1000, lsp_format = "never" }
            end,
        },
    },
}
