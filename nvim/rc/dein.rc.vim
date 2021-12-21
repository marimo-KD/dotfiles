let s:dein_dir = g:cache_home . '/dein'
let g:dein#auto_recache = v:true
let g:dein#lazy_rplugins = v:true
let g:dein#inline_vimrcs = ['options.rc.vim', 'mappings.rc.vim']

source ~/.secretvimrc

call map(g:dein#inline_vimrcs, "resolve(g:config_home . '/nvim/rc/' . v:val)")
if !dein#load_state(s:dein_dir) 
  finish
endif

let s:base_path = '~/.config/nvim'
let s:toml = s:base_path . '/dein.toml'
let s:toml_lazy = s:base_path . '/dein_lazy.toml'
let s:toml_ddc = s:base_path . '/dein_ddc.toml'
let s:toml_ft = s:base_path . '/dein_ft.toml'

call dein#begin(s:dein_dir, [expand('<sfile>'), s:toml, s:toml_lazy, s:toml_ft])
call dein#load_toml(s:toml, {'lazy': 0})
call dein#load_toml(s:toml_lazy, {'lazy': 1})
call dein#load_toml(s:toml_ddc, {'lazy': 1})
call dein#load_toml(s:toml_ft)
call dein#end()
call dein#save_state()

command! DeinUpdate call dein#check_update(v:true)

if !has('vim_starting') && dein#check_install() 
  call dein#install()
endif
