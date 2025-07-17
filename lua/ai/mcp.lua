-- Load MCP specific configuration
local mcp = require("mcphub")

mcp.setup({
  servers = {
    supabase = {
      env = {
        SUPABASE_ACCESS_TOKEN = "your_supabase_token_here"
      }
    },
  },
  ui = {
    -- Optional: You can customize UI behavior
    autoApprove = false,
  }
})

-- Optional Keymaps for MCPHub
local opts = { noremap = true, silent = true }
vim.api.nvim_set_keymap("n", "<leader>mh", "<cmd>MCPHub<CR>", opts)  -- Open MCPHub main panel
vim.api.nvim_set_keymap("n", "<leader>ms", "<cmd>MCPHub servers<CR>", opts)  -- Manage Servers
vim.api.nvim_set_keymap("n", "<leader>ml", "<cmd>MCPHub logs<CR>", opts)  -- View Logs
vim.api.nvim_set_keymap("n", "<leader>mc", "<cmd>MCPHub config<CR>", opts)  -- Open Config



-- {
--     "ravitemer/mcphub.nvim",
--     config = function()
--       require("mcphub").setup({
--         servers = {
--           supabase = {
--             env = {
--               SUPABASE_ACCESS_TOKEN = "sbp_7ae873ffb6ef1d94b91ccdb5888d0378d55b1aa6"
--             }
--           }
--         }
--       })
--     end
--   },
