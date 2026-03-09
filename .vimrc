" .vimrc

" General
set nocompatible
set encoding=utf-8
set fileencoding=utf-8
set fileformat=unix
set backspace=indent,eol,start

" Indentation (4 spaces, no tabs)
set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4
set autoindent
set smartindent

" Display
set number
set ruler
set showcmd
set showmatch
set laststatus=2
set wildmenu
set wildmode=longest:full,full
set scrolloff=3

" Search
set incsearch
set hlsearch
set ignorecase
set smartcase

" Performance
set lazyredraw
set ttyfast

" Files
set nobackup
set nowritebackup
set noswapfile
set autoread

" Colors
syntax enable
set background=dark
if &t_Co >= 256
    set termguicolors
endif

" Whitespace visibility
set list
set listchars=tab:»·,trail:·,nbsp:·

" Trim trailing whitespace on save
autocmd BufWritePre * :%s/\s\+$//e

" Filetype specific
filetype plugin indent on
autocmd FileType make setlocal noexpandtab
