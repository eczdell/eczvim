local dap = require("dap")

dap.adapters.go = {
  type = "server",
  port = 38697,
  executable = {
    command = "dlv",
    args = { "dap", "-l", "127.0.0.1:38697" },
  },
}

dap.configurations.go = {
  {
    type = "go",
    name = "Debug File",
    request = "launch",
    program = "${file}",
  },
  {
    type = "go",
    name = "Debug Package",
    request = "launch",
    program = "${workspaceFolder}",
  },
}

