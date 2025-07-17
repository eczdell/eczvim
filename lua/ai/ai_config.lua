return {
  -- CopilotChat
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "main",
    dependencies = { { "github/copilot.vim" } },
    config = function()
      require("CopilotChat").setup({
        show_floating_window = true
      })

      -- CopilotChat Keymaps
      vim.keymap.set("n", "\\cc", ":CopilotChatToggle<CR>", { desc = "Copilot Chat" })
      vim.keymap.set("v", "\\ce", ":CopilotChatExplain<CR>", { desc = "Explain Code (Visual)" })
      vim.keymap.set("v", "<leader>cf", ":CopilotChatFix<CR>", { desc = "Fix Code (Visual)" })
      vim.keymap.set("v", "<leader>ct", ":CopilotChatTests<CR>", { desc = "Generate Tests (Visual)" })
      vim.keymap.set("v", "<leader>cd", ":CopilotChatDoc<CR>", { desc = "Generate Docstring (Visual)" })
      vim.keymap.set("v", "<leader>cr", ":CopilotChatReview<CR>", { desc = "Review Code (Visual)" })
      vim.keymap.set("v", "<leader>cs", ":CopilotChatSummarize<CR>", { desc = "Summarize Code (Visual)" })

      -- Accept / Reject change
      vim.keymap.set("v", "<leader>ca", function()
        local answer = vim.fn.input("Accept change? (y/n): ")
        if answer == "y" then
          vim.cmd('normal "+y')
          print("✅ Change accepted!")
        else
          print("❌ Change rejected.")
        end
      end, { desc = "Accept Copilot Chat Change" })

      -- Telescope file picker integration for #file insertion
      vim.keymap.set("n", "<leader>cfp", function()
        require("telescope.builtin").find_files({
          prompt_title = "Select File for CopilotChat",
          attach_mappings = function(_, map)
            map("i", "<CR>", function(bufnr)
              local action_state = require("telescope.actions.state")
              local selection = action_state.get_selected_entry()
              require("telescope.actions").close(bufnr)
              vim.api.nvim_put({"#" .. selection.value}, "c", true, true)
            end)
            return true
          end,
        })
      end, { desc = "Insert file path into CopilotChat" })
    end,
  },

  -- MCP (your custom plugin)
  {
    "loqusion/mcp.nvim",
    config = function()
      require("mcp").setup({
        servers = {
          supabase = {
            command = "npx",
            args = {
              "-y",
              "@supabase/mcp-server-supabase@latest",
              "--access-token",
              "sbp_7ae873ffb6ef1d94b91ccdb5888d0378d55b1aa6"
            }
          }
        }
      })
    end
  },

  -- ChatGPT.nvim
  {
    "jackMort/ChatGPT.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
      "folke/trouble.nvim",
      "nvim-telescope/telescope.nvim"
    },
    config = function()
      require("chatgpt").setup({
        api_key = os.getenv("OPENAI_API_KEY"),
        model = "gpt-3.5-turbo",
      })

      vim.keymap.set("n", "<leader>cg", ":ChatGPT<CR>", { desc = "Open ChatGPT" })
      vim.keymap.set("v", "<leader>cgv", ":ChatGPTEditWithInstructions<CR>", { desc = "Edit with ChatGPT (Visual)" })
    end,
  },

  -- nvim-cmp for autocomplete
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "nvim-lua/plenary.nvim",
    },
    config = function()
      local cmp = require("cmp")

      -- Custom context source for CopilotChat
      local context_source = {}

      function context_source.complete(self, params, callback)
        local input = params.context.cursor_before_line
        local items = {}

        if input:match("@%w*$") then
          items = {
            { label = "@file" },
            { label = "@selection" },
            { label = "@clipboard" },
          }
        elseif input:match("/%w*$") then
          items = {
            { label = "/explain" },
            { label = "/fix" },
            { label = "/summarize" },
            { label = "/review" },
            { label = "/doc" },
          }
        elseif input:match("#.*$") then
          local files = vim.fn.glob("*", false, true)
          for _, file in ipairs(files) do
            local filename = vim.fn.fnamemodify(file, ":t")
            table.insert(items, { label = "#" .. filename })
          end
        end

        callback({ items = items, isIncomplete = false })
      end

      cmp.register_source("copilotchat_context", context_source)

      cmp.setup({
        sources = {
          { name = "copilotchat_context" },
          { name = "buffer" },
          { name = "path" },
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
        }),
      })
    end,
  },

  -- Telescope itself
  { "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" } },
}

