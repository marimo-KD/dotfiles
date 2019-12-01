set ambiwidth=single
set autoindent
set backspace=indent,eol,start
set clipboard=unnamedplus
set completeopt-=preview
set encoding=utf8
set expandtab
set hidden
set hlsearch
set ignorecase
set incsearch
set laststatus=2
set list
set listchars=tab:»\ ,trail:-,extends:»,precedes:«,nbsp:%
set mouse=a
set number
set shiftwidth=2
set signcolumn=yes
set smartcase
set smartindent
set softtabstop=2
set tabstop=2
set termguicolors
set ruler

nnoremap <S-h> ^
nnoremap <S-l> $
nnoremap <silent> <ESC><ESC> :noh<CR>

nnoremap <C-w>v :vsplit<CR>
nnoremap <C-w>s :split<CR>
"WMの設定と揃える
"
let g:python3_host_prog = "/home/marimo-kd/.local/share/virtualenvs/.neovim-L4xtE3iV/bin/python"

" dein settings {{{
if &compatible
  set nocompatible
endif
" dein.vimのディレクトリ
let s:dein_dir = expand('~/.neovim/plugin/')
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

autocmd BufWritePre * :%s/\s\+$//ge "行末の空白を自動消去"

autocmd FileType python setlocal sw=4 ts=4 sts=4 et

autocmd VimLeave * set guicursor=a:ver2-blinkon0


" カラースキーム及びシンタックスの設定
syntax enable
set background=dark
colorscheme onedark
