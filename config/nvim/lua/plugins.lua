local fn = vim.fn

-- Automatically install packer if not installed yet
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
	PACKER_BOOTSTRAP = fn.system({
			"git",
			"clone",
			"--depth",
			"1",
			"https://github.com/wbthomason/packer.nvim",
			install_path,
		})
	print("Installing packer close and reopen Neovim...")
	vim.cmd([[packadd packer.nvim]])
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]])

-- Use a protected call
local status_ok, packer = pcall(require, "packer")
if not status_ok then
	return
end

-- Use popup window for packer instead of split
packer.init({
	display = {
		open_fn = function()
			return require("packer.util").float({ border = "rounded" })
		end,
	},
})

return require("packer").startup(function(use)
	-- Useful basic stuff
	-- packer itself
	use({ "wbthomason/packer.nvim" })
	use({ "nvim-tree/nvim-tree.lua" })
	-- dependency for a lot of plugins (null-ls not working without this)
	use({ "nvim-lua/plenary.nvim" })
	-- speed up loading Lua modules in Neovim to improve startup time 
	use 'lewis6991/impatient.nvim'


	-- Dev tools
	-- easy way to comment things out
	use({ "numToStr/Comment.nvim" })
	-- show color when type color code
	use({ "NvChad/nvim-colorizer.lua" })
	-- tree sitter
	use({ "nvim-treesitter/nvim-treesitter" })
	-- autopair
	-- use({ "windwp/nvim-autopairs" })
	-- git signs
	use({ "lewis6991/gitsigns.nvim" })
	-- markdown preview
	use({
		"iamcco/markdown-preview.nvim",
		run = "cd app && npm install",
		setup = function()
			vim.g.mkdp_filetypes = { "markdown" }
		end,
		ft = { "markdown" },
	})
	use({ "elkowar/yuck.vim" })


	-- Ui enhancement
	use({ "nvim-lualine/lualine.nvim" })
	use({ "nvim-tree/nvim-web-devicons" })
	-- better scrolling experience
	use({ "karb94/neoscroll.nvim" })
	use({
		"catppuccin/nvim",
		as = "catppuccin",
	})
	use ({ "akinsho/bufferline.nvim", tag = "v3.*", requires = "nvim-tree/nvim-web-devicons" })
	use ({ "folke/todo-comments.nvim" })


	-- LSP and completion
	use({ "neovim/nvim-lspconfig" })
	use({ "williamboman/mason.nvim" })
	use({ "williamboman/mason-lspconfig.nvim" })
	-- the completion plugin
	use({ "hrsh7th/nvim-cmp" })
	-- buffer completion
	use({ "hrsh7th/cmp-buffer" })
	-- path completion
	use({ "hrsh7th/cmp-path" })
	-- use completion that provided by language servers
	use({ "hrsh7th/cmp-nvim-lsp" })
	use({ "ray-x/lsp_signature.nvim" })
	-- Supplement diagnostics and fixer for some language servers don't support this
	use({ "jose-elias-alvarez/null-ls.nvim" })
	-- cmdline completion
	use({ "hrsh7th/cmp-cmdline" })
	-- emmet completion
	use({ "mattn/emmet-vim" })
	use({ "dcampos/cmp-emmet-vim" })
	-- automatically highlighting other uses of the word under the cursor using either LSP, Tree-sitter, or regex matching
	use({ "RRethy/vim-illuminate" })


	-- Snippets
	-- just a snippet engine, don't provide sources i think, got error when typing snippets if we don't use a snippet engine
	use("L3MON4D3/LuaSnip")
	-- luasnip completion source for cmp
	use({ "saadparwaiz1/cmp_luasnip" })
	-- a bunch of snippet sources
	-- use({ "rafamadriz/friendly-snippets" })
end)
