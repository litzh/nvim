# Neovim Config

Personal Neovim configuration in Lua. Migrated from Vim + vim-plug.

## Structure

```
~/.config/nvim/
├── init.lua              # Entry point: set leader, load config/*
├── lazy-lock.json        # Plugin version lockfile
└── lua/
    ├── config/
    │   ├── options.lua   # vim.opt settings
    │   ├── keymaps.lua   # Global keymaps + LspAttach
    │   ├── lazy.lua      # lazy.nvim bootstrap
    │   └── platform.lua  # OS detection helpers (is_mac, find_bin)
    └── plugins/
        ├── ui.lua        # Colorscheme (kanagawa), statusline (lualine)
        ├── search.lua    # Telescope + fzf-native
        ├── git.lua       # vim-fugitive, gitsigns
        ├── completion.lua # blink.cmp, copilot.vim
        ├── treesitter.lua # nvim-treesitter, textobjects
        ├── lsp.lua       # nvim-lspconfig, nvim-jdtls (Java)
        ├── format.lua    # conform.nvim
        └── lang.lua      # Language plugins (rust.vim, vim-go, etc.)
```

## Requirements

| Dependency | Purpose | Install |
|---|---|---|
| Neovim >= 0.11 | — | `brew install neovim` |
| git | Plugin download | system |
| `tree-sitter` CLI | Compile treesitter parsers | `brew install tree-sitter-cli` |
| `rg` (ripgrep) | Telescope grep | `brew install ripgrep` |
| `make` + `gcc` | telescope-fzf-native | system |
| `node` | Copilot | `brew install node` |

LSP servers are managed by Mason (`:MasonInstall <name>`). Installed servers:
`rust-analyzer`, `gopls`, `clangd`, `zls`, `bash-language-server`, `pyright`,
`typescript-language-server`, `sourcekit` (macOS), `jdtls` (Java)

## First-time Setup

```sh
git clone <repo> ~/.config/nvim
nvim  # lazy.nvim auto-installs all plugins on first launch
```

To restore the exact plugin versions from `lazy-lock.json`:
```
:Lazy restore
```

## Key Mappings

Leader key: `<Space>`

### LSP (LSP-attached buffers)

| Key | Action |
|---|---|
| `gd` | Go to definition |
| `gr` | References |
| `gi` | Implementation |
| `gS` | Workspace symbol search |
| `K` | Hover |
| `<leader>rn` | Rename |
| `<leader>ca` | Code action |
| `<leader>e` | Show diagnostic |
| `[g` / `]g` | Previous / next diagnostic |

### Telescope

| Key | Action |
|---|---|
| `<leader>ff` | Find files |
| `<leader>fg` | Live grep |
| `<leader>fb` | Buffers |
| `<leader>fs` | Grep word under cursor (whole-word) |

### Git (gitsigns)

| Key | Action |
|---|---|
| `]h` / `[h` | Next / previous hunk |
| `<leader>hs` | Stage hunk |
| `<leader>hu` | Reset hunk |
| `<leader>hb` | Blame line |

### Treesitter textobjects

| Key | Action |
|---|---|
| `af` / `if` | Outer / inner function |
| `ac` / `ic` | Outer / inner class |
| `aa` / `ia` | Outer / inner parameter |
| `]f` / `[f` | Next / previous function |
| `]c` / `[c` | Next / previous class |

### Go (vim-go, overrides `gi`/`gr` in Go buffers)

| Key | Action |
|---|---|
| `<C-k>` | GoInfo |
| `gi` | GoImplements |
| `gr` | GoReferrers |
| `gb` | GoDefStack |

## Notes

- **Fonts**: No Nerd Font required. If you install one and set it in your terminal, remove the `section_separators` / `component_separators` override in `plugins/ui.lua` and the `signs` override in `plugins/git.lua` to restore the default icons.
- **clang-format**: Uses inline style as fallback. A `.clang-format` file in the project root takes precedence automatically.
- **Java**: Requires `:MasonInstall jdtls`. Java runtimes are auto-detected from SDKMAN; falls back to `java` in PATH.
- **Python LSP**: Uses `pyright` (installed via `uv tool install pyright`).
