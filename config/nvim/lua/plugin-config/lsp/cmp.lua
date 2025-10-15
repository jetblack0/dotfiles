local helpers = require("utils.helpers")
local cmp = helpers.safe_require("cmp")
local luasnip = require("luasnip")

if not cmp then return end
if not luasnip then return end

local kind_icons = {
	Text = " ",
	Method = "󰆧 ",
	Function = "  ",
	Constructor = " ",
	Field = " ",
	Variable = " ",
	Class = " ",
	Interface = " ",
	Module = " ",
	Property = "󰓽 ",
	Unit = " ",
	Value = "󰎠 ",
	Enum = " ",
	Keyword = " ",
	Snippet = " ",
	Color = " ",
	File = " ",
	Reference = "󰈇 ",
	Folder = " ",
	EnumMember = " ",
	Constant = "󰏿 ",
	Struct = " ",
	Event = " ",
	Operator = " ",
	TypeParameter = "",
}


require("luasnip.loaders.from_vscode").lazy_load()
require("luasnip.loaders.from_vscode").lazy_load({ paths = { "./snippets/luasnip" } })

-- Global Settings
------------------
cmp.setup({
	view = {
    -- Can be "custom", "wildmenu" or "native".
		entries = "custom",
	},
	-- get error if we don't use snippet engine
	snippet = {
		expand = function(args)
			luasnip.expand_snippet(args.body)
		end,
	},
	mapping = {
		["<a-k>"] = cmp.mapping.select_prev_item(),
		["<a-j>"] = cmp.mapping.select_next_item(),
		["<C-u>"] = cmp.mapping(cmp.mapping.scroll_docs(-1), { "i", "c" }),
		["<C-d>"] = cmp.mapping(cmp.mapping.scroll_docs(1), { "i", "c" }),
		-- ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
		-- ["<C-y>"] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
		["<a-e>"] = cmp.mapping({
			i = cmp.mapping.abort(),
			c = cmp.mapping.close(),
		}),
		["<TAB>"] = cmp.mapping.confirm({ select = true }),
		["<a-m>"] = cmp.mapping({
			i = function()
				if cmp.visible() then
					-- require("notify")("visible")
					cmp.abort()
				else
					-- require("notify")("not visible")
					cmp.complete()
				end
			end,
			c = function()
				if cmp.visible() then
					-- require("notify")("visible")
					cmp.close()
				else
					-- require("notify")("not visible")
					cmp.complete()
				end
			end,
		}),
	},

	formatting = {
		fields = { "abbr", "menu", "kind" },
		format = function(entry, vim_item)
			-- Set max width for abbr
			-- vim_item.abbr = string.sub(vim_item.abbr, 1, 20)

			vim_item.kind = string.format("%s", kind_icons[vim_item.kind]) -- icon
			-- vim_item.kind = vim_item.kind:lower() -- text
			vim_item.menu = "  "

			-- show the sources name
			vim_item.menu = ({
				nvim_lsp = "[LSP]",
				luasnip = "[Snippet]",
				buffer = "[Buffer]",
				path = "[Path]",
				-- emmet_vim = "[emmet]",
			})[entry.source.name]

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
    completion = {
      winhighlight = "Normal:Pmenu",
    },
    documentation = {
      winhighlight = "Normal:CmpNormal",
    },

		-- completion = cmp.config.window.bordered({
		--     winhighlight = "CursorLine:PmenuSel,Search:None",
		-- }),
		-- documentation = cmp.config.window.bordered({
		-- 	winhighlight = "CursorLine:PmenuSel,Search:None",
		-- }),
		--
		-- documentation = cmp.config.window.bordered(),
		-- completion = cmp.config.window.bordered(),
	},
	experimental = {
		-- bad performance
		ghost_text = false,
	},
	enabled = function()
		local context = require("cmp.config.context")
    local buftype = vim.api.nvim_buf_get_option(0, "buftype")

    if not vim.api.nvim_get_mode().mode == "c" then return false end
		-- Disable completion in Telescope prompt.
    if buftype == "prompt" then return false end

		-- Disable completion in comments.
    return not context.in_treesitter_capture("comment") and not context.in_syntax_group("Comment")
	end,
})


-- Settings for different buffer type 
-------------------------------------
-- Completion for vim searching.
-- cmp.setup.cmdline({ "/", "?" }, {
-- 	mapping = cmp.mapping.preset.cmdline(),
-- 	sources = {
-- 		{ name = "buffer" },
-- 	},
-- 	formatting = {
-- 		fields = { "abbr" },
-- 	},
-- })

cmp.setup.cmdline(":", {
  mapping = cmp.mapping.preset.cmdline({
    -- Use default nvim history scrolling
    ["<a-j>"] = { c = cmp.mapping.select_next_item() },
    ["<a-k>"] = { c = cmp.mapping.select_prev_item() },
    ["<C-e>"] = { c = cmp.mapping.abort() },
  }),
	sources = cmp.config.sources({
		{ name = "path" },
	},{
		{ name = "cmdline" },
	}),
	formatting = {
		fields = { "abbr" },
	},
})


-- Settings for different filetypes
-----------------------------------
-- For certain filetypes.
-- cmp.setup.filetype({ "rust", "lua", "sh", "javascript", "markdown", "python", "ruby", "groovy" }, {
-- 	sources = {
-- 		{ name = "nvim_lsp" },
--  		-- { name = "luasnip" },
-- 		{ name = "buffer" },
-- 		{ name = "path" },
-- 	},
-- })

cmp.setup.filetype({ "yaml.ansible", "jinja" }, {
	sources = {
		{ name = "nvim_lsp" },
		{ name = "buffer" },
		{ name = "path" },
	},
})

cmp.setup.filetype({ "css", "html" }, {
	sources = {
		{ name = "nvim_lsp" },
 		{ name = "luasnip" },
		-- { name = "emmet_vim" },
		{ name = "buffer" },
		{ name = "path" },
	},
})

-- cmp.setup.filetype({ "java" }, {
-- 	sources = {
-- 		{ name = "nvim_lsp" },
-- 		{ name = "luasnip" },
-- 		{ name = "buffer" },
-- 		{ name = "path" },
-- 	},
-- })


-- Highlights for the completion menu 
vim.api.nvim_set_hl(0, "CmpNormal", { bg = "#3C3836" })


-- Snippet sources


-- Additional keybindings
-------------------------
-- Toggle cmp on and off.
vim.keymap.set("n", "<leader>z", function()
  cmp.setup.buffer({ enabled = false }) 
    vim.notify("Turn off cmp", vim.log.levels.INFO, { title = "Autocomplete" })
end, { desc = "Turn off cmp" })

vim.keymap.set("n", "<leader>x", function()
    vim.notify("Turn on cmp", vim.log.levels.INFO, { title = "Autocomplete" })
  cmp.setup.buffer({ enabled = true }) 
end, { desc = "Turn on cmp" })
