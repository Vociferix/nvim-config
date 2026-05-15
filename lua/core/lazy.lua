-- ============================================================
-- core/lazy.lua — Bootstrap lazy.nvim and load all plugins
-- ============================================================

-- Auto-install lazy.nvim if not present
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  -- Import all plugin specs from lua/plugins/
  spec = { { import = "plugins" } },

  defaults = { lazy = true },   -- lazy-load everything by default

  install = { colorscheme = { "catppuccin", "habamax" } },

  checker = {
    enabled = true,   -- auto-check for plugin updates
    notify  = false,  -- don't notify on startup, use :Lazy to review
  },

  performance = {
    rtp = {
      -- Disable unused built-ins to speed up startup
      disabled_plugins = {
        "gzip", "matchit", "matchparen", "netrwPlugin",
        "tarPlugin", "tohtml", "tutor", "zipPlugin",
      },
    },
  },

  ui = { border = "rounded" },
})

-- Keymap to open Lazy UI
vim.keymap.set("n", "<leader>L", "<cmd>Lazy<cr>", { desc = "Lazy plugin manager" })
