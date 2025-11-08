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

vim.g['colortheme'] = "gruvbox"

require("lazy").setup({
  -- UI
  -----
  -- Colorschemes
  { "rose-pine/neovim", name = "rose-pine", lazy = true },
  { "catppuccin/nvim", name = "catppuccin", lazy = true },
  { "ellisonleao/gruvbox.nvim", lazy = true },
  { "sainnhe/gruvbox-material", lazy = true },
	{
		"nvim-lualine/lualine.nvim",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			require("plugin-config.lualine")
		end,
	},


  -- Enhancement
  --------------
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
		'nvim-telescope/telescope.nvim', tag = '0.1.8',
		dependencies = {
			'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope-ui-select.nvim'
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
		"saghen/blink.cmp",
    version = '1.*',
    dependencies = {
      {
        "L3MON4D3/LuaSnip",
        version = "v2.*",
        build = "make install_jsregexp"
      },

      -- Snippet sources.
      "rafamadriz/friendly-snippets"
		},
		config = function()
			require("plugin-config.lsp.blink")
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
  -- Ops
  -- Jenkins
  --[[ NOTE: Ensure you have JENKINS_USER_ID, JENKINS_URL, and also either
  JENKINS_API_TOKEN or JENKINS_PASSWORD set. ]]
	-- {
	-- 	"ckipp01/nvim-jenkinsfile-linter",
	-- 	ft = { "groovy.jenkinsfile" }
	-- },


  -- Quality of life
  ------------------
  {
    "rachartier/tiny-glimmer.nvim",
    event = "VeryLazy",
    priority = 10,
    config = function()
      require("plugin-config.qol.tiny-glimmer")
    end,
  },
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    config = function()
      require("plugin-config.qol.snacks")
    end,
  }
}, lazy_config)

require("plugin-config.colorscheme").colorscheme_conf[vim.g['colortheme']]()
vim.keymap.set('n', '<leader>1', function() require("plugin-config.colorscheme").colorscheme_selector() end, { silent = false })
