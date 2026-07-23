# Neovim Config

Lua-based Neovim configuration built around native LSP, Treesitter,
blink.cmp, conform.nvim, Telescope, and gitsigns.

## Structure

```text
~/.config/nvim/
├── init.lua
├── lazy-lock.json
└── lua/
    ├── config/
    │   ├── options.lua
    │   ├── keymaps.lua
    │   ├── lazy.lua
    │   └── platform.lua
    └── plugins/
        ├── ui.lua
        ├── search.lua
        ├── git.lua
        ├── completion.lua
        ├── treesitter.lua
        ├── lsp.lua
        └── format.lua
```

## Requirements

Required:

- Neovim 0.12 or newer
- Git

Optional tools are detected before use. Missing language servers, formatters,
`rg`, compilers, or language toolchains do not prevent Neovim from starting.

- `tree-sitter` plus a C compiler: install/update Treesitter parsers
- `rg`: Telescope live grep
- `make` plus a C compiler: telescope-fzf-native
- Language servers: `gopls`, `rust-analyzer`, `clangd`, `zls`,
  `bash-language-server`, `pyright-langserver`,
  `typescript-language-server`, `sourcekit-lsp`, `jdtls`
- Formatters: `goimports`, `rustfmt`, `clang-format`,
  `google-java-format`

Mason is available as an optional installer:

```vim
:Mason
:MasonInstall jdtls google-java-format
```

Language tools already installed through Homebrew, SDKMAN, `uv`, Go, Cargo,
or the system package manager can be used directly from `PATH`.

## First-time Setup

```sh
git clone <repo> ~/.config/nvim
nvim
```

lazy.nvim installs plugins on first launch. Install the parsers you need
explicitly so an offline startup never attempts a network download:

```vim
:TSInstall c cpp rust go python javascript typescript tsx bash lua zig
:TSInstall java json toml yaml markdown markdown_inline vim vimdoc regex query
```

Installed parsers are enabled automatically. Missing parsers fall back to
Neovim's built-in syntax files.

To restore locked plugin versions:

```vim
:Lazy restore
```

## Language Support

### Go

- `gopls`: navigation, diagnostics, refactoring, and code actions
- `goimports` through conform.nvim: format on save and organize imports
- Treesitter: highlighting and text objects

No separate Go all-in-one plugin is required.

### Java

`jdtls` is enabled only when both the executable and a Java 21+ runtime are
available. The launcher prefers an installed SDKMAN Java 21+ runtime without
changing SDKMAN's global `current` version. Project JDKs installed through
SDKMAN are exposed to jdtls, including Java 8 as `JavaSE-1.8`.

Each project gets a workspace derived from its canonical root path, avoiding
collisions between projects with the same directory name.

### C, C++, and Swift

`clangd` handles C/C++ on every platform. On macOS, `sourcekit-lsp` is limited
to Swift so the two servers do not attach to the same C/C++ buffer.

## Key Mappings

Leader key: `<Space>`.

### LSP-attached buffers

| Key | Action |
|---|---|
| `gd` | Go to definition |
| `gr` | References |
| `gi` | Implementation |
| `gs` | Document symbols |
| `gS` | Workspace symbols |
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
| `<leader>fs` | Grep word under cursor |

### Git

| Key | Action |
|---|---|
| `]h` / `[h` | Next / previous hunk |
| `<leader>hs` | Stage hunk |
| `<leader>hu` | Reset hunk |
| `<leader>hb` | Blame line |

### Treesitter text objects

| Key | Action |
|---|---|
| `af` / `if` | Outer / inner function |
| `ac` / `ic` | Outer / inner class |
| `aa` / `ia` | Outer / inner parameter |
| `]f` / `[f` | Next / previous function |
| `]c` / `[c` | Next / previous class |

The UI uses ASCII separators and does not require a Nerd Font.
