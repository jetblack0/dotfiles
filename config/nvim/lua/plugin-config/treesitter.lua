local helpers = require("utils.helpers")

local treesitter = helpers.safe_require("nvim-treesitter.configs")
if not treesitter then return end

treesitter.setup({
  ensure_installed = {
    "html", "css", "json", "jsonc", "yaml", "javascript", "typescript", "tsx",
    "helm",
    "markdown", "markdown_inline",
    "c", "rust", "java", "go", "gotmpl",
    "bash", "lua", "python",
  },
	ignore_install = { "" }, -- List of parsers to ignore installing
	highlight = {
		enable = true, -- false will disable the whole extension
		disable = { "" }, -- list of language that will be disabled
	},
	autopairs = {
		enable = true,
	},
	indent = { enable = true, disable = { "" } },
	additional_vim_regex_highlighting = false,
})
