-- ============================================================
-- plugins/rust.lua — Rust-specific tooling (rustaceanvim)
-- ============================================================
-- rustaceanvim is the modern successor to rust-tools.nvim.
-- It manages rust-analyzer itself, so don't also set it up in lsp.lua.
return {
  {
    "mrcjkb/rustaceanvim",
    version      = "^5",   -- use semver pin for stability
    ft           = { "rust" },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "mfussenegger/nvim-dap",  -- debug support
    },
    config = function()
      vim.g.rustaceanvim = {
        -- Tools config
        tools = {
          hover_actions = { auto_focus = true },
          inlay_hints   = { auto = true },
        },

        -- LSP config passed to rust-analyzer
        server = {
          on_attach = function(_, bufnr)
            local map = vim.keymap.set
            local buf = { noremap = true, silent = true, buffer = bufnr }

            -- Standard LSP keys are set globally via the LspAttach autocmd in lsp.lua.
            -- Only Rust-specific extras go here.
            -- Rust-specific extras
            map("n", "<leader>rr", function() vim.cmd.RustLsp("runnables") end,
                                                                  vim.tbl_extend("force", buf, { desc = "Rust: Runnables" }))
            map("n", "<leader>rt", function() vim.cmd.RustLsp("testables") end,
                                                                  vim.tbl_extend("force", buf, { desc = "Rust: Testables" }))
            map("n", "<leader>re", function() vim.cmd.RustLsp("expandMacro") end,
                                                                  vim.tbl_extend("force", buf, { desc = "Rust: Expand macro" }))
            map("n", "<leader>rc", function() vim.cmd.RustLsp("openCargo") end,
                                                                  vim.tbl_extend("force", buf, { desc = "Rust: Open Cargo.toml" }))
            map("n", "<leader>rm", function() vim.cmd.RustLsp("parentModule") end,
                                                                  vim.tbl_extend("force", buf, { desc = "Rust: Parent module" }))
            map("n", "<leader>rh", function() vim.cmd.RustLsp({ "hover", "range" }) end,
                                                                  vim.tbl_extend("force", buf, { desc = "Rust: Hover actions" }))
            map("n", "<leader>rd", function() vim.cmd.RustLsp("debuggables") end,
                                                                  vim.tbl_extend("force", buf, { desc = "Rust: Debuggables" }))
          end,

          settings = {
            ["rust-analyzer"] = {
              cargo = {
                loadOutDirsFromCheck = true,
                runBuildScripts = true,
              },
              checkOnSave = {
                command   = "clippy",  -- use clippy instead of check
                extraArgs = { "--no-deps" },
              },
              procMacro = {
                enable      = true,
                ignored     = {
                  ["async-trait"] = { "async_trait" },
                  ["napi-derive"] = { "napi" },
                },
              },
              inlayHints = {
                bindingModeHints         = { enable = false },
                chainingHints            = { enable = true },
                closingBraceHints        = { enable = true, minLines = 25 },
                closureReturnTypeHints   = { enable = "never" },
                lifetimeElisionHints     = { enable = "never" },
                parameterHints           = { enable = true },
                typeHints                = { enable = true },
              },
            },
          },
        },

        -- DAP config
        dap = { adapter = require("rustaceanvim.config").get_codelldb_adapter(
          -- mason installs codelldb here:
          vim.fn.stdpath("data") .. "/mason/bin/codelldb",
          vim.fn.stdpath("data") .. "/mason/packages/codelldb/extension/lldb/lib/liblldb.so"
        )},
      }
    end,
  },

  -- ── Crates.nvim (Cargo.toml dependency helper) ────────────
  {
    "Saecki/crates.nvim",
    event        = "BufRead Cargo.toml",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      lsp = {
        enabled    = true,
        actions    = true,
        completion = true,
        hover      = true,
      },
    },
    keys = {
      { "<leader>ct", function() require("crates").toggle() end,         desc = "Crates: toggle" },
      { "<leader>cr", function() require("crates").reload() end,         desc = "Crates: reload" },
      { "<leader>cu", function() require("crates").upgrade_crate() end,  desc = "Crates: upgrade" },
      { "<leader>cU", function() require("crates").upgrade_crates() end, desc = "Crates: upgrade all" },
    },
  },
}
