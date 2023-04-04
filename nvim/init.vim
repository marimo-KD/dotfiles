if &compatible
  set nocompatible
endif
syntax off
filetype off
let g:base_dir = fnamemodify(expand('<sfile>'), ':h') .. '/'
let g:python3_host_prog = '/usr/bin/python3'

if filereadable(expand('~/.secretvimrc'))
  source ~/.secretvimrc
endif

if has('nvim')
  lua if vim.loader then vim.loader.enable() end
endif

source `=g:base_dir .. 'rc/dein.rc.vim'`

filetype plugin indent on
syntax on

source `=g:base_dir .. 'rc/statusline.rc.vim'`

colorscheme material

set secure
