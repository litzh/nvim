-- Leader must be set before lazy.nvim loads any plugin specs
vim.g.mapleader      = " "
vim.g.maplocalleader = "\\"

require("config.options")
require("config.keymaps")
require("config.lazy")
