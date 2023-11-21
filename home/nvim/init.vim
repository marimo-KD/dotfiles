if &compatible
  set nocompatible
endif
syntax off
filetype off
const g:base_dir = fnamemodify(expand('<sfile>'), ':h') .. '/rc'

if filereadable(expand('~/.secretvimrc'))
  source ~/.secretvimrc
endif

if has('nvim')
  lua if vim.loader then vim.loader.enable() end
endif

source `=g:base_dir .. '/dpp.vim'`

filetype plugin indent on
syntax on

"source `=g:base_dir .. '/statusline.rc.vim'`

if has('nvim')
  colorscheme catppuccin
else
  colorscheme gruvbox8
endif

if executable('nvr')
  let $EDITOR = 'nvr -cc split -c "set bufhidden=delete" --remote-wait'
  unlet $MANPAGER
endif

if exists('g:neovide')
  set guifont=PlemolJP\ Console\ NF:h11
  let g:neovide_input_ime = v:false
  let g:neovide_floating_blur_amount_x = 2.0
  let g:neovide_floating_blur_amount_y = 2.0
  let g:neovide_cursor_antialiasing = v:true
endif

set secure
