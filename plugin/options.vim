set redrawtime=5000
set mousetime=500
set writedelay=0
set ttimeout
set ttimeoutlen=5
set timeoutlen=500
set updatetime=15

set hidden
set modifiable

set sessionoptions=buffers,folds,tabpages,winpos
set viewoptions+=folds
set completeopt=menu,preview
set diffopt=internal,filler,vertical,foldcolumn:0
set diffopt+=context:18,algorithm:patience,followwrap
set clipboard=unnamedplus
set mouse=a

set inccommand=nosplit
set incsearch
set ignorecase
set smartcase
set nohlsearch

set guicursor=
set nonu
set nocursorline
set nocursorcolumn
set noshowmode
set noruler
set showtabline=1
set tabpagemax=100000
set cmdheight=1
set shortmess+=c
set laststatus=2
set wildmenu
set conceallevel=0
set signcolumn=yes
set synmaxcol=3000
set wrap
set termguicolors


set background=dark
if $ENABLE_DARK_MODE == "0"
  set background=light
endif

set wildignore=.cache,.svn,.git,*.o,*.a,*.so,*.obj,*.swp
set tags=tags
set shada=!,'50,<3,s10,h
set history=10000
set noswapfile
set nobackup
set noexrc
set nowritebackup
set undofile
set undodir=~/.cache/undodir
set undolevels=1000
set undoreload=10000
set modeline

set fillchars=vert:\│,eob:\ 

set autoindent
set backspace=indent,eol,start
set expandtab
set tabstop=2
set shiftwidth=2
set softtabstop=2

set iskeyword+=-
set formatoptions -=cro |
set cinkeys -=: |
set indentkeys -=<:>,0- |
set splitbelow
set splitright

syntax on
filetype indent on
filetype plugin on
runtime! ftplugin/man.vim
let g:ft_man_open_mode = 'tab'
