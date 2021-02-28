" dein settings
if &compatible
  set nocompatible
endif

let g:config_home = empty($XDG_CONFIG_HOME) ? expand('~/.config') : $XDG_CONFIG_HOME
let g:cache_home = empty($XDG_CACHE_HOME) ? expand('~/.cache') : $XDG_CACHE_HOME
let g:python3_host_prog = '/usr/bin/python3'

function! s:source_rc(path) abort
  let abspath = resolve(expand(g:config_home . '/nvim/rc/' . a:path))
  execute 'source' fnameescape(abspath)
endfunction

if has('vim_starting')
  call s:source_rc('init.rc.vim')
endif

call s:source_rc('dein.rc.vim')

silent! filetype plugin indent on
syntax on
filetype detect

autocmd VimLeave * set guicursor=a:ver2-blinkon0

set secure
