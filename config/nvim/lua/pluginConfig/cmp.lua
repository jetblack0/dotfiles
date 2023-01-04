local cmp_status_ok, cmp = pcall(require, "cmp")
if not cmp_status_ok then
	return
end

local snip_status_ok, luasnip = pcall(require, "luasnip")
if not snip_status_ok then
	return
end

require("luasnip/loaders/from_vscode").lazy_load()

local kind_icons = {
	Text = " ",
	Method = " ",
	Function = "  ",
	Constructor = " ",
	Field = " ",
	Variable = " ",
	Class = " ",
	Interface = " ",
	Module = " ",
	Property = "識 ",
	Unit = " ",
	Value = " ",
	Enum = " ",
	Keyword = " ",
	Snippet = " ",
	Color = " ",
	File = " ",
	Reference = " ",
	Folder = " ",
	EnumMember = " ",
	Constant = " ",
	Struct = " ",
	Event = " ",
	Operator = " ",
	TypeParameter = "",
}

cmp.setup({
	-- By default, the Custom menu is enabled
	view = {
		entries = "custom", -- can be "custom", "wildmenu" or "native"
	},
	-- get error if we don't use snippet engine
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body) -- For `luasnip` users.
		end,
	},
	mapping = {
		["<C-k>"] = cmp.mapping.select_prev_item(),
		["<C-j>"] = cmp.mapping.select_next_item(),
		["<C-d>"] = cmp.mapping(cmp.mapping.scroll_docs(-1), { "i", "c" }),
		["<C-u>"] = cmp.mapping(cmp.mapping.scroll_docs(1), { "i", "c" }),
		-- ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
		-- ["<C-y>"] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
		["<c-e>"] = cmp.mapping({
			i = cmp.mapping.abort(),
			c = cmp.mapping.close(),
		}),
		["<TAB>"] = cmp.mapping.confirm({ select = true }),
	},

	formatting = {
		fields = { "abbr", "menu", "kind" },
		format = function(_, vim_item)
			-- Set max width for abbr
			-- vim_item.abbr = string.sub(vim_item.abbr, 1, 20)

			-- Kind icons
			vim_item.kind = string.format("%s", kind_icons[vim_item.kind]) -- icon
			-- vim_item.kind = vim_item.kind:lower(); -- text
			vim_item.menu = "  "

			return vim_item
		end,
	},
	sources = {
		{ name = "nvim_lsp" },
		{ name = "luasnip" },
		{ name = "buffer" },
		{ name = "path" },
	},
	window = {
		-- documentation = cmp.config.window.bordered(),
	},
	experimental = {
		ghost_text = true,
		native_menu = false,
	},
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ "/", "?" }, {
	mapping = cmp.mapping.preset.cmdline(),
	sources = {
		{ name = "buffer" },
	},
	formatting = {
		fields = { "abbr" },
	},
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(":", {
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources({
		{ name = "path" },
	}, {
		{ name = "cmdline" },
	}),
	formatting = {
		fields = { "abbr" },
	},
})

-- for certain filetypes
cmp.setup.filetype({ "rust", "lua" }, {
	sources = {
		{ name = "nvim_lsp" },
		{ name = "buffer" },
		{ name = "path" },
	},
})

cmp.setup.filetype({ "css" }, {
	sources = {
		{ name = "nvim_lsp" },
		{ name = "emmet_vim" },
		{ name = "buffer" },
		{ name = "path" },
	},
})
