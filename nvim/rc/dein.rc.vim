let s:cache_home = empty($XDG_CACHE_HOME) ? expand('~/.cache') : $XDG_CACHE_HOME

if &runtimepath !~# '/dein.vim'
  let s:dein_repo_dir = s:cache_home .. '/dein/repos/github.com/Shougo/dein.vim'
  if !isdirectory(s:dein_repo_dir)
    execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
  endif
  execute 'set runtimepath^=' .. s:dein_repo_dir
endif

let s:dein_dir = s:cache_home . '/dein'
let g:dein#auto_recache = v:true
let g:dein#lazy_rplugins = v:true
let g:dein#inline_vimrcs = ['options.rc.vim', 'mappings.rc.vim']
let g:dein#enable_notification = v:true
let g:dein#install_check_diff = v:true

call map(g:dein#inline_vimrcs, "resolve(g:base_dir .. 'rc/' ..  v:val)")

if dein#min#load_state(s:dein_dir) 
  let s:toml = g:base_dir .. 'dein.toml'
  let s:toml_lazy = g:base_dir .. 'dein_lazy.toml'
  let s:toml_ddc = g:base_dir .. 'dein_ddc.toml'
  let s:toml_ddu = g:base_dir .. 'dein_ddu.toml'
  let s:toml_ft = g:base_dir .. 'dein_ft.toml'

  call dein#begin(s:dein_dir)
  call dein#load_toml(s:toml, {'lazy': 0})
  call dein#load_toml(s:toml_lazy, {'lazy': 1})
  call dein#load_toml(s:toml_ddc, {'lazy': 1})
  call dein#load_toml(s:toml_ddu, {'lazy': 1})
  call dein#load_toml(s:toml_ft)
  call dein#end()
  call dein#save_state()
endif
