local options = {
	autoindent = true,
	smartindent = true,
	-- Minimal number of columns to use for the line number. Only relevant when the 'number' or 'relativenumber' option is set or printing lines
	numberwidth = 3,
	-- Always draw sign column
	signcolumn = "yes",
	-- Show tab as four space wide, but still a \t
	tabstop = 4,
	-- Sets the number of columns for a TAB
	softtabstop = 4,
	-- Indents will have a width of
	shiftwidth = 4,
	-- Case insensitive search unless capital letters are used
	ignorecase = true,
	smartcase = true,
	-- Splits open at the bottom and right, which is non-retarded, unlike vim defaults.
	splitbelow = true,
	splitright = true,
	number = true,
	relativenumber = true,
	mouse = "",
	-- Remove highlighting after search is done
	hlsearch = true,
	incsearch = true,
	-- Hide unsaved file when closing the buffer, usually vim doesn't allow closing unsaved buffer unless you force it but with hidden option, buffer will be hidden when you close it vim will prompt you to save when closing vim editor
	hidden = true,
	-- True color
	termguicolors = true,
	-- Use system clipboard
	clipboard = "unnamedplus",
	-- Will speed up nvim, but i didn't notice any change
	ttyfast = true,
	-- lazyredraw = true,
}

for k, v in pairs(options)
do
	vim.opt[k] = v
end

