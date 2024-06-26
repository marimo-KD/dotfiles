let s:cache_home = empty($XDG_CACHE_HOME) ? expand('~/.cache') : $XDG_CACHE_HOME

function InitPlugin(plugin)
  let dir = s:cache_home .. '/dpp/repos/github.com/' .. a:plugin
  if !(dir->isdirectory())
    execute '!git clone https://github.com/' .. a:plugin dir
  endif
  
  execute 'set runtimepath^='
        \ .. dir->fnamemodify(':p')->substitute('[/\\]$', '', '')
endfunction

call InitPlugin('Shougo/dpp.vim')
call InitPlugin('Shougo/dpp-ext-lazy')


let g:dpp_dir = s:cache_home .. '/dpp'

function DppMakeState()
  call dpp#make_state(g:dpp_dir, g:base_dir .. '/dpp.ts')
endfunction

if dpp#min#load_state(g:dpp_dir)
  for s:plugin in [
        \   'Shougo/dpp-ext-installer',
        \   'Shougo/dpp-ext-local',
        \   'Shougo/dpp-ext-packspec',
        \   'Shougo/dpp-ext-toml',
        \   'Shougo/dpp-protocol-git',
        \   'vim-denops/denops.vim',
        \ ]
    call InitPlugin(s:plugin)
  endfor

  "if has('nvim')
  "  runtime! plugin/denops.vim
  "  echomsg 'denops is loaded'
  "endif

  augroup MyAutoCmd
    autocmd User DenopsReady
          \ : echohl WarningMsg
          \ | echomsg 'dpp load_state() is failed'
          \ | echohl NONE
          \ | call DppMakeState()
          \ | echomsg 'dpp make_state() is called'
  augroup END
endif

augroup MyAutoCmd
  autocmd User Dpp:makeStatePost
        \ : echohl WarningMsg
        \ | echomsg 'dpp make_state() is done'
        \ | echohl NONE
augroup END
