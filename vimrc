call pathogen#helptags()
call pathogen#runtime_append_all_bundles()
filetype on  " Automatically detect file types.  set nocompatible  " no vi compatibility.

syntax enable

" let terminal resize scale the internal windows
au VimResized * :wincmd =

set hlsearch
set cf  " Enable error files & error jumping.
set clipboard+=unnamed  " Yanks go on clipboard instead.
set history=256  " Number of things to remember in history.
set autowrite  " Writes on make/shell commands
set autoread  " reloads upon file change
set ruler  " Ruler on
set nu  " Line numbers on
set timeoutlen=250  " Time to wait after ESC (default causes an annoying delay)

set cindent
""set autoindent
""set smarttab
""set expandtab

" Visual
set showmatch  " Show matching brackets.
set mat=5  " Bracket blinking.
set lcs=eol:$,tab:\ \ ,trail:~,extends:>,precedes:<
set novisualbell  " No blinking .
set noerrorbells  " No noise.
set noeb vb t_vb=
set laststatus=2  " Always show status line.

" gvim specific
set mousehide  " Hide mouse after chars typed
set antialias

"Personal Customizations

let mapleader=","

"Make redo easier
noremap r <c-r>

"Dont lose r's funktionality
noremap <leader>r r

"scroll up and down faster with J and K
noremap K 5k
noremap J 5j

"keep functionality of K and J with <leader>J/K
noremap <leader>K K
noremap <leader>J J

nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l


"colors
let base16colorspace=256
"set t_Co=256
set background=dark
colorscheme base16-default
"other stuff
set nolist
set incsearch
set ignorecase
set smartcase 
set scrolloff=3 "So the cursor doesnt get lost on the edge
set wildmode=longest,list
set nobackup
set noswapfile

filetype plugin indent on
set pastetoggle=<F2> "F2 toggles paste in insert mode too
set showmode "show the change to the user
set shortmess=a

" Easy window navigation

"NERDTRee
map <space> :NERDTreeToggle<CR>
let NERDTreeIgnore = ['\.pyc$']

" Command-t
set wildignore+=de5*

"Tagbar
"nmap <leader>t :TagbarToggle<CR>

"Vim-Powerline
set encoding=utf-8 " Necessary to show unicode glyphs

"BSV
filetype plugin on
filetype indent on
let b:verilog_indent_modules = 1
let b:verilog_indent_width = 3
let b:verilog_indent_verbose = 1
set list
set omnifunc=syntaxcomplete#Complete

autocmd Filetype bsv 	set et ts=8 bs=2 sw=3 softtabstop=3
autocmd Filetype c 	set et ts=4 bs=2 sw=4 softtabstop=4
autocmd Filetype cpp 	set et ts=4 bs=2 sw=4 softtabstop=4
autocmd Filetype python set et ts=4 bs=2 sw=4 softtabstop=4
autocmd FileType yaml 	set et ts=4 bs=2 sw=4 softtabstop=4
autocmd FileType tcl 	set et ts=4 bs=2 sw=4 softtabstop=4
autocmd FileType make 	set noexpandtab shiftwidth=4 softtabstop=0

