"      __                _           
"   /\ \ \___  _____   _(_)_ __ ___  
"  /  \/ / _ \/ _ \ \ / / | '_ ` _ \ 
" / /\  /  __/ (_) \ V /| | | | | | |
" \_\ \/ \___|\___/ \_/ |_|_| |_| |_|
                                   
" Plug-in
" -------------------------------------------------------- 
call plug#begin()
    Plug 'junegunn/goyo.vim'
	Plug 'dense-analysis/ale'
	Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
	Plug 'junegunn/fzf.vim'
	Plug 'preservim/nerdtree'
	Plug 'ryanoasis/vim-devicons'
	Plug 'catppuccin/nvim', { 'as': 'catppuccin' }
	Plug 'nvim-lualine/lualine.nvim'
call plug#end()
" -------------------------------------------------------- 


" Basic setting:
" -------------------------------------------------------- 
" Disable mouse support, it sucks
	map <ScrollWheelUp> <nop>
	map <S-ScrollWheelUp> <nop>
	map <C-ScrollWheelUp> <nop>
	map <ScrollWheelDown> <nop>
	map <S-ScrollWheelDown> <nop>
	map <C-ScrollWheelDown> <nop>
	map <ScrollWheelLeft> <nop>
	map <S-ScrollWheelLeft> <nop>
	map <C-ScrollWheelLeft> <nop>
	map <ScrollWheelRight> <nop>
	map <S-ScrollWheelRight> <nop>
	map <C-ScrollWheelRight> <nop>
	set mouse=
" Copy to system clipboard
	set clipboard+=unnamedplus
" Color scheme
	" let g:gruvbox_italic=1
	" colorscheme catppuccin_macchiato
" Turn on syntax highlighting:
	syntax enable 			
	filetype plugin indent on
" Enables relative line number
	set number relativenumber 	
" hide statu line
	set laststatus=0 		
	set noshowmode
" Enable autocompletion:
	set wildmode=longest,list,full
" Disables automatic commenting on newline:
	autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
" Splits open at the bottom and right, which is non-retarded, unlike vim defaults.
	set splitbelow splitright
" Show tab as four space wide, but still a \t
	set tabstop=4
" Sets the number of columns for a TAB
    set softtabstop=4
" Indents will have a width of 4
	set shiftwidth=4    
" Save and load view automatically
	augroup remember_folds
	  autocmd!
	  autocmd BufWinLeave *.* mkview
	  autocmd BufWinEnter *.* silent! loadview
	augroup END
" Highlight a selection on yank
	au TextYankPost * silent! lua vim.highlight.on_yank {on_visual=false, timeout=250}
" -------------------------------------------------------- 


" Plug-in related
" --------------------------------------------------------
" Nerdtree:
" Exit Vim if NERDTree is the only window remaining in the only tab.
	autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif

" Ale:
" Set linter for different language (ale plug-in)
	let g:ale_linters = {'lua': ['luacheck'], 'sh': ['shellcheck'], 'rust': ['rustc']}
" Only run linters named in ale_linters settings. (ale plug-in)
	let g:ale_linters_explicit = 1
" Specify what text should be used for signs(ale plug-in)
	let g:ale_sign_error = ''
	let g:ale_sign_warning = '' "
" Set this. Airline will handle the rest.(ale plug-in)
	let g:airline#extensions#ale#enabled = 1
" Set this in your vimrc file to disabling highlighting (ale plug-in)
	" let g:ale_set_highlights = 0
" Cancel hightlight of warn message (ale plug-in)
	highlight clear ALEWarningSign
" --------------------------------------------------------

" Advanced function
" --------------------------------------------------------
" For comment/uncomment code using multiline comments TODO: c-/ to comment and uncomment like vscode
function! Comment()
	" tolower: turn a string to lowercase
	" expand('%:e'): get the extension, % means current file name
    let ext = tolower(expand('%:e'))
    if ext == 'py' 
        let cmt1 = "'''"
        let cmt2 = "'''"   
    elseif ext == 'cpp' || ext =='java' || ext == 'css' || ext == 'js' || ext == 'c' || ext =='cs' || ext == 'rs' || ext == 'go'
        let cmt1 = '/*'
        let cmt2 = '*/'
    elseif ext == 'sh'
        let cmt1 = ":'"
        let cmt2 = "'"
    elseif ext == 'html'
        let cmt1 = "<!--"
        let cmt2 = "-->"
    elseif ext == 'hs'
        let cmt1 = "{-"
        let cmt2 = "-}"
    elseif ext == "rb"
        let cmt1 = "=begin"
        let cmt2 = "=end"
    elseif ext == "lua"
        let cmt1 = "--[["
        let cmt2 = "--]]"
    endif
    exe line("'<")."normal O". cmt1 | exe line("'>")."normal o". cmt2 
endfunction

function! UnComment()
    exe line("'<")."normal dd" | exe line("'>")."normal dd"   
endfunction
" --------------------------------------------------------

" Key bind
" --------------------------------------------------------
" TODO: change nerd tree keybings same as fzf
" Toggle goyo
	map <silent> <C-g> :Goyo<CR>
