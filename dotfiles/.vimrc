" ~/.vimrc - Vim configuration

" Basic settings
set nocompatible
set number
set relativenumber
set ruler
set showmatch
set hlsearch
set incsearch
set ignorecase
set smartcase

" Indentation
set autoindent
set smartindent
set tabstop=4
set shiftwidth=4
set expandtab

" Interface
set wildmenu
set laststatus=2
set backspace=indent,eol,start

" Colors
syntax enable
set background=dark

" Key mappings
let mapleader = ","
nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>