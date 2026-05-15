-- ============================================================
-- plugins/treesitter.lua — Syntax highlighting & code awareness
-- ============================================================
return {
  {
    "nvim-treesitter/nvim-treesitter",
    lazy  = false,  -- new rewrite does not support lazy-loading
    build = ":TSUpdate",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
      "nvim-treesitter/nvim-treesitter-context",
    },
    config = function()
      -- Install parsers (no-op if already installed)
      require("nvim-treesitter").install({
        "bash", "c", "cmake", "cpp", "lua", "luadoc",
        "make", "markdown", "markdown_inline",
        "python", "rust", "toml", "vim", "vimdoc",
      })

      -- Enable treesitter highlighting and indent for all filetypes
      vim.api.nvim_create_autocmd("FileType", {
        callback = function()
          local ok = pcall(vim.treesitter.start)
          if ok then
            vim.bo.indentexpr = 'v:lua.require"nvim-treesitter".indentexpr()'
          end
        end,
      })

      -- Textobjects configuration
      require("nvim-treesitter-textobjects").setup({
        select = { lookahead = true },
        move   = { set_jumps = true },
      })

      local sel  = require("nvim-treesitter-textobjects.select")
      local mov  = require("nvim-treesitter-textobjects.move")
      local swap = require("nvim-treesitter-textobjects.swap")

      -- Select text objects
      local function sel_map(key, capture)
        vim.keymap.set({ "x", "o" }, key, function()
          sel.select_textobject(capture, "textobjects")
        end)
      end
      sel_map("af", "@function.outer")
      sel_map("if", "@function.inner")
      sel_map("ac", "@class.outer")
      sel_map("ic", "@class.inner")
      sel_map("aa", "@parameter.outer")
      sel_map("ia", "@parameter.inner")
      sel_map("ab", "@block.outer")
      sel_map("ib", "@block.inner")

      -- Move between text objects
      local function mov_map(key, fn, capture)
        vim.keymap.set({ "n", "x", "o" }, key, function()
          fn(capture, "textobjects")
        end)
      end
      mov_map("]f", mov.goto_next_start,     "@function.outer")
      mov_map("]c", mov.goto_next_start,     "@class.outer")
      mov_map("[f", mov.goto_previous_start, "@function.outer")
      mov_map("[c", mov.goto_previous_start, "@class.outer")

      -- Swap parameters
      vim.keymap.set("n", "<leader>rn", function() swap.swap_next("@parameter.inner") end)
      vim.keymap.set("n", "<leader>rp", function() swap.swap_previous("@parameter.inner") end)

      -- Sticky context (shows function/class header when scrolled deep inside)
      require("treesitter-context").setup({
        enable     = true,
        max_lines  = 4,
        trim_scope = "outer",
        mode       = "cursor",
      })
    end,
  },
}
