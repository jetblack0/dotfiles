local treesitter_status_ok, todo_comments = pcall(require, "todo-comments")
if not treesitter_status_ok then
	return
end

todo_comments.setup({
	signs = true,
	keywords = {
		FIX = { icon = "" },
		TODO = { icon = "" },
		HACK = { icon = "" },
		WARN = { icon = "" },
		PERF = { icon = "" },
		NOTE = { icon = "" },
		TEST = { icon = "" },
	},
	highlight = {
		before = "",
		keyword = "bg",
		after = "",
	},
})

vim.keymap.set("n", "<c-n>", function()
	todo_comments.jump_next({ keywords = {} })
end, { desc = "Next todo comment" })
vim.keymap.set("n", "<c-N>", function()
	todo_comments.jump_prev({ keywords = {} })
end, { desc = "Next todo comment" })
