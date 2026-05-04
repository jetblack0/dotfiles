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

vim.g['colortheme'] = "gruvbox_shokry"

require("lazy").setup({
  -- UI
  -----
  -- Colorschemes
  { "rose-pine/neovim", name = "rose-pine", lazy = true },
  { "catppuccin/nvim", name = "catppuccin", lazy = true },
  -- { "ellisonleao/gruvbox.nvim", lazy = true },
  { "sainnhe/gruvbox-material", lazy = true },
  { "https://gitlab.com/motaz-shokry/gruvbox.nvim", name = "gruvbox_shokry", lazy = true },
	{
		"nvim-lualine/lualine.nvim",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
	},


  -- Enhancement
  --------------
  {
    "mikavilpas/yazi.nvim",
    version = "*", -- use the latest stable version
    event = "VeryLazy",
    dependencies = {
      { "nvim-lua/plenary.nvim", lazy = true },
    },
    keys = {
      { "<leader>f", mode = { "n", "v" }, "<cmd>Yazi<cr>", desc = "Open yazi at the current file" },
      -- { "<leader>cw", "<cmd>Yazi cwd<cr>", desc = "Open the file manager in nvim's working directory" },
      { "<c-up>", "<cmd>Yazi toggle<cr>", desc = "Resume the last yazi session" },
    },
		config = function()
			require("plugin-config.yazi")
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
    "XXiaoA/atone.nvim",
		keys = {
			{ "<leader>u", ":Atone toggle<CR>", "n", desc = "Toggle atone undo tree", silent = true, noremap = true },
		},
		config = function()
			require("plugin-config.atone")
		end,
  },
	{
		"folke/todo-comments.nvim",
		config = function()
			require("plugin-config.todo-comment")
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
		"mrjones2014/smart-splits.nvim",
    priority = 1000,
    enabled = function()
      return os.getenv("TMUX_PANE") ~= nil
    end,
		config = function()
			require("plugin-config.smart-split")
		end,
	},
	{
		"folke/which-key.nvim",
    event = 'VimEnter',
		config = function()
			require("plugin-config.which-key")
		end,
	},

  -- Programming (LSP)
  --------------------
  -- Git
	{
		"lewis6991/gitsigns.nvim",
    version = "*",
    config = function()
      require("plugin-config.git.gitsigns")
    end,
	},
	{
		"f-person/git-blame.nvim",
    event = "VeryLazy",
    config = function()
      require("plugin-config.git.gitblame")
    end,
	},
	{
		"esmuellert/codediff.nvim",
    dependencies = { "MunifTanjim/nui.nvim" },
    cmd = "CodeDiff",
    config = function()
      require("plugin-config.git.codediff")
    end,
	},
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
  -- completion.
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
  -- Other nice stuff.
  {
    'Bekaboo/dropbar.nvim',
    config = function()
			require("plugin-config.lsp.dropbar")
    end
  },


  -- Language Specific
  --------------------
  -- Markdown
	{
	  "iamcco/markdown-preview.nvim",
	  cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
	  build = "cd app && npm install",
		keys = {
			{ "<leader>m", ":MarkdownPreviewToggle<CR>", "n", desc = "Toogle markdown preview", silent = true, noremap = true },
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
  },
  {
    "TKasperczyk/snacks-gallery.nvim",
    dependencies = { "folke/snacks.nvim" },
    opts = {},
    keys = {
      { "<leader>gi", function() require("snacks-gallery").open() end, desc = "Gallery" },
    },
  }
}, lazy_config)

vim.api.nvim_set_keymap("n", "<leader>2", ":Lazy<CR>", {
  desc = 'Open up Lazy',
  noremap = true,
  silent = false
})
require("plugin-config.colorscheme").colorscheme_conf[vim.g['colortheme']]()
vim.keymap.set('n', '<leader>1', function()
  require("plugin-config.colorscheme").colorscheme_selector() 
end, { desc = 'Open up theme selector', silent = false })
