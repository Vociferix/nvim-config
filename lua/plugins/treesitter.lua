-- ============================================================
-- plugins/treesitter.lua — Syntax highlighting & code awareness
-- ============================================================
return {
  {
    "nvim-treesitter/nvim-treesitter",
    build  = ":TSUpdate",
    event  = { "BufReadPost", "BufNewFile" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",  -- smart text objects
      "nvim-treesitter/nvim-treesitter-context",      -- sticky function headers
    },
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "bash", "c", "cmake", "cpp", "lua", "luadoc",
          "make", "markdown", "markdown_inline",
          "python", "rust", "toml", "vim", "vimdoc",
        },
        auto_install     = true,
        highlight        = { enable = true },
        indent           = { enable = true },

        -- Smart text objects (select / move around functions, classes, etc.)
        textobjects = {
          select = {
            enable    = true,
            lookahead = true,
            keymaps = {
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["ac"] = "@class.outer",
              ["ic"] = "@class.inner",
              ["aa"] = "@parameter.outer",
              ["ia"] = "@parameter.inner",
              ["ab"] = "@block.outer",
              ["ib"] = "@block.inner",
            },
          },
          move = {
            enable              = true,
            set_jumps           = true,
            goto_next_start     = { ["]f"] = "@function.outer", ["]c"] = "@class.outer" },
            goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer" },
          },
          swap = {
            enable               = true,
            swap_next            = { ["<leader>rn"] = "@parameter.inner" },
            swap_previous        = { ["<leader>rp"] = "@parameter.inner" },
          },
        },
      })

      -- Sticky context (shows function/class header when scrolled deep inside)
      require("treesitter-context").setup({
        enable          = true,
        max_lines       = 4,
        trim_scope      = "outer",
        mode            = "cursor",
      })
    end,
  },
}
