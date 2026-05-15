-- ============================================================
-- plugins/telescope.lua — Fuzzy finder
-- ============================================================
return {
  {
    "nvim-telescope/telescope.nvim",
    cmd          = "Telescope",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      -- Native FZF sorter for much faster matching
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        cond  = function() return vim.fn.executable("make") == 1 end,
      },
      "nvim-telescope/telescope-ui-select.nvim",  -- use telescope for vim.ui.select
    },
    keys = {
      -- Files
      { "<leader>ff", "<cmd>Telescope find_files<cr>",                desc = "Find files" },
      { "<leader>fr", "<cmd>Telescope oldfiles<cr>",                  desc = "Recent files" },
      { "<leader>fb", "<cmd>Telescope buffers<cr>",                   desc = "Buffers" },
      -- Search
      { "<leader>sg", "<cmd>Telescope live_grep<cr>",                 desc = "Grep (live)" },
      { "<leader>sw", "<cmd>Telescope grep_string<cr>",               desc = "Grep word under cursor" },
      { "<leader>ss", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Search in buffer" },
      -- LSP / Symbols
      { "<leader>ls", "<cmd>Telescope lsp_document_symbols<cr>",      desc = "Document symbols" },
      { "<leader>lS", "<cmd>Telescope lsp_workspace_symbols<cr>",     desc = "Workspace symbols" },
      { "<leader>ld", "<cmd>Telescope diagnostics<cr>",               desc = "Diagnostics" },
      -- Git
      { "<leader>gc", "<cmd>Telescope git_commits<cr>",               desc = "Git commits" },
      { "<leader>gb", "<cmd>Telescope git_branches<cr>",              desc = "Git branches" },
      { "<leader>gs", "<cmd>Telescope git_status<cr>",                desc = "Git status" },
      -- Meta
      { "<leader>sk", "<cmd>Telescope keymaps<cr>",                   desc = "Keymaps" },
      { "<leader>sh", "<cmd>Telescope help_tags<cr>",                 desc = "Help tags" },
      { "<leader>sc", "<cmd>Telescope colorscheme<cr>",               desc = "Colorschemes" },
      { "<leader>sm", "<cmd>Telescope man_pages<cr>",                 desc = "Man pages" },
    },
    config = function()
      local telescope = require("telescope")
      local actions   = require("telescope.actions")

      telescope.setup({
        defaults = {
          prompt_prefix   = "  ",
          selection_caret = " ",
          layout_config   = { horizontal = { preview_width = 0.55 } },
          file_ignore_patterns = {
            "^.git/", "target/", "node_modules/", "__pycache__/", "%.pyc",
          },
          mappings = {
            i = {
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
              ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
              ["<Esc>"] = actions.close,
            },
          },
        },
        extensions = {
          fzf = {
            fuzzy                   = true,
            override_generic_sorter = true,
            override_file_sorter    = true,
            case_mode               = "smart_case",
          },
          ["ui-select"] = { require("telescope.themes").get_dropdown() },
        },
      })

      telescope.load_extension("fzf")
      telescope.load_extension("ui-select")
    end,
  },
}
