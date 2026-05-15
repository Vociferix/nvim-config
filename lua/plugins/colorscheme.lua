return {
  {
    "folke/tokyonight.nvim",
    priority = 1000,
    lazy     = false,
    opts = {
      style           = "night",  -- darkest variant (#1a1b26 bg)
      transparent     = false,
      terminal_colors = true,
      styles = {
        comments  = { italic = true },
        keywords  = { italic = false },
        functions = {},
        variables = {},
      },
    },
    config = function(_, opts)
      require("tokyonight").setup(opts)
      vim.cmd.colorscheme("tokyonight")
    end,
  },
}
