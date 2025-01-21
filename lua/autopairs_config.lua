-- Configure nvim-autopairs
require('nvim-autopairs').setup({
  -- enable_check_bracket_line = false,  -- Disable checking for closing brackets in the same line
  check_ts = true,  -- Enable Tree-sitter support
  disable_filetype = { "TelescopePrompt", "vim" },  -- Disable for certain filetypes
  fast_wrap = {
    map = "<M-e>",  -- Alt+e to trigger fast wrap
    chars = { "{", "[", "(", '"' },  -- Define characters for wrapping
    pattern = [=[[%'%"%>%]%)%}]]=],  -- Define the pattern for wrapping
    end_key = "$",  -- End key for wrapping
    keys = "qwertyuiopzxcvbnmasdfghjkl",  -- Keys for fast wrapping
  },
})
