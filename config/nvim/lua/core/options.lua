-- Local options, equvlient to running the set command in vim script.
local options = {
	-- System: Performance
	----------------------
	-- ttyfast = true,
	-- lazyredraw = true,

	-- System: Indentations
	-----------------------
	autoindent = true,
	smartindent = true,
	-- Show tab as four space wide, but still a \t.
	tabstop = 4,
	-- Sets the number of columns for a TAB.
	softtabstop = 4,
	-- Default width for indentations.
	shiftwidth = 4,
	
	-- System: Searching
	--------------------
	-- Case insensitive search unless capital letters are used.
	ignorecase = true,
	smartcase = true,

	-- System: Others
	-----------------
	-- Disable mouse
	mouse = "",
	-- ttymouse = "",
	-- Use system clipboard
	clipboard = "unnamedplus",
	
	-- System: Uncertain
	--------------------
	-- hidden = true,
	--[[ wildmenu = true,
	wildmode = "list:longest,full", ]]
	backup = false,
	writebackup = false,
  -- folding.
  foldmethod = "manual",


	-- UI: highlights 
	----------------- 
	-- True color.
	termguicolors = true,
	-- Remove highlighting after search is done.
	hlsearch = true,
	incsearch = true,
	
	-- UI: Sign column
	------------------
	-- Always draw sign column.
	signcolumn = "yes",
	-- Minimal width to use for the sign column.
	numberwidth = 3,
	-- Use relative line number for the current line.
	number = true,
	relativenumber = true,

	-- UI: Others
	-------------
	-- Splits open at the bottom and right, override the default position.
	splitbelow = true,
	splitright = true,
	-- Status line.
  laststatus = 3,
}

-- Global variables.
local global_variables = {
	-- System: Netrw
	-- Configures how Netrw shoule be opened with the vim . command.
	-- See :h netrw-browser-var.
	----------------------------------------------------------------
	-- Use tree view by default.
	netrw_liststyle = 3,
  -- Default window size for Netrw.
	netrw_winsize = 25,
	-- Hide the help menu.
  netrw_banner = 0,
	-- What to do when open a file through <cr>:
  -- 0: Open to the same window as Netrw.
  -- 2: Vertically splitting the window.
  -- 4: Open file in the previous focused window.
  netrw_browse_split = 0,
  -- Keep the current directory the same as the browsing directory.
  -- Without this, new files will always be created in the current
  -- working directory for Lex.
  netrw_keepdir = 0,
  -- Suppose to split to the right, but doesn't work apparently.  
  netrw_altv = 1,
}

for k, v in pairs(options) do
	vim.opt[k] = v
end

for k, v in pairs(global_variables) do
	vim.g[k] = v
end


-- Options that I found hard to configure in Lua syntax.
-- Hide dotfiles in netrw by default, can be toggled through the gh key. 
vim.cmd[[let ghregex='\(^\|\s\s\)\zs\.\S\+']]
vim.cmd[[let g:netrw_list_hide=ghregex]]
