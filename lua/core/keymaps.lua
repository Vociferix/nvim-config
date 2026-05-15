-- ============================================================
-- core/keymaps.lua — Base key mappings (plugin keys live in each plugin spec)
-- ============================================================

vim.g.mapleader      = " "
vim.g.maplocalleader = "\\"

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- ── General ─────────────────────────────────────────────────
map("n", "<leader>w", "<cmd>w<cr>",          vim.tbl_extend("force", opts, { desc = "Save file" }))
map("n", "<leader>q", "<cmd>q<cr>",          vim.tbl_extend("force", opts, { desc = "Quit" }))
map("n", "<leader>Q", "<cmd>qa!<cr>",        vim.tbl_extend("force", opts, { desc = "Quit all (force)" }))
map("n", "<Esc>",     "<cmd>nohlsearch<cr>", vim.tbl_extend("force", opts, { desc = "Clear search highlight" }))

-- ── Window navigation (Ctrl+hjkl) ───────────────────────────
map("n", "<C-h>", "<C-w>h", vim.tbl_extend("force", opts, { desc = "Window left" }))
map("n", "<C-j>", "<C-w>j", vim.tbl_extend("force", opts, { desc = "Window down" }))
map("n", "<C-k>", "<C-w>k", vim.tbl_extend("force", opts, { desc = "Window up" }))
map("n", "<C-l>", "<C-w>l", vim.tbl_extend("force", opts, { desc = "Window right" }))

-- ── Resize windows ──────────────────────────────────────────
map("n", "<C-Up>",    "<cmd>resize +2<cr>",          vim.tbl_extend("force", opts, { desc = "Resize up" }))
map("n", "<C-Down>",  "<cmd>resize -2<cr>",          vim.tbl_extend("force", opts, { desc = "Resize down" }))
map("n", "<C-Left>",  "<cmd>vertical resize -2<cr>", vim.tbl_extend("force", opts, { desc = "Resize left" }))
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", vim.tbl_extend("force", opts, { desc = "Resize right" }))

-- ── Buffer navigation ────────────────────────────────────────
map("n", "<S-h>",      "<cmd>bprevious<cr>",  vim.tbl_extend("force", opts, { desc = "Prev buffer" }))
map("n", "<S-l>",      "<cmd>bnext<cr>",      vim.tbl_extend("force", opts, { desc = "Next buffer" }))
map("n", "<leader>bd", "<cmd>bdelete<cr>",    vim.tbl_extend("force", opts, { desc = "Delete buffer" }))

-- ── Move lines (Alt+jk) ─────────────────────────────────────
map("n", "<A-j>", "<cmd>m .+1<cr>==",        vim.tbl_extend("force", opts, { desc = "Move line down" }))
map("n", "<A-k>", "<cmd>m .-2<cr>==",        vim.tbl_extend("force", opts, { desc = "Move line up" }))
map("v", "<A-j>", ":m '>+1<cr>gv=gv",       vim.tbl_extend("force", opts, { desc = "Move selection down" }))
map("v", "<A-k>", ":m '<-2<cr>gv=gv",       vim.tbl_extend("force", opts, { desc = "Move selection up" }))

-- ── Stay in visual mode when indenting ──────────────────────
map("v", "<", "<gv", opts)
map("v", ">", ">gv", opts)

-- ── Paste without losing register ───────────────────────────
map("v", "p", '"_dP', opts)

-- ── Quickfix / diagnostics navigation ───────────────────────
map("n", "[d", vim.diagnostic.goto_prev,  vim.tbl_extend("force", opts, { desc = "Prev diagnostic" }))
map("n", "]d", vim.diagnostic.goto_next,  vim.tbl_extend("force", opts, { desc = "Next diagnostic" }))
map("n", "[q", "<cmd>cprev<cr>",          vim.tbl_extend("force", opts, { desc = "Prev quickfix" }))
map("n", "]q", "<cmd>cnext<cr>",          vim.tbl_extend("force", opts, { desc = "Next quickfix" }))

-- ── Terminal ─────────────────────────────────────────────────
map("t", "<Esc><Esc>", "<C-\\><C-n>", vim.tbl_extend("force", opts, { desc = "Exit terminal mode" }))
