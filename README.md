# My Neovim Config

A full IDE-like Neovim setup for **Rust**, **C/C++**, and **Python** built on [lazy.nvim](https://github.com/folke/lazy.nvim).

## Requirements

| Tool | Why |
|------|-----|
| Neovim ≥ 0.10 | Required API features |
| Git | Plugin downloads |
| [Nerd Font](https://www.nerdfonts.com/) | Icons in UI (recommended: JetBrainsMono Nerd Font) |
| `make` | telescope-fzf-native build |
| `gcc` / `clang` | C/C++ LSP + treesitter parsers |
| `rustup` | Rust toolchain |
| `python3` + `pip` | Python LSP & debugger |
| `ripgrep` (`rg`) | Telescope live grep |
| `fd` | Telescope file finding |

Install on Ubuntu/Debian:
```bash
sudo apt install git gcc make ripgrep fd-find python3 python3-pip
```

Install on macOS:
```bash
brew install neovim git gcc make ripgrep fd python3
```

---

## Avoiding conflicts with existing configs

Neovim can pick up configuration from several places. Before installing, check
each of the following.

### 1. Old Vim files (`~/.vimrc`, `~/.vim/`)

Neovim does **not** read `~/.vimrc` or load `~/.vim/` by default. However,
if your shell sets the `VIMINIT` environment variable (check with
`echo $VIMINIT`), that value overrides Neovim's normal startup entirely.
If it points at an old vimrc, unset it in your shell profile.

```bash
# Check for it
echo $VIMINIT

# Remove it if set (add the matching unset to ~/.bashrc / ~/.zshrc)
unset VIMINIT
```

### 2. Existing Neovim config (`~/.config/nvim/`)

If you already have a Neovim config, back it up before cloning this one:

```bash
mv ~/.config/nvim ~/.config/nvim.bak
```

If `$XDG_CONFIG_HOME` is set in your environment, Neovim uses
`$XDG_CONFIG_HOME/nvim/` instead of `~/.config/nvim/`. Check with:

```bash
echo $XDG_CONFIG_HOME
```

If it's set, either adjust the clone target accordingly or be aware that
`~/.config/nvim/` may not be the active config location.

### 3. Leftover plugin data (`~/.local/share/nvim/`)

Neovim stores plugin files and caches under `~/.local/share/nvim/`. If you
previously used another plugin manager (Packer, vim-plug, etc.), old plugin
directories may still be there. They won't be loaded by lazy.nvim, but they
take up space and can occasionally cause `runtimepath` noise. Clean them out:

```bash
# Back up first if unsure
mv ~/.local/share/nvim ~/.local/share/nvim.bak
# Or just remove entirely for a clean slate
rm -rf ~/.local/share/nvim
```

### 4. Parallel Neovim distributions (LazyVim, AstroNvim, NvChad…)

If you have other Neovim configs set up under `NVIM_APPNAME` (a common pattern
with distros like LazyVim), they live in their own directories and won't
interfere as long as you launch Neovim normally. Confirm your default launch
isn't aliased to a different `NVIM_APPNAME`:

```bash
# Should show nothing (or the name you actually want)
echo $NVIM_APPNAME

# Check for aliases
alias nvim
```

### 5. System-wide configs (`/etc/xdg/nvim/`, `/usr/share/nvim/`)

Package-manager installs of Neovim sometimes ship a system-level
`sysinit.vim` at `/usr/share/nvim/sysinit.vim`. This is mostly harmless
(it just sets up `VIMRUNTIME`), but if you see unexpected behavior you can
check what Neovim is actually loading at startup:

```vim
:version          " shows all config paths Neovim searched
:echo $MYVIMRC    " shows which init file was actually loaded
:checkhealth      " broad environment sanity check
```

---

## Installation

```bash
# 1. Back up any existing config
mv ~/.config/nvim ~/.config/nvim.bak

# 2. Optionally clear plugin data for a clean slate
mv ~/.local/share/nvim ~/.local/share/nvim.bak

# 3. Clone this repo
git clone <your-repo-url> ~/.config/nvim

# 4. Launch Neovim — lazy.nvim bootstraps and installs all plugins
nvim
```

On first launch, lazy.nvim will install all plugins. Then Mason will auto-install
LSP servers and debug adapters. This may take a minute or two.

---

## Structure

```
~/.config/nvim/
├── init.lua                  ← Entry point
└── lua/
    ├── core/
    │   ├── options.lua       ← vim.opt settings
    │   ├── keymaps.lua       ← Base key mappings (Space leader)
    │   ├── autocmds.lua      ← Autocommands
    │   └── lazy.lua          ← lazy.nvim bootstrap + config
    └── plugins/
        ├── colorscheme.lua   ← One Dark theme
        ├── ui.lua            ← Lualine, bufferline, nvim-tree, which-key, noice…
        ├── treesitter.lua    ← Syntax highlighting + text objects
        ├── telescope.lua     ← Fuzzy finder
        ├── lsp.lua           ← Mason, lspconfig, null-ls (C/C++, Python, Lua)
        ├── rust.lua          ← rustaceanvim + crates.nvim
        ├── completion.lua    ← nvim-cmp + LuaSnip
        ├── dap.lua           ← Debug adapters + neotest
        ├── git.lua           ← Gitsigns, Neogit, Diffview
        └── editor.lua        ← Autopairs, surround, flash, harpoon, toggleterm…
```

---

## Key Mappings (Space leader)

### Navigation
| Key | Action |
|-----|--------|
| `<Space>ff` | Find files |
| `<Space>sg` | Live grep |
| `<Space>fr` | Recent files |
| `<Space>fb` | Open buffers |
| `<Space>e`  | Toggle file tree |
| `<S-h/l>`   | Prev/next buffer |
| `<Space>1-4`| Harpoon quick-jump |

### LSP
| Key | Action |
|-----|--------|
| `gd` | Go to definition |
| `gr` | References |
| `K`  | Hover docs |
| `<Space>lr` | Rename symbol |
| `<Space>la` | Code action |
| `<Space>lf` | Format file |
| `<Space>lm` | Open Mason |

### Rust extras
| Key | Action |
|-----|--------|
| `<Space>rr` | Runnables |
| `<Space>rt` | Testables |
| `<Space>re` | Expand macro |
| `<Space>rc` | Open Cargo.toml |
| `<Space>rd` | Debuggables |

### Debug (DAP)
| Key | Action |
|-----|--------|
| `<Space>db` | Toggle breakpoint |
| `<Space>dc` | Continue |
| `<Space>di` | Step into |
| `<Space>do` | Step over |
| `<Space>du` | Toggle DAP UI |

### Git
| Key | Action |
|-----|--------|
| `<Space>gg` | Neogit |
| `<Space>gd` | Diffview |
| `<Space>gc` | Git commits (Telescope) |
| `]h / [h`   | Next/prev hunk |
| `<Space>ghs`| Stage hunk |

### Terminal
| Key | Action |
|-----|--------|
| `<C-t>` | Toggle terminal |
| `<Space>tf` | Float terminal |
| `<Space>tt` | Run nearest test |

---

## Syncing to a New Machine

```bash
git clone <your-repo-url> ~/.config/nvim
nvim   # lazy.nvim auto-installs everything
```

## Reproducible Installs (optional)

Remove `lazy-lock.json` from `.gitignore` and commit it. This pins every
plugin to an exact commit, so every machine gets the identical versions.
Run `:Lazy update` periodically and commit the updated lockfile.

---

## Updating Plugins

- `:Lazy` — open the Lazy UI
- `:Lazy update` — update all plugins
- `:Mason` — manage LSP servers and debug adapters
- `:TSUpdate` — update treesitter parsers
