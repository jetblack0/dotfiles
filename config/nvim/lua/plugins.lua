-- Install lazy vim for the first time.
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

-- Define which file types should the plguin be loaded.
local indent_line_filetypes = {
  "html", "css", "htmldjango",
  "javascript", "javascriptreact", "tsx", "typescript",
  "yaml", "json", "jsonc", "yaml.ansible",
  "rust", "java", "c", "make", "go", "ruby",
  "python",
  "lua", "sh"
}

-- Define what file types should load LSP.
local lsp_filetypes = {
  "lua", "sh", "python", "ruby",
  "rust", "java",
  "javascript", "tsx", "jsx", "html", "css", "scss", "ejs", "json", "javascriptreact",
  "yaml", "yaml.ansible"
}

-- Lazy vim configuration.
local lazy_config = {
	ui = {
		border = "rounded"
	},
  spec = {
    { "LazyVim/LazyVim", import = "lazyvim.plugins" },
    { import = "plugins" },
  },
  defaults = {
    lazy = false,
    -- Always use the latest git commit.
    version = false,
  },
  checker = {
    -- check for plugin updates periodically
    enabled = false,
    -- notify on update
    notify = false,
  },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        -- "matchit",
        -- "matchparen",
        -- "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
}

-- List of plugins. Note that for plugins that have many keybindings,
-- those keybindings are configured in their own configuration files.
-- If a plugin only processes one or two keybindings, then they are
-- configured here.
require("lazy").setup({
  -- UI
  -----
  {
    "ellisonleao/gruvbox.nvim",
    priority = 1000,
    config = function()
      require("plugin-config.gruvbox")
    end,
  },
	{
		"nvim-lualine/lualine.nvim",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			require("plugin-config.lualine")
		end,
	},

  -- System enhancement
  ---------------------
	{
		"nvim-treesitter/nvim-treesitter",
		config = function()
			require("plugin-config.treesitter")
		end,
	},
  {
    "mbbill/undotree",
		keys = {
			{ "<leader>u", ":UndotreeToggle<CR>", "n", silent = true, noremap = true },
		},
  },
	{
		"folke/todo-comments.nvim",
		config = function()
			require("plugin-config.todo-comment")
		end,
	},
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
		ft = indent_line_filetypes,
		config = function ()
			require("plugin-config.indent-blankline")
		end
    ---@module "ibl"
    ---@type ibl.config
  },
	{
		'nvim-telescope/telescope.nvim', tag = '0.1.8',
		dependencies = {
			'nvim-lua/plenary.nvim'
		},
		config = function()
			require("plugin-config.telescope")
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

  -- Programming (LSP)
  --------------------
  -- LSP and plugins around it.
	{
		"neovim/nvim-lspconfig",
		ft = lsp_filetypes,
		config = function()
			require("plugin-config.lsp")
		end,
		dependencies = {
      -- Package manager for LSPs, linters and so on.
			"williamboman/mason.nvim",
      -- Bridge mason with lspconfig.
			"williamboman/mason-lspconfig.nvim",
      -- Show function signature when typing.
      -- NOTE: This plugin is not really, signature help can be toggled
      -- through vim.lsp.buf.signature_help.
			-- "hrsh7th/cmp-nvim-lsp-signature-help",
			{
        -- Highlights other uses of the word under the cursor using LSP,
        -- linters and so on.
				"RRethy/vim-illuminate",
				config = function()
					require("plugin-config.lsp.illuminate")
				end,
			},
		},
	},
  -- cmp, the actual impletation for the completion menu.
	{
		"hrsh7th/nvim-cmp",
	dependencies = {
      -- Bridge cmp (completion) with lspconfig.
			"hrsh7th/cmp-nvim-lsp",
      -- Bridge cmp with nvim-snippy (snippets).
			"dcampos/cmp-snippy",

      -- Completion sources.
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-cmdline",

      -- Snippets.
			"dcampos/nvim-snippy",
      -- Snippet sources.
      "honza/vim-snippets",
		},
		config = function()
			require("plugin-config.lsp.cmp")
		end,
	},
  -- Lint and format.
  {
    "mfussenegger/nvim-lint",
    event = {
      "BufReadPre",
      "BufNewFile",
    },
		config = function()
			require("plugin-config.lsp.nvim-lint")
		end,
  },
  {
    'stevearc/conform.nvim',
		config = function()
			require("plugin-config.lsp.conform")
		end,
  },
  -- Comment.
	{
		"numToStr/Comment.nvim",
		ft = lsp_filetypes,
		config = function()
			require("plugin-config.lsp.comment")
		end,
	},
  -- Other neat stuff for programming.
  {
    "SmiteshP/nvim-navic",
    requires = "neovim/nvim-lspconfig"
  },


  -- Language Specific
  --------------------
  -- Markdown
	{
	  "iamcco/markdown-preview.nvim",
	  cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
	  build = "cd app && npm install",
		keys = {
			{ "<leader>m", ":MarkdownPreviewToggle<CR>", "n", silent = true, noremap = true },
		},
	  ft = { "markdown" },
	  init = function()
      vim.g.mkdp_filetypes = { "markdown" }
	  end,
	},
	{
		"mzlogin/vim-markdown-toc",
		ft = { "markdown" }
	},
  --[[ {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {},
    ft = { "markdown" },
		config = function()
			require("plugin-config.render-markdown")
		end,
  } ]]
}, lazy_config)
