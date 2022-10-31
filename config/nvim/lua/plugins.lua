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
-- Useful functionality
	-- packer itself
	use({ "wbthomason/packer.nvim" })
	use({ "nvim-tree/nvim-tree.lua" })
	-- dependency for a lot of plugins (null-ls not working without this)
	use({ "nvim-lua/plenary.nvim" })
	-- easy way to comment things out (make one myself when got sometimes)
	use({ "numToStr/Comment.nvim" })
	-- Show color when type color code
	use({ "norcalli/nvim-colorizer.lua" })

-- Ui enhancement
	use({ "nvim-lualine/lualine.nvim" })
	use({ "ryanoasis/vim-devicons" })
	-- better scrolling experience
	use({ "psliwka/vim-smoothie" })
	use({
		"catppuccin/nvim",
		as = "catppuccin",
	})

-- LSP stuff
	use({ "neovim/nvim-lspconfig" })
	-- the completion plugin
	use({ "hrsh7th/nvim-cmp" })
	-- buffer completion
	use({ "hrsh7th/cmp-buffer" })
	-- path completion
	use({ "hrsh7th/cmp-path" })
	-- use completion that provided by language servers
	use({ "hrsh7th/cmp-nvim-lsp" })
	-- Supplement diagnostics and fixer for some language servers don't support this
	use({ "jose-elias-alvarez/null-ls.nvim" })
	-- cmdline completions
	-- use{ "hrsh7th/cmp-cmdline" }

-- Snippets, just lsp snippet is fine
	-- just a snippet engine, don't provide sources i think, got error when typing snippets if we don't use a snippet engine
	use("L3MON4D3/LuaSnip")
	-- for cmp to use snippets from lualine
	-- use{ "saadparwaiz1/cmp_luasnip" } -- snippet completions
	-- a bunch of snippet sources
	-- use "rafamadriz/friendly-snippets"

-- Install plugins above after install packer (if we didn't install packer)
    if PACKER_BOOTSTRAP then
        require("packer").sync()
    end
end)
