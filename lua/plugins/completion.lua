-- ============================================================
-- plugins/completion.lua — nvim-cmp autocompletion
-- ============================================================
return {
  {
    "hrsh7th/nvim-cmp",
    event        = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",        -- LSP completions
      "hrsh7th/cmp-buffer",           -- buffer words
      "hrsh7th/cmp-path",             -- filesystem paths
      "hrsh7th/cmp-cmdline",          -- command-line completions
      "saadparwaiz1/cmp_luasnip",     -- snippet source for cmp
      -- Snippets engine
      {
        "L3MON4D3/LuaSnip",
        version      = "v2.*",
        build        = "make install_jsregexp",
        dependencies = { "rafamadriz/friendly-snippets" },
        config = function()
          require("luasnip.loaders.from_vscode").lazy_load()
        end,
      },
      "onsails/lspkind.nvim",         -- VS Code-like icons in completion menu
    },
    config = function()
      local cmp     = require("cmp")
      local luasnip = require("luasnip")
      local lspkind = require("lspkind")

      cmp.setup({
        snippet = {
          expand = function(args) luasnip.lsp_expand(args.body) end,
        },

        window = {
          completion    = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },

        mapping = cmp.mapping.preset.insert({
          ["<C-b>"]     = cmp.mapping.scroll_docs(-4),
          ["<C-f>"]     = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"]     = cmp.mapping.abort(),
          -- Accept with Enter (only when explicitly selected)
          ["<CR>"] = cmp.mapping.confirm({ select = false }),
          -- Tab: cycle through items or expand/jump in snippet
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),

        sources = cmp.config.sources({
          { name = "nvim_lsp", priority = 1000 },
          { name = "luasnip",  priority = 750 },
          { name = "crates" },          -- Cargo.toml crate completions
        }, {
          { name = "buffer",   priority = 500 },
          { name = "path",     priority = 250 },
        }),

        formatting = {
          format = lspkind.cmp_format({
            mode     = "symbol_text",
            maxwidth = 50,
            ellipsis_char = "...",
            before = function(entry, item)
              -- Prefix buffer completions so they're distinguishable
              if entry.source.name == "buffer" then
                item.menu = "[buf]"
              end
              return item
            end,
          }),
        },
      })

      -- cmdline completions
      cmp.setup.cmdline({ "/", "?" }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = { { name = "buffer" } },
      })

      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources(
          { { name = "path" } },
          { { name = "cmdline" } }
        ),
      })
    end,
  },
}
