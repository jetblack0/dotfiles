local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "

local lazy_config = {
	ui = {
		border = "rounded"
	}
}

local lsp_filetypes = { "lua", "sh", "rust", "javascript", "tsx", "jsx", "html", "css", "scss", "ejs", "json", "javascriptreact" }
require("lazy").setup({
	------------------------------------- General stuff --------------------------------------
	{
		"nvim-tree/nvim-tree.lua",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			require("pluginConfig.nvimtree")
		end,
	},
	{
		"numToStr/Comment.nvim",
		config = function()
			require("pluginConfig.comment")
		end,
	},
	{
		"NvChad/nvim-colorizer.lua",
		cmd = "ColorizerToggle",
		keys = {
			{ "<leader>c", ":ColorizerToggle<CR>", "n", desc = "toggle colorizer", silent = true, noremap = true },
		},
		config = function()
			require("pluginConfig.nvim-colorizer")
		end,
	},
	{
		"lewis6991/gitsigns.nvim",
		config = true,
		cmd = "Gitsigns",
		keys = {
			{ "<leader>g", "<cmd>:Gitsigns toggle_signs<CR>", "n", desc = "toggle git signs", silent = true, noremap = true },
		},
	},
	{
		"nvim-treesitter/nvim-treesitter",
		config = function()
			require("pluginConfig.treesitter")
		end,
	},
	{
		"folke/todo-comments.nvim",
		config = function()
			require("pluginConfig.todo-comment")
		end,
	},


	------------------------------------- Language specific --------------------------------------
	{
		"iamcco/markdown-preview.nvim",
		build = "cd app && npm install",
		config = function()
			vim.g.mkdp_filetypes = { "markdown" }
		end,
		ft = { "markdown" },
	},
	{
		"elkowar/yuck.vim",
		ft = { "yuck" },
	},
	{
		"Fymyte/rasi.vim",
		ft = { "rasi" },
	},


	------------------------------------- Ui enhancement --------------------------------------
	{
		"nvim-lualine/lualine.nvim",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			require("pluginConfig.lualine")
		end,
	},
	{
		"akinsho/bufferline.nvim",
		version = "v3.*",
		dependencies = "nvim-tree/nvim-web-devicons",
		config = function()
			require("pluginConfig.bufferline")
		end,
	},
	{
		"karb94/neoscroll.nvim",
		config = function()
			require("pluginConfig.neoscroll")
		end,
	},
	{
		"catppuccin/nvim",
		name = "catppuccin",
		config = function()
			require("pluginConfig.catppuccin")
		end,
	},


	------------------------------------- LSP stuff --------------------------------------
	{
		"neovim/nvim-lspconfig",
		ft = lsp_filetypes,
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"ray-x/lsp_signature.nvim",
			{
				"RRethy/vim-illuminate",
				config = function()
					require("pluginConfig.illuminate")
				end,
			},
			{
				"jose-elias-alvarez/null-ls.nvim",
				dependencies = {
					"nvim-lua/plenary.nvim",
				},
				config = function()
					require("pluginConfig.null-ls")
				end,
			},
			"hrsh7th/cmp-nvim-lsp",
		},
		config = function()
			require("pluginConfig.lsp")
		end,
	},


	------------------------------------- Completion --------------------------------------
	-- NOTE: get error if i delete luasnip
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-cmdline",
			"dcampos/nvim-snippy",
			"dcampos/cmp-snippy"
		},
		config = function()
			require("pluginConfig.cmp")
		end,
	},
	{
		"mattn/emmet-vim",
		ft = { "html", "css" },
		dependencies = {
			"dcampos/cmp-emmet-vim",
		},
	},
}, lazy_config)
