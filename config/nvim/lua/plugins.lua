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
  "rust", "java", "c", "make", "go",
  "lua", "sh", "python", "ruby",
  "groovy", "terraform"
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
		"nvim-tree/nvim-tree.lua",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			require("plugin-config.nvimtree")
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter",
    branch = 'main',
    build = ":TSUpdate",
    lazy = false,
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
    {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      require("plugin-config.lsp.mason")
    end,
    post_checkout = function()
      vim.cmd("MasonToolsInstall")
    end,
  },
  {
    -- Highlights other uses of the word under the cursor using LSP,
    -- linters and so on.
    "RRethy/vim-illuminate",
    config = function()
      require("plugin-config.lsp.illuminate")
    end,
  },
  -- cmp, the actual impletation for the completion menu.
	{
		"hrsh7th/nvim-cmp",
    dependencies = {
      -- Bridge cmp (completion) with lsp.
			"hrsh7th/cmp-nvim-lsp",
      -- Bridge cmp with nvim-snippy (snippets).
			"dcampos/cmp-snippy",

      -- Completion sources.
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-cmdline",

      -- Snippet engine.
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
		config = function()
			require("plugin-config.lsp.comment")
		end,
	},
  -- Other neat stuff for programming.
  {
    "SmiteshP/nvim-navic",
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
      vim.g.mkdp_browser = 'zen'
	  end,
	},
	{
		"mzlogin/vim-markdown-toc",
		ft = { "markdown" }
	},
}, lazy_config)
