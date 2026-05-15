-- ============================================================
-- plugins/lsp.lua — LSP, Mason, and related tooling
-- ============================================================
return {
  -- ── Mason (LSP/tool installer) ────────────────────────────
  {
    "williamboman/mason.nvim",
    cmd  = "Mason",
    keys = { { "<leader>lm", "<cmd>Mason<cr>", desc = "Mason installer" } },
    opts = { ui = { border = "rounded" } },
  },

  -- ── mason-lspconfig bridge ────────────────────────────────
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    opts = {
      ensure_installed = {
        "rust_analyzer",  -- Rust
        "clangd",         -- C/C++
        "pyright",        -- Python (type-aware)
        "ruff_lsp",       -- Python (fast linting / formatting)
        "lua_ls",         -- Lua (for editing this config!)
        "cmake",          -- CMake
        "taplo",          -- TOML
      },
      automatic_installation = true,
    },
  },

  -- ── nvim-lspconfig ────────────────────────────────────────
  {
    "neovim/nvim-lspconfig",
    event        = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
      { "folke/neodev.nvim", opts = {} },   -- Neovim API completions in lua files
    },
    config = function()
      -- Shared on_attach: runs for every LSP server
      local on_attach = function(_, bufnr)
        local map = vim.keymap.set
        local buf = { noremap = true, silent = true, buffer = bufnr }

        -- Navigation
        map("n", "gd",         vim.lsp.buf.definition,       vim.tbl_extend("force", buf, { desc = "Go to definition" }))
        map("n", "gD",         vim.lsp.buf.declaration,      vim.tbl_extend("force", buf, { desc = "Go to declaration" }))
        map("n", "gi",         vim.lsp.buf.implementation,   vim.tbl_extend("force", buf, { desc = "Go to implementation" }))
        map("n", "gr",         vim.lsp.buf.references,       vim.tbl_extend("force", buf, { desc = "References" }))
        map("n", "gt",         vim.lsp.buf.type_definition,  vim.tbl_extend("force", buf, { desc = "Type definition" }))
        -- Info
        map("n", "K",          vim.lsp.buf.hover,            vim.tbl_extend("force", buf, { desc = "Hover docs" }))
        map("n", "<C-k>",      vim.lsp.buf.signature_help,   vim.tbl_extend("force", buf, { desc = "Signature help" }))
        -- Actions
        map("n", "<leader>lr", vim.lsp.buf.rename,           vim.tbl_extend("force", buf, { desc = "Rename symbol" }))
        map({ "n", "v" }, "<leader>la", vim.lsp.buf.code_action, vim.tbl_extend("force", buf, { desc = "Code action" }))
        map("n", "<leader>lf", function() vim.lsp.buf.format({ async = true }) end,
                                                              vim.tbl_extend("force", buf, { desc = "Format file" }))
        -- Workspace
        map("n", "<leader>lwa", vim.lsp.buf.add_workspace_folder,    vim.tbl_extend("force", buf, { desc = "Add workspace folder" }))
        map("n", "<leader>lwr", vim.lsp.buf.remove_workspace_folder, vim.tbl_extend("force", buf, { desc = "Remove workspace folder" }))
      end

      -- Capabilities with nvim-cmp completions
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- Diagnostic appearance
      vim.diagnostic.config({
        underline        = true,
        update_in_insert = false,
        virtual_text     = { spacing = 4, prefix = "●" },
        severity_sort    = true,
        float            = { border = "rounded", source = "always" },
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = " ",
            [vim.diagnostic.severity.WARN]  = " ",
            [vim.diagnostic.severity.HINT]  = "󰠠 ",
            [vim.diagnostic.severity.INFO]  = " ",
          },
        },
      })

      local lspconfig = require("lspconfig")

      -- ── Rust ─────────────────────────────────────────────
      -- NOTE: rust-tools / rustaceanvim is configured in plugins/rust.lua
      -- rust_analyzer is managed there, NOT here.

      -- ── C / C++ ──────────────────────────────────────────
      lspconfig.clangd.setup({
        on_attach    = on_attach,
        capabilities = capabilities,
        cmd = {
          "clangd",
          "--background-index",
          "--clang-tidy",
          "--header-insertion=iwyu",
          "--completion-style=detailed",
          "--function-arg-placeholders",
          "--fallback-style=llvm",
        },
        init_options = {
          usePlaceholders    = true,
          completeUnimported = true,
          clangdFileStatus   = true,
        },
      })

      -- ── Python ───────────────────────────────────────────
      lspconfig.pyright.setup({
        on_attach    = on_attach,
        capabilities = capabilities,
        settings = {
          python = {
            analysis = {
              typeCheckingMode   = "basic",
              autoSearchPaths    = true,
              useLibraryCodeForTypes = true,
            },
          },
        },
      })

      lspconfig.ruff_lsp.setup({
        on_attach    = on_attach,
        capabilities = capabilities,
      })

      -- ── Lua ──────────────────────────────────────────────
      lspconfig.lua_ls.setup({
        on_attach    = on_attach,
        capabilities = capabilities,
        settings = {
          Lua = {
            runtime     = { version = "LuaJIT" },
            workspace   = { checkThirdParty = false },
            telemetry   = { enable = false },
            completion  = { callSnippet = "Replace" },
          },
        },
      })

      -- ── TOML ─────────────────────────────────────────────
      lspconfig.taplo.setup({ on_attach = on_attach, capabilities = capabilities })

      -- ── CMake ────────────────────────────────────────────
      lspconfig.cmake.setup({ on_attach = on_attach, capabilities = capabilities })
    end,
  },

  -- ── mason-null-ls: formatters and linters via null-ls ─────
  {
    "jay-babu/mason-null-ls.nvim",
    event        = { "BufReadPre", "BufNewFile" },
    dependencies = { "williamboman/mason.nvim", "nvimtools/none-ls.nvim" },
    opts = {
      ensure_installed = {
        "black",      -- Python formatter
        "isort",      -- Python import sorter
        "clang_format", -- C/C++ formatter
        "stylua",     -- Lua formatter
        "cmake_format",
      },
      automatic_installation = true,
    },
  },

  -- ── none-ls (null-ls maintained fork) ────────────────────
  {
    "nvimtools/none-ls.nvim",
    event        = { "BufReadPre", "BufNewFile" },
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local null_ls = require("null-ls")
      null_ls.setup({
        sources = {
          null_ls.builtins.formatting.black.with({ extra_args = { "--line-length=100" } }),
          null_ls.builtins.formatting.isort,
          null_ls.builtins.formatting.clang_format,
          null_ls.builtins.formatting.stylua,
        },
      })
    end,
  },
}
