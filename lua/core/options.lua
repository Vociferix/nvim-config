-- ============================================================
-- core/options.lua — General Neovim settings
-- ============================================================

local opt = vim.opt

-- Silence upstream-plugin deprecation warnings until they catch up to nvim 0.12
vim.deprecate = function() end

-- ── Appearance ──────────────────────────────────────────────
opt.termguicolors  = true         -- 24-bit colour
opt.number         = true
opt.relativenumber = false
opt.signcolumn     = "yes"        -- always show sign column (no jitter)
opt.cursorline     = true         -- highlight current line
opt.scrolloff      = 8            -- keep 8 lines above/below cursor
opt.sidescrolloff  = 8
opt.colorcolumn    = "100"        -- soft ruler
opt.showmode       = false        -- lualine shows the mode instead
opt.cmdheight      = 1
opt.pumheight      = 10           -- max items in completion popup

-- ── Tabs / Indentation ───────────────────────────────────────
opt.tabstop        = 4
opt.shiftwidth     = 4
opt.softtabstop    = 4
opt.expandtab      = true         -- spaces, not tabs
opt.smartindent    = true
opt.wrap           = false        -- no line wrapping

-- ── Search ──────────────────────────────────────────────────
opt.ignorecase     = true
opt.smartcase      = true         -- case-sensitive when uppercase used
opt.hlsearch       = true
opt.incsearch      = true

-- ── Files / Undo ────────────────────────────────────────────
opt.undofile       = true         -- persistent undo across sessions
opt.swapfile       = false
opt.backup         = false
opt.updatetime     = 250          -- faster CursorHold events (used by LSP)
opt.timeoutlen     = 300          -- faster which-key popup

-- ── Splits ──────────────────────────────────────────────────
opt.splitright     = true
opt.splitbelow     = true
opt.laststatus     = 3    -- single global statusline across all splits

-- ── Clipboard ───────────────────────────────────────────────
opt.clipboard      = "unnamedplus"  -- sync with system clipboard

-- ── Completion ──────────────────────────────────────────────
opt.completeopt    = { "menu", "menuone", "noselect" }

-- ── Folding (using nvim-ufo / treesitter) ───────────────────
opt.foldcolumn     = "1"
opt.foldlevel      = 99           -- open all folds by default
opt.foldlevelstart = 99
opt.foldenable     = true
