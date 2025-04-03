local null_ls = require("null-ls")

null_ls.register({
  name = "gofmt",
  method = null_ls.methods.FORMATTING,
  filetypes = { "go" },
  generator = null_ls.formatter({
    command = "gofmt",
    args = {},
    to_stdin = true,
  }),
})

