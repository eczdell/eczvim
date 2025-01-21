-- Autocompletion setup (nvim-cmp)
local cmp = require('cmp')

cmp.setup({
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)  -- Use LuaSnip for snippet expansion
    end,
  },
  mapping = {
    ['<C-p>'] = cmp.mapping.select_prev_item(),  -- Move to previous completion item
    ['<C-n>'] = cmp.mapping.select_next_item(),  -- Move to next completion item
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),     -- Scroll documentation
    ['<C-u>'] = cmp.mapping.scroll_docs(4),      -- Scroll documentation
    ['<Enter>'] = cmp.mapping.confirm({ select = true }), -- Confirm completion
    ['<C-Space>'] = cmp.mapping.complete(),           -- Trigger completion
  },
  sources = {
    { name = 'nvim_lsp' },           -- LSP-based completion (for variables, functions, etc.)
    { name = 'buffer' },             -- Completion from current buffer
    { name = 'luasnip' },            -- Snippets from LuaSnip
  },
  formatting = {
    format = function(entry, vim_item)
      vim_item.menu = ({
        nvim_lsp = '[LSP]',
        buffer = '[Buffer]',
        luasnip = '[Snippet]',
      })[entry.source.name]
      return vim_item
    end,
  },
})
