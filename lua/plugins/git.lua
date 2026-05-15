-- ============================================================
-- plugins/git.lua — Git integration
-- ============================================================
return {
  -- ── Gitsigns (inline blame, hunk navigation, staging) ────
  {
    "lewis6991/gitsigns.nvim",
    event = "BufReadPre",
    opts = {
      signs = {
        add          = { text = "▎" },
        change       = { text = "▎" },
        delete       = { text = "" },
        topdelete    = { text = "" },
        changedelete = { text = "▎" },
        untracked    = { text = "▎" },
      },
      on_attach = function(bufnr)
        local gs  = package.loaded.gitsigns
        local map = vim.keymap.set
        local buf = { buffer = bufnr }

        -- Hunk navigation
        map("n", "]h", function() if vim.wo.diff then return "]c" end vim.schedule(gs.next_hunk) return "<Ignore>" end,
          vim.tbl_extend("force", buf, { expr = true, desc = "Next hunk" }))
        map("n", "[h", function() if vim.wo.diff then return "[c" end vim.schedule(gs.prev_hunk) return "<Ignore>" end,
          vim.tbl_extend("force", buf, { expr = true, desc = "Prev hunk" }))

        -- Hunk actions
        map({ "n", "v" }, "<leader>ghs", "<cmd>Gitsigns stage_hunk<cr>",     vim.tbl_extend("force", buf, { desc = "Stage hunk" }))
        map({ "n", "v" }, "<leader>ghr", "<cmd>Gitsigns reset_hunk<cr>",     vim.tbl_extend("force", buf, { desc = "Reset hunk" }))
        map("n", "<leader>ghS",          gs.stage_buffer,                     vim.tbl_extend("force", buf, { desc = "Stage buffer" }))
        map("n", "<leader>ghu",          gs.undo_stage_hunk,                  vim.tbl_extend("force", buf, { desc = "Undo stage hunk" }))
        map("n", "<leader>ghR",          gs.reset_buffer,                     vim.tbl_extend("force", buf, { desc = "Reset buffer" }))
        map("n", "<leader>ghp",          gs.preview_hunk,                     vim.tbl_extend("force", buf, { desc = "Preview hunk" }))
        map("n", "<leader>ghb", function() gs.blame_line({ full = true }) end, vim.tbl_extend("force", buf, { desc = "Blame line" }))
        map("n", "<leader>ghd",          gs.diffthis,                         vim.tbl_extend("force", buf, { desc = "Diff this" }))

        -- Text object for hunks
        map({ "o", "x" }, "ih", "<cmd><C-U>Gitsigns select_hunk<cr>", vim.tbl_extend("force", buf, { desc = "Select hunk" }))
      end,
    },
  },

  -- ── Neogit (Magit-like interactive git) ──────────────────
  {
    "NeogitOrg/neogit",
    cmd          = "Neogit",
    dependencies = { "nvim-lua/plenary.nvim", "sindrets/diffview.nvim" },
    keys = {
      { "<leader>gg", "<cmd>Neogit<cr>", desc = "Neogit" },
    },
    opts = {
      integrations = { diffview = true },
    },
  },

  -- ── Diffview (side-by-side diffs, history browser) ────────
  {
    "sindrets/diffview.nvim",
    cmd  = { "DiffviewOpen", "DiffviewFileHistory" },
    keys = {
      { "<leader>gd", "<cmd>DiffviewOpen<cr>",        desc = "Diff view" },
      { "<leader>gH", "<cmd>DiffviewFileHistory %<cr>", desc = "File history" },
    },
    opts = {},
  },
}
