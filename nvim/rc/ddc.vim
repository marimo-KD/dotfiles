" hook_add {{{
nnoremap : <cmd>call CommandlinePre()<CR>:
function! CommandlinePre() abort
  call dein#source('ddc.vim')
  call dein#source('neco-vim')
  " Note: This disables default command line completion!

  " Overwrite sources
  if !exists('b:prev_buffer_config')
    let b:prev_buffer_config = ddc#custom#get_buffer()
  endif
  call ddc#custom#patch_buffer('cmdlineSources',
          \ ['cmdline', 'around', 'necovim', 'file'])

  autocmd User DDCCmdlineLeave ++once call CommandlinePost()
  autocmd InsertEnter <buffer> ++once call CommandlinePost()

  " Enable command line completion
  call ddc#enable_cmdline_completion()
  call ddc#enable()
endfunction
function! CommandlinePost() abort
  " Restore sources
  if exists('b:prev_buffer_config')
    call ddc#custom#set_buffer(b:prev_buffer_config)
    unlet b:prev_buffer_config
  else
    call ddc#custom#set_buffer({})
  endif
endfunction
" }}}
" hook_source {{{
inoremap <silent><expr> <Tab>
      \ pum#visible() ? '<cmd>call pum#map#insert_relative(+1)<CR>' :
      \ (col('.') <= 1 <Bar><Bar> getline('.')[col('.') - 2] =~# '\s') ?
      \ '<Tab>' : ddc#manual_complete()
inoremap <S-Tab> <Cmd>call pum#map#insert_relative(-1)<CR>
inoremap <C-n> <cmd>call pum#map#insert_relative(+1)<CR>
inoremap <C-p> <cmd>call pum#map#insert_relative(-1)<CR>
inoremap <C-y> <cmd>call pum#map#confirm()<CR>
inoremap <C-e> <cmd>call pum#map#cancel()<CR>

cnoremap <silent><expr> <Tab>
      \ pum#visible() ? '<Cmd>call pum#map#insert_relative(+1)<CR>' :
      \ 'ddc#manual_complete()
cnoremap <S-Tab> <Cmd>call pum#map#insert_relative(-1)<CR>
cnoremap <C-n>   <Cmd>call pum#map#insert_relative(+1)<CR>
cnoremap <C-p>   <Cmd>call pum#map#insert_relative(-1)<CR>
cnoremap <C-y>   <Cmd>call pum#map#confirm()<CR>
cnoremap <C-e>   <Cmd>call pum#map#cancel()<CR>

call ddc#custom#patch_global(#{
  \ autoCompleteEvents: [
  \   'InsertEnter', 'TextChangedI', 'TextChangedP', 'CmdlineEnter', 'CmdlineChanged',
  \ ],
  \ ui: 'pum',
  \ sources: ['buffer', 'file', 'nvim-lsp', 'vsnip'],
  \ sourceOptions: #{
  \   _: #{
  \     matchers: ['matcher_fuzzy'],
  \     sorters : ['sorter_fuzzy'],
  \     converters: ['converter_remove_overlap', 'converter_fuzzy'],
  \   },
  \   around: #{mark: '[A]' },
  \   buffer: #{mark: '[B]'},
  \   cmdline: #{mark: '[cmd]'},
  \   eskk: #{mark: '[eskk]', matchers: [], sorters: [], minAutoCompleteLength: 1,},
  \   file: #{mark: '[f]', isVolatile: v:true, forceCompletionPattern: '\S/\S*',},
  \   necovim: #{mark: '[neco]'},
  \   nvim-lua: #{mark: '[lua]', forceCompletionPattern: '\.\w*'},
  \   nvim-lsp: #{mark: '[lsp]', forceCompletionPattern: '\.\w*|::\w*|->\w*', dup: 'force'},
  \   skkeleton: #{mark: '[skk]', matchers: ['skkeleton'], sorters:[], minAutoCompleteLength: 2, isVolatile: v:true,},
  \   vsnip: #{mark: '[vsnip]'},
  \   zsh: #{mark: '[zsh]', isVolatile: v:true, forceCompletionPattern: '\S/\S*',},
  \ },
  \ sourceParams: #{
  \   buffer: #{
  \     requireSameFiletype: v:true,
  \     limitBytes: 5000000,
  \     fromAltBuf: v:true,
  \     fourceCollect: v:true,
  \   },
  \   nvim-lsp: #{useIcon: v:true,},
  \ },
  \ })
call ddc#enable_terminal_completion()
call ddc#enable(#{
  \ context_filetype: has('nvim') ? 'treesitter' : 'context_filetype',
  \ })
" }}}
