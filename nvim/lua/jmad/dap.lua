local dap, dapui, hydra = require "dap", require "dapui", require "hydra"

-- Setup Telescope dap extension
local ok_telescope, telescope = pcall(require, "telescope")
if ok_telescope then
    telescope.load_extension "dap"
end

-- Setup cmp dap
local ok_cmp, cmp = pcall(require, "cmp")
if ok_cmp then
    cmp.setup.filetype({ "dap-repl", "dapui_watches" }, {
        sources = cmp.config.sources({
            { name = "dap" },
        }, {
            { name = "buffer" },
        }),
    })
end

-- Set Icons
vim.api.nvim_call_function(
 "sign_define",
 { "DapBreakpoint", { linehl = "", text = "", texthl = "diffRemoved", numhl = "" } }
)

vim.api.nvim_call_function(
 "sign_define",
 { "DapBreakpointCondition", { linehl = "", text = "", texthl = "diffRemoved", numhl = "" } }
)

vim.api.nvim_call_function(
 "sign_define",
 { "DapLogPoint", { linehl = "", text = "", texthl = "diffRemoved", numhl = "" } }
)

vim.api.nvim_call_function(
 "sign_define",
 { "DapStopped", { linehl = "GitSignsChangeVirtLn", text = "", texthl = "diffChanged", numhl = "" } }
)

vim.api.nvim_call_function(
 "sign_define",
 { "DapBreakpointRejected", { linehl = "", text = "", texthl = "", numhl = "" } }
)

-- Setup DAPUI
dapui.setup({
  icons = { collapsed = "", current_frame = "", expanded = "" },
  layouts = {
    {
      elements = { "scopes", "watches", "stacks", "breakpoints" },
      size = 80,
      position = "left",
    },
    { elements = { "console", "repl" }, size = 0.25, position = "bottom" },
  },
  render = { indent = 2 },
})


-- Setup Virtual Text
require("nvim-dap-virtual-text").setup {}

-- Added event for open DAUI
dap.listeners.after.event_initialized['dapui_config'] = function()
 dapui.open()

end

vim.keymap.set("n", "<leader>dd", dap.continue)
vim.keymap.set("n", "<leader>dbp", dap.toggle_breakpoint)
vim.keymap.set("n", "<leader>dl", dap.step_into)
vim.keymap.set("n", "<leader>dj", dap.step_over)
vim.keymap.set("n", "<leader>dk", dap.step_out)
vim.keymap.set("n", "<leader>dh", dapui.eval)
vim.keymap.set("n", "<leader>dc", dap.run_to_cursor)
vim.keymap.set("n", "<leader>dx", function()
    dap.terminate()
    dapui.close()
    dap.clear_breakpoints()
end)

