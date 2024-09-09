local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end

vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local lazy_config = {
	ui = {
		border = "rounded"
	}
}

local lsp_filetypes = { "lua", "sh", "rust", "javascript", "tsx", "jsx", "html", "css", "scss", "ejs", "json", "javascriptreact", "java" }
local nullls_filetypes = { "lua", "sh" }
local indent_line_filetypes = { "yaml", "rust", "java", "c", "json", "make", "lua" }

require("lazy").setup({
	------------------------------------- General stuff --------------------------------------
	{
		"nvim-tree/nvim-tree.lua",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			require("plugin-config.nvimtree")
		end,
	},
	{
		"numToStr/Comment.nvim",
		config = function()
			require("plugin-config.comment")
		end,
	},
	{
		"NvChad/nvim-colorizer.lua",
		cmd = "ColorizerToggle",
		keys = {
			{ "<leader>c", ":ColorizerToggle<CR>", "n", desc = "toggle colorizer", silent = true, noremap = true },
		},
		config = function()
			require("plugin-config.nvim-colorizer")
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
			require("plugin-config.treesitter")
		end,
	},
	{
		"folke/todo-comments.nvim",
		config = function()
			require("plugin-config.todo-comment")
		end,
	},
	{
		'nvim-telescope/telescope.nvim', tag = '0.1.8',
		config = function()
			require("plugin-config.telescope")
		end,
		dependencies = { 
			'nvim-lua/plenary.nvim' 
		},
	},


	------------------------------------- Language specific --------------------------------------
	-- {
	-- 	"iamcco/markdown-preview.nvim",
	-- 	build = "cd app && npm install",
	-- 	config = function()
	-- 		vim.g.mkdp_filetypes = { "markdown" }
	-- 	end,
	-- 	ft = { "markdown" },
	-- },
	{
	  "iamcco/markdown-preview.nvim",
	  cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
	  build = "cd app && npm install",
	  init = function()
		vim.g.mkdp_filetypes = { "markdown" }
	  end,
	  ft = { "markdown" },
	},
	{
		"mzlogin/vim-markdown-toc",
		ft = { "markdown" }
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
			require("plugin-config.lualine")
		end,
	},
	{
		"akinsho/bufferline.nvim",
		-- version = "*",
		branch = 'main',
		dependencies = "nvim-tree/nvim-web-devicons",
		config = function()
			require("plugin-config.bufferline")
		end,
	},
	{
		"karb94/neoscroll.nvim",
		config = function()
			require("plugin-config.neoscroll")
		end,
	},
	{
		"catppuccin/nvim",
		name = "catppuccin",
		config = function()
			require("plugin-config.catppuccin")
		end,
	},
	-- {
	-- 	"rose-pine/neovim",
	-- 	name = "rose-pine",
	-- 	config = function ()
	-- 		require("plugin-config.rose-pine")
	-- 	end
	-- },
	-- {
	-- 	'NLKNguyen/papercolor-theme',
	-- },
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		ft = indent_line_filetypes,
		config = function ()
			require("plugin-config.indent-blankline")
		end
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
					require("plugin-config.illuminate")
				end,
			},
			-- {
			-- 	"jose-elias-alvarez/null-ls.nvim",
			-- 	ft = nullls_filetypes,
			-- 	dependencies = {
			-- 		"nvim-lua/plenary.nvim",
			-- 	},
			-- 	config = function()
			-- 		require("plugin-config.null-ls")
			-- 	end,
			-- },
			"hrsh7th/cmp-nvim-lsp",
		},
		config = function()
			require("plugin-config.lsp")
		end,
	},
	{
		"jose-elias-alvarez/null-ls.nvim",
		ft = nullls_filetypes,
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		config = function()
			require("plugin-config.null-ls")
		end,
	},
	{
		"mfussenegger/nvim-jdtls",
		ft = { "java" },
	},


	------------------------------------- Completion --------------------------------------
	-- NOTE: get error if i delete luasnip
	{
		"hrsh7th/nvim-cmp",
	-- ft = lsp_filetypes,
	dependencies = {
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-cmdline",
			"dcampos/nvim-snippy",
			"dcampos/cmp-snippy"
		},
		config = function()
			require("plugin-config.cmp")
		end,
	},
	{
		"mattn/emmet-vim",
		ft = { "html", "css" },
		dependencies = {
			"dcampos/cmp-emmet-vim",
		},
	},


	------------------------------------- Combination with other programs ---------------------
	{
		'christoomey/vim-tmux-navigator',
	},
}, lazy_config)
