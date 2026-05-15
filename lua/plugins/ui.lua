-- ============================================================
-- plugins/ui.lua — Status bar, buffer tabs, file tree, UI polish
-- ============================================================
return {
  -- ── Lualine (status bar) ──────────────────────────────────
  {
    "nvim-lualine/lualine.nvim",
    event        = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        theme                = "tokyonight",
        globalstatus         = true,
        component_separators = { left = "", right = "" },
        section_separators   = { left = "", right = "" },
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = { { "filename", path = 1 } },
        lualine_x = { "encoding", "fileformat", "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
    },
  },

  -- ── Bufferline (tabs for open buffers) ────────────────────
  {
    "akinsho/bufferline.nvim",
    event        = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      { "<leader>bp", "<cmd>BufferLineTogglePin<cr>",            desc = "Pin buffer" },
      { "<leader>bP", "<cmd>BufferLineGroupClose ungrouped<cr>", desc = "Close unpinned buffers" },
    },
    opts = {
      options = {
        diagnostics             = "nvim_lsp",
        always_show_bufferline  = false,
        separator_style         = "slant",
        offsets = {
          { filetype = "NvimTree", text = "File Explorer", padding = 1 },
        },
      },
    },
  },

  -- ── nvim-tree (file explorer) ─────────────────────────────
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd          = { "NvimTreeToggle", "NvimTreeFocus" },
    keys = {
      { "<leader>e",  "<cmd>NvimTreeToggle<cr>", desc = "Toggle file tree" },
      { "<leader>fe", "<cmd>NvimTreeFocus<cr>",  desc = "Focus file tree" },
    },
    opts = {
      sort_by = "case_sensitive",
      view    = { width = 35 },
      renderer = {
        group_empty = true,
        highlight_git = true,
        icons = { show = { git = true } },
      },
      filters  = { dotfiles = false },
      git      = { enable = true },
      diagnostics = { enable = true, show_on_dirs = true },
    },
  },

  -- ── Indent guides ─────────────────────────────────────────
  {
    "lukas-reineke/indent-blankline.nvim",
    event = "BufReadPost",
    main  = "ibl",
    opts  = {
      indent = { char = "│" },
      scope  = { enabled = true },
    },
  },

  -- ── which-key (keymap hints) ──────────────────────────────
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      spec = {
        { "<leader>b", group = "Buffer" },
        { "<leader>f", group = "Find / Files" },
        { "<leader>g", group = "Git" },
        { "<leader>l", group = "LSP" },
        { "<leader>d", group = "Debug" },
        { "<leader>r", group = "Refactor" },
        { "<leader>s", group = "Search" },
        { "<leader>t", group = "Terminal / Test" },
        { "<leader>x", group = "Trouble / Diagnostics" },
      },
    },
  },

  -- ── Noice (UI overhaul for messages / cmdline) ────────────
  {
    "folke/noice.nvim",
    event        = "VeryLazy",
    dependencies = { "MunifTanjim/nui.nvim", "rcarriga/nvim-notify" },
    opts = {
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"]                = true,
          ["cmp.entry.get_documentation"]                  = true,
        },
      },
      presets = {
        bottom_search         = true,
        command_palette       = true,
        long_message_to_split = true,
        inc_rename            = true,
      },
    },
  },

  -- ── Dashboard (start screen) ──────────────────────────────
  {
    "nvimdev/dashboard-nvim",
    event        = "VimEnter",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      theme = "doom",
      config = {
        header = {
          "",
          "  ███╗   ██╗ ███████╗ ██████╗  ██╗   ██╗ ██╗ ███╗   ███╗",
          "  ████╗  ██║ ██╔════╝██╔═══██╗ ██║   ██║ ██║ ████╗ ████║",
          "  ██╔██╗ ██║ █████╗  ██║   ██║ ██║   ██║ ██║ ██╔████╔██║",
          "  ██║╚██╗██║ ██╔══╝  ██║   ██║ ╚██╗ ██╔╝ ██║ ██║╚██╔╝██║",
          "  ██║ ╚████║ ███████╗╚██████╔╝  ╚████╔╝  ██║ ██║ ╚═╝ ██║",
          "  ╚═╝  ╚═══╝ ╚══════╝ ╚═════╝    ╚═══╝   ╚═╝ ╚═╝     ╚═╝",
          "",
        },
        center = {
          { icon = "  ", desc = "Find File        ", key = "f", action = "Telescope find_files" },
          { icon = "  ", desc = "Recent Files     ", key = "r", action = "Telescope oldfiles" },
          { icon = "  ", desc = "Find Text        ", key = "g", action = "Telescope live_grep" },
          { icon = "  ", desc = "Config           ", key = "c", action = "e $MYVIMRC" },
          { icon = "󰒲  ", desc = "Lazy             ", key = "l", action = "Lazy" },
          { icon = "  ", desc = "Quit             ", key = "q", action = "qa" },
        },
        footer = {},
      },
    },
  },

  -- ── Trouble (diagnostics panel) ───────────────────────────
  {
    "folke/trouble.nvim",
    cmd  = "Trouble",
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>",                        desc = "Diagnostics (Trouble)" },
      { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",           desc = "Buffer diagnostics" },
      { "<leader>cs", "<cmd>Trouble symbols toggle focus=false<cr>",                desc = "Symbols (Trouble)" },
      { "<leader>cl", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", desc = "LSP Definitions (Trouble)" },
      { "<leader>xL", "<cmd>Trouble loclist toggle<cr>",                            desc = "Location list" },
      { "<leader>xQ", "<cmd>Trouble qflist toggle<cr>",                             desc = "Quickfix list" },
    },
    opts = {},
  },

  -- ── todo-comments ─────────────────────────────────────────
  {
    "folke/todo-comments.nvim",
    event        = "BufReadPost",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>xt", "<cmd>Trouble todo toggle<cr>",   desc = "Todo (Trouble)" },
      { "<leader>st", "<cmd>TodoTelescope<cr>",         desc = "Todo (Telescope)" },
    },
    opts = {},
  },
}
