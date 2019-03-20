set termguicolors
set encoding=utf8
set number
set backspace=indent,eol,start
set mouse=a
set laststatus=2
set list
set listchars=tab:»\ ,trail:-,extends:»,precedes:«,nbsp:%
set ruler
set clipboard=unnamedplus
set autoindent
set tabstop=2
set softtabstop=2
set shiftwidth=2
set expandtab
set smartindent

set incsearch
set ignorecase
set smartcase
set hlsearch
set ambiwidth=single
set signcolumn=yes
set hidden

autocmd BufWritePre * :%s/\s\+$//ge "行末の空白を自動消去"

autocmd FileType python setlocal sw=4 ts=4 sts=4 et

autocmd VimLeave * set guicursor=a:ver2-blinkon0

inoremap <silent> jj <ESC>
inoremap <silent> っｊ <ESC>
inoremap <C-j> <Down>
inoremap <C-k> <Up>
inoremap <C-h> <Left>
inoremap <C-l> <Right>

nnoremap <S-h> ^
nnoremap <S-l> $
nnoremap <silent> <ESC><ESC> :noh<CR>
nnoremap あ a
nnoremap い i
nnoremap う u
nnoremap お o

nnoremap <C-w>v :vsplit<CR>
nnoremap <C-w>b :split<CR>
"WMの設定と揃える

" dein settings {{{
if &compatible
  set nocompatible
endif
" dein.vimのディレクトリ
let s:dein_dir = expand('~/.cache/dein')
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'

" なければgit clone
if !isdirectory(s:dein_repo_dir)
  execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
endif
execute 'set runtimepath^=' . s:dein_repo_dir

if dein#load_state(s:dein_dir)
  call dein#begin(s:dein_dir)

  " 管理するプラグインを記述したファイル
  let s:toml = '~/.config/nvim/dein.toml'
  let s:toml_lazy = '~/.config/nvim/dein_lazy.toml'
  call dein#load_toml(s:toml, {'lazy': 0})
  call dein#load_toml(s:toml_lazy, {'lazy': 1})

  call dein#end()
  call dein#save_state()
endif
" 適宜 call dein#update や call dein#clear_state を呼ぶ。

" インストールしていないものはここに入れる
if dein#check_install()
  call dein#install()
endif
" }}}



" カラースキーム及びシンタックスの設定
syntax enable
set background=dark
colorscheme onedark

highlight Normal guibg=none