" Moving between errors (ale plug-in)
	nmap <silent> <S-j> <Plug>(ale_next_wrap)
	nmap <silent> <S-k> <Plug>(ale_previous_wrap)
" Toggle linters (ale plug-in)
	nmap <silent> <C-,> :ALEToggle<CR>
" Hide search highlighting
	nmap <silent> <C-.> :noh<CR>
" Comment/uncomment code in multiple line
	vnoremap ,m :<c-w><c-w><c-w><c-w><c-w>call Comment()<CR>
	vnoremap m, :<c-w><c-w><c-w><c-w><c-w>call UnComment()<CR>
" Better way to switch buffer (same as firefox)
	nmap <silent> <C-PageDown> :bn<CR>
	nmap <silent> <C-PageUp> :bp<CR>
" Open fzf finder
	nmap <silent> <C-[> :Files<CR>
	nmap <silent> <C-]> :Buffers<CR>
" Spell checker for english
	map <silent> <F6> :set spell!<CR>
" Resize split TODO: kinda confused, make it like my WM
	noremap <silent> <C-h> :vertical resize -2<CR>
	noremap <silent> <C-l> :vertical resize +2<CR>
	noremap <silent> <C-Up> :resize +2<CR>
	noremap <silent> <C-Down> :resize -2<CR>
" Switch split: (I just wanna c-j to next split and c-w to pre split like my WM)
	nnoremap <C-j> <C-w>w
	nnoremap <C-k> <C-w><C-w>
" Change the position of splits
	nnoremap <C-A-l> <C-w><S-l>
	nnoremap <C-A-h> <C-w><S-h>
	nnoremap <C-A-k> <C-w><S-k>
	nnoremap <C-A-j> <C-w><S-j>
" Toggle nerdtree
	nnoremap <silent> <C-b> :NERDTreeToggle<CR>
" Nerdtree keybind that same as fzf
	let NERDTreeMapOpenInTab  = "<C-t>"
	let NERDTreeMapOpenVSplit = "<C-v>"
	let NERDTreeMapOpenSplit  = "<C-x>"
" Quit and save
	nmap <silent> <C-q> :wq<CR>
" --------------------------------------------------------

lua << EOF
vim.g.catppuccin_flavour = "macchiato"
require("catppuccin").setup({
	-- use command :CatppuccinCompile to compile this config into cache
	compile_path = vim.fn.stdpath("cache") .. "/catppuccin",
	transparent_background = true,
	term_colors = false,
	dim_inactive = {
		enabled = false,
		shade = "dark",
		percentage = 0.15,
	},
	styles = {
		comments = { "italic" },
		conditionals = { "italic" },
		conditionals = {},
		loops = {},
		functions = {},
		keywords = {},
		strings = {},
		variables = {},
		numbers = {},
		booleans = {},
		properties = {},
		types = {},
		operators = {},
	},
	integrations = {
		cmp = true,
		gitsigns = true,
		nvimtree = true,
		telescope = true,
		treesitter = true,
	},
	color_overrides = {},
	custom_highlights = {},
	vim.cmd [[colorscheme catppuccin]]
})

-- lualine
local colors = {
  blue     = '#8AADF4',
  cyan     = '#8BD5CA',
  black    = '#080808',
  white    = '#CAD3F5',
  red      = '#ED8796',
  violet   = '#D183E8',
  grey     = '#303030',
  magenta  = "#F5BDE6",
  lavender = "#B7BDF8",
  green    = "#A6DA95",
}

local bubbles_theme = {
  normal = {
    a = { fg = colors.black, bg = colors.magenta },
    b = { fg = colors.black, bg = colors.lavender },
    c = { fg = colors.black, bg = nil },
  },

  insert = { a = { fg = colors.black, bg = colors.blue } },
  visual = { a = { fg = colors.black, bg = colors.cyan } },
  replace = { a = { fg = colors.black, bg = colors.red } },
  command = { a = { fg = colors.black, bg = colors.green } },

  inactive = {
    a = { fg = colors.white, bg = colors.black },
    b = { fg = colors.white, bg = colors.black },
    c = { fg = colors.black, bg = colors.black },
  },
}

require('lualine').setup {
  options = {
	globalstatus = true,
    always_divide_middle = true,
    theme = bubbles_theme,
    component_separators = '|',
    section_separators = { left = '', right = '' },
	ignore_focus = { 'nerdtree' },
    extensions = {}
  },
  sections = {
    lualine_a = {
      { 'mode', separator = { left = '' }, right_padding = 2 },
    },
    lualine_b = { 'filename', 'branch', 'encoding' },
    lualine_c = {},
    lualine_x = {},
    lualine_y = { 'filetype', 'progress' },
    lualine_z = {
      { 'location', separator = { right = '' }, left_padding = 2 },
    },
  },
  inactive_sections = {
    lualine_a = { 'filename' },
    lualine_b = {},
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = { 'location' },
  },
  tabline = {},
  extensions = {},
}
EOF
