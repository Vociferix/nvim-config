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
        "rust_analyzer",  -- Rust (also managed by rustaceanvim)
        "clangd",         -- C/C++
        "pyright",        -- Python (type-aware)
        "ruff",           -- Python (fast linting / formatting)
        "lua_ls",         -- Lua (for editing this config!)
        "cmake",          -- CMake
        "taplo",          -- TOML
      },
      automatic_installation = true,
    },
  },

  -- ── lazydev (Neovim API completions in Lua files) ─────────
  {
    "folke/lazydev.nvim",
    ft   = "lua",
    opts = {
      library = {
        { path = "luvit-meta/library", words = { "vim%.uv" } },
      },
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
      "folke/lazydev.nvim",
    },
    config = function()
      -- Keymaps applied whenever any LSP attaches
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(ev)
          local bufnr = ev.buf
          local map   = vim.keymap.set
          local buf   = { noremap = true, silent = true, buffer = bufnr }

          map("n", "gd",  vim.lsp.buf.definition,      vim.tbl_extend("force", buf, { desc = "Go to definition" }))
          map("n", "gD",  vim.lsp.buf.declaration,     vim.tbl_extend("force", buf, { desc = "Go to declaration" }))
          map("n", "gi",  vim.lsp.buf.implementation,  vim.tbl_extend("force", buf, { desc = "Go to implementation" }))
          map("n", "gr",  vim.lsp.buf.references,      vim.tbl_extend("force", buf, { desc = "References" }))
          map("n", "gt",  vim.lsp.buf.type_definition, vim.tbl_extend("force", buf, { desc = "Type definition" }))
          map("n", "K",   vim.lsp.buf.hover,           vim.tbl_extend("force", buf, { desc = "Hover docs" }))
          map("n", "<C-k>", vim.lsp.buf.signature_help, vim.tbl_extend("force", buf, { desc = "Signature help" }))
          map("n", "<leader>lr", function() return ":IncRename " .. vim.fn.expand("<cword>") end,
                                              vim.tbl_extend("force", buf, { expr = true, desc = "Rename (live)" }))
          map({ "n", "v" }, "<leader>la", vim.lsp.buf.code_action, vim.tbl_extend("force", buf, { desc = "Code action" }))
          map("n", "<leader>lf", function() vim.lsp.buf.format({ async = true }) end,
                                                        vim.tbl_extend("force", buf, { desc = "Format file" }))
          map("n", "<leader>lwa", vim.lsp.buf.add_workspace_folder,    vim.tbl_extend("force", buf, { desc = "Add workspace folder" }))
          map("n", "<leader>lwr", vim.lsp.buf.remove_workspace_folder, vim.tbl_extend("force", buf, { desc = "Remove workspace folder" }))
        end,
      })

      -- Global capabilities (applied to every server)
      vim.lsp.config("*", {
        capabilities = require("cmp_nvim_lsp").default_capabilities(),
      })

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

      -- ── C / C++ ──────────────────────────────────────────
      vim.lsp.config("clangd", {
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
      vim.lsp.config("pyright", {
        settings = {
          python = {
            analysis = {
              typeCheckingMode       = "basic",
              autoSearchPaths        = true,
              useLibraryCodeForTypes = true,
            },
          },
        },
      })

      -- ── Lua ──────────────────────────────────────────────
      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            runtime    = { version = "LuaJIT" },
            workspace  = { checkThirdParty = false },
            telemetry  = { enable = false },
            completion = { callSnippet = "Replace" },
          },
        },
      })

      -- Enable all servers (ruff, taplo, cmake use lspconfig defaults)
      vim.lsp.enable({ "clangd", "pyright", "ruff", "lua_ls", "taplo", "cmake" })
    end,
  },

  -- ── mason-null-ls: formatters and linters via null-ls ─────
  {
    "jay-babu/mason-null-ls.nvim",
    event        = { "BufReadPre", "BufNewFile" },
    dependencies = { "williamboman/mason.nvim", "nvimtools/none-ls.nvim" },
    opts = {
      ensure_installed = {
        "black",        -- Python formatter
        "isort",        -- Python import sorter
        "clang_format", -- C/C++ formatter
        "stylua",       -- Lua formatter
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
