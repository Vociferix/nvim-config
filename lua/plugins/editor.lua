-- ============================================================
-- plugins/editor.lua — Quality-of-life editing plugins
-- ============================================================
return {
  -- ── Auto-pairs ────────────────────────────────────────────
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts  = {
      check_ts = true,   -- use treesitter to decide when to pair
      ts_config = {
        lua  = { "string", "source" },
        rust = { "string", "string_fragment" },
      },
    },
    config = function(_, opts)
      local autopairs = require("nvim-autopairs")
      autopairs.setup(opts)
      -- Connect to cmp so <CR> doesn't break autopairs
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
    end,
  },

  -- ── Surround (ys, cs, ds) ─────────────────────────────────
  {
    "kylechui/nvim-surround",
    event   = "BufReadPost",
    version = "*",
    opts    = {},
  },

  -- ── Comment (gc / gb) ─────────────────────────────────────
  {
    "numToStr/Comment.nvim",
    event = "BufReadPost",
    opts  = {},
  },

  -- ── Flash (fast motion / search) ─────────────────────────
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    keys  = {
      { "s",     function() require("flash").jump() end,              mode = { "n", "x", "o" }, desc = "Flash jump" },
      { "S",     function() require("flash").treesitter() end,        mode = { "n", "x", "o" }, desc = "Flash treesitter" },
      { "r",     function() require("flash").remote() end,            mode = "o",               desc = "Flash remote" },
      { "<c-s>", function() require("flash").toggle() end,            mode = "c",               desc = "Flash toggle search" },
    },
    opts = {},
  },

  -- ── Mini.nvim suite ───────────────────────────────────────
  {
    "echasnovski/mini.nvim",
    event   = "BufReadPost",
    version = "*",
    config = function()
      -- Show whitespace characters
      require("mini.trailspace").setup()
      -- Better text objects: aa, ia, etc.
      require("mini.ai").setup({ n_lines = 500 })
      -- Split/join arguments, arrays, objects
      require("mini.splitjoin").setup()
      -- Highlight uses of word under cursor
      require("mini.cursorword").setup()
    end,
  },

  -- ── nvim-ufo (folding) ────────────────────────────────────
  {
    "kevinhwang91/nvim-ufo",
    dependencies = { "kevinhwang91/promise-async" },
    event        = "BufReadPost",
    keys = {
      { "zR", function() require("ufo").openAllFolds() end,  desc = "Open all folds" },
      { "zM", function() require("ufo").closeAllFolds() end, desc = "Close all folds" },
      { "K",  function()
          local winid = require("ufo").peekFoldedLinesUnderCursor()
          if not winid then vim.lsp.buf.hover() end
        end, desc = "Peek fold / hover" },
    },
    opts = {
      provider_selector = function() return { "treesitter", "indent" } end,
    },
  },

  -- ── Spectre (project-wide search & replace) ───────────────
  {
    "nvim-pack/nvim-spectre",
    cmd          = "Spectre",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>sr", function() require("spectre").open() end,                                  desc = "Spectre: Replace in project" },
      { "<leader>sw", function() require("spectre").open_visual({ select_word = true }) end,     desc = "Spectre: Replace word" },
      { "<leader>sf", function() require("spectre").open_file_search({ select_word = true }) end, desc = "Spectre: Replace in file" },
    },
    opts = {},
  },

  -- ── inc-rename (live rename preview) ─────────────────────
  {
    "smjonas/inc-rename.nvim",
    cmd = "IncRename",
    keys = {
      { "<leader>lr", function() return ":IncRename " .. vim.fn.expand("<cword>") end, expr = true, desc = "LSP: Rename (live)" },
    },
    opts = {},
  },

  -- ── Undotree ──────────────────────────────────────────────
  {
    "mbbill/undotree",
    cmd  = "UndotreeToggle",
    keys = { { "<leader>u", "<cmd>UndotreeToggle<cr>", desc = "Undotree" } },
  },

  -- ── toggleterm (persistent terminal panes) ────────────────
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    keys = {
      { "<A-1>", "<cmd>ToggleTerm direction=horizontal<cr>", mode = { "n", "t" }, desc = "Terminal (bottom)" },
      { "<A-2>", "<cmd>ToggleTerm direction=vertical<cr>",   mode = { "n", "t" }, desc = "Terminal (side)" },
      { "<A-3>", "<cmd>ToggleTerm direction=float<cr>",      mode = { "n", "t" }, desc = "Terminal (center)" },
    },
    opts = {
      size = function(term)
        if term.direction == "horizontal" then return 15
        elseif term.direction == "vertical" then return vim.o.columns * 0.4
        end
      end,
      open_mapping = false,
      shading_factor = 2,
      direction = "float",
      float_opts = { border = "curved" },
    },
  },

  -- ── Harpoon 2 (quick file bookmarks) ─────────────────────
  {
    "ThePrimeagen/harpoon",
    branch       = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>ha", function() require("harpoon"):list():add() end,                              desc = "Harpoon: Add file" },
      { "<leader>hh", function() require("harpoon").ui:toggle_quick_menu(require("harpoon"):list()) end, desc = "Harpoon: Menu" },
      { "<leader>1",  function() require("harpoon"):list():select(1) end,                          desc = "Harpoon: File 1" },
      { "<leader>2",  function() require("harpoon"):list():select(2) end,                          desc = "Harpoon: File 2" },
      { "<leader>3",  function() require("harpoon"):list():select(3) end,                          desc = "Harpoon: File 3" },
      { "<leader>4",  function() require("harpoon"):list():select(4) end,                          desc = "Harpoon: File 4" },
    },
    opts = {},
  },
}
