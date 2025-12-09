return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        ruff = {
          cmd = { "ruff", "server" },
          init_options = {
            settings = {
              args = {}, -- extra ruff args
            },
          },
        },
        pyright = {
          settings = {
            pyright = {
              disableOrganizeImports = true, -- use ruff for imports
            },
            python = {
              analysis = {
                ignore = { "*" }, -- use ruff for linting
              },
            },
          },
        },
      },
      setup = {
        ruff = function(_, opts)
          opts.on_attach = function(client, bufnr)
            -- Optional: let Pyright handle "hover"
            client.server_capabilities.hoverProvider = false
          end
        end,
      },
    },
  },
}

