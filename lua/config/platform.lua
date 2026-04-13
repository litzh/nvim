-- Shared platform helpers, required by plugin specs that need them.
local M = {}

M.is_mac     = vim.fn.has("mac") == 1
M.is_windows = vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1

-- Returns the binary name if executable, nil otherwise.
-- On Windows also checks .exe / .cmd suffixes.
function M.find_bin(name)
    if vim.fn.executable(name) == 1 then return name end
    if M.is_windows then
        for _, ext in ipairs({ ".exe", ".cmd" }) do
            if vim.fn.executable(name .. ext) == 1 then return name .. ext end
        end
    end
    return nil
end

return M
