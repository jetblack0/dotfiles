"      __                _           
"   /\ \ \___  _____   _(_)_ __ ___  
"  /  \/ / _ \/ _ \ \ / / | '_ ` _ \ 
" / /\  /  __/ (_) \ V /| | | | | | |
" \_\ \/ \___|\___/ \_/ |_|_| |_| |_|
                                   
" Plug-in
" -------------------------------------------------------- 
call plug#begin()
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
	Plug 'vim-autoformat/vim-autoformat'
	Plug 'dense-analysis/ale'
	Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
	Plug 'junegunn/fzf.vim'
call plug#end()
" -------------------------------------------------------- 


" Basic setting:
" -------------------------------------------------------- 
" Copy to system clipboard
	set clipboard+=unnamedplus
" Syntax highligiting color scheme (alternative: murphy, koehler)
	colorscheme gruvbox
" pervent color scheme override my background (assume using gruvbox theme, because I don't know how to change color in vim color scheme file)
	hi IncSearch ctermfg=109
	hi Normal ctermbg=none
	hi Normal guibg=none
" Turn on syntax highlighting:
	syntax on 			
" Enables relative line number
	set number relativenumber 	
" Disable mouse support, it sucks
	set mouse-=a 			
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
" Arrow for airline plugin
	let g:airline_powerline_fonts = 1 
" Set airline theme:
	let g:airline_theme='zenburn' 
	" Airline buffer indicator
	" let g:airline#extensions#tabline#enabled = 1
" Set formatter for different language (vim-autofomat plug-in)
	let g:formatterpath = ['/usr/bin/stylua']
" Set linter for different language (ale plug-in)
	let g:ale_linters = {'lua': ['luacheck'], 'sh': ['shellcheck']}
" Only run linters named in ale_linters settings. (ale plug-in)
	let g:ale_linters_explicit = 1
" Specify what text should be used for signs(ale plug-in)
	let g:ale_sign_error = ''
	let g:ale_sign_warning = '' "
" Set this. Airline will handle the rest.(ale plug-in)
	let g:airline#extensions#ale#enabled = 1
" Set this in your vimrc file to disabling highlighting (ale plug-in)
	"let g:ale_set_highlights = 0
" Cancel hightlight of warn message (ale plug-in)
	" highlight clear ALEWarningSign
" --------------------------------------------------------


" Advanced function
" --------------------------------------------------------
" For comment/uncomment code using multiline comments
function! Comment()
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
" Open Goyo
	nmap <silent> <C-G> :Goyo<CR>
" Moving between errors (ale plug-in)
	nmap <silent> <C-k> <Plug>(ale_previous_wrap)
	nmap <silent> <C-j> <Plug>(ale_next_wrap)
" Map arrow key to hjkl, because it's smoother
	" map h <Left>
	" map l <Right>
	" map j <Down>
	" map k <Up>
" Enable and disable linters
	nmap <silent> <C-,> :ALEDisable<CR>
	nmap <silent> <C-.> :ALEEnable<CR>
" Hide search highlighting
	nmap <silent> <C-/> :noh<CR>
" Comment/uncomment code in multiple line TODO: don't start a new line
	vnoremap ,m :<c-w><c-w><c-w><c-w><c-w>call Comment()<CR>
	vnoremap m, :<c-w><c-w><c-w><c-w><c-w>call UnComment()<CR>
" Better way to switch buffer (same as firefox)
	nmap <silent> <C-PageDown> :bn<CR>
	nmap <silent> <C-PageUp> :bp<CR>
" Open fzf finder
	nmap <silent> <C-p> :Files<CR>
	nmap <silent> <C-l> :Buffers<CR>
" Spell checker for english
	map <silent> <F6> :set spell!<CR>
" Shortcutting split navigation, saving a keypress:
	" map <C-h> <C-w>h
	" map <C-j> <C-w>j
	" map <C-k> <C-w>k
	" map <C-l> <C-w>l
" --------------------------------------------------------

