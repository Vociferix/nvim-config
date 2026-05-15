-- ============================================================
-- init.lua — Neovim entry point
-- ============================================================
-- Load core settings first, then bootstrap lazy.nvim
require("core.options")
require("core.keymaps")
require("core.autocmds")
require("core.lazy")   -- bootstraps lazy.nvim and loads plugins
