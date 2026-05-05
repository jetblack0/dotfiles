local helpers = require("utils.helpers")
local opencode = helpers.safe_require("opencode")
local opencode_terminal = helpers.safe_require("opencode.terminal")
local snacks_terminal = helpers.safe_require("snacks.terminal")
if not opencode and snacks_terminal and opencode_terminal then return end

local opencode_cmd = 'opencode --port'
local snacks_terminal_opts = {
  win = {
    position = 'right',
    enter = false,
    on_win = function(win)
      opencode_terminal.setup(win.win)
    end,
  },
}

vim.g.opencode_opts = {
  server = {
    start = function()
      snacks_terminal.open(opencode_cmd, snacks_terminal_opts)
    end,
    stop = function()
      snacks_terminal.get(opencode_cmd, snacks_terminal_opts):close()
    end,
    toggle = function()
      snacks_terminal.toggle(opencode_cmd, snacks_terminal_opts)
    end,
  },
}

vim.o.autoread = true

vim.keymap.set({ "n", "x" }, "<C-s>a", function()
	opencode.ask("@this: ", { submit = true })
end, { desc = "Ask opencode" })

vim.keymap.set({ "n", "x" }, "<C-s>e", function()
	opencode.select()
end, { desc = "Execute opencode action" })

vim.keymap.set({ "n", "t" }, "<C-s>b", function()
	opencode.toggle()
end, { desc = "Toggle opencode" })

vim.keymap.set({ "n", "x" }, "go", function()
	return opencode.operator("@this ")
end, { desc = "Add range to opencode", expr = true })

vim.keymap.set("n", "goo", function()
	return opencode.operator("@this ") .. "_"
end, { desc = "Add line to opencode", expr = true })

vim.keymap.set("n", "<S-C-u>", function()
	opencode.command("session.half.page.up")
end, { desc = "Scroll opencode up" })

vim.keymap.set("n", "<S-C-d>", function()
	opencode.command("session.half.page.down")
end, { desc = "Scroll opencode down" })
