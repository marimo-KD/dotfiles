if &compatible
  set nocompatible
endif
syntax off
filetype off
let g:base_dir = fnamemodify(expand('<sfile>'), ':h') .. '/rc/'

if filereadable(expand('~/.secretvimrc'))
  source ~/.secretvimrc
endif

if has('nvim')
  lua if vim.loader then vim.loader.enable() end
endif

source `=g:base_dir .. 'dein.rc.vim'`

filetype plugin indent on
syntax on

"source `=g:base_dir .. 'statusline.rc.vim'`

if has('nvim')
  colorscheme catppuccin
else
  colorscheme gruvbox8
endif

set secure
