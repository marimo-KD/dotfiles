"Disable default plugins
let g:loaded_2html_plugin      = 1
let g:loaded_getscriptPlugin   = 1
let g:loaded_gzip              = 1
let g:loaded_logiPat           = 1
let g:loaded_man               = 1
let g:loaded_matchit           = 1
let g:loaded_matchparen        = 1
let g:loaded_netrwFileHandlers = 1
let g:loaded_netrwPlugin       = 1
let g:loaded_netrwSettings     = 1
let g:loaded_shada_plugin      = 1
let g:loaded_tarPlugin         = 1
let g:loaded_tutor_mode_plugin = 1
let g:loaded_zipPlugin         = 1
" and disable fzf
let g:loaded_fzf               = 1

" Search
set hlsearch
set ignorecase
set incsearch
set smartcase

" Edit
" file encoding
set encoding=utf-8
" indent
set autoindent
set smartindent
" tab
set expandtab
set softtabstop=2
set shiftwidth=2
set tabstop=2
" Omni Completion
if has('nvim')
  set completeopt=menuone,longest
else
  set completeopt=menuone,longest,popup
endif
" backspace
set backspace=indent,eol,start
" clipboard
set clipboard=unnamedplus
" abandoned buffer is hidden
set hidden

" View
set list
set listchars=tab:»\ ,trail:-,extends:»,precedes:«,nbsp:%
set shortmess=aTIcF
set number
set relativenumber
set signcolumn=yes

" TrueColor
set t_Co=256
if exists("+termguicolors") && $COLORTERM ==# 'truecolor'
  set termguicolors
endif

" Disable ShaDa
set shada="NONE"

" Set ambiwidth
set ambiwidth=single

" Enable mouse
set mouse=a

" Set foldmethod
set foldmethod=marker
