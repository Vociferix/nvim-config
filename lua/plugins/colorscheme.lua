return {
  {
    "navarasu/onedark.nvim",
    priority = 1000,
    lazy     = false,
    opts = {
      style           = "dark",
      transparent     = false,
      term_colors     = true,
      ending_tildes   = false,
      code_style = {
        comments  = "italic",
        keywords  = "none",
        functions = "none",
        strings   = "none",
        variables = "none",
      },
      integrations = {
        cmp        = true,
        gitsigns   = true,
        nvimtree   = true,
        telescope  = true,
        treesitter = true,
        which_key  = true,
        indent_blankline = { enabled = true },
      },
    },
    config = function(_, opts)
      require("onedark").setup(opts)
      require("onedark").load()
    end,
  },
}
