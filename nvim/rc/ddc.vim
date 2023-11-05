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
      \ '<Tab>' : ddc#map#manual_complete()
inoremap <S-Tab> <cmd>call pum#map#insert_relative(-1)<CR>
inoremap <C-n> <cmd>call pum#map#insert_relative(+1)<CR>
inoremap <C-p> <cmd>call pum#map#insert_relative(-1)<CR>
inoremap <C-y> <cmd>call pum#map#confirm()<CR>
inoremap <expr> <C-e> ddc#visible() ?
      \ ? '<cmd>call ddc#hide()<CR>'
      \ : '<End>'

cnoremap <silent><expr> <Tab>
      \ pum#visible() ? '<Cmd>call pum#map#insert_relative(+1)<CR>' :
      \ 'ddc#manual_complete()
cnoremap <S-Tab> <Cmd>call pum#map#insert_relative(-1)<CR>
cnoremap <C-n>   <Cmd>call pum#map#insert_relative(+1)<CR>
cnoremap <C-p>   <Cmd>call pum#map#insert_relative(-1)<CR>
cnoremap <C-y>   <Cmd>call pum#map#confirm()<CR>
cnoremap <expr> <C-e> ddc#visible() ?
      \ ? '<cmd>call ddc#hide()<CR>'
      \ : '<End>'

call ddc#custom#patch_global(#{
  \ autoCompleteEvents: [
  \   'InsertEnter', 'TextChangedI', 'TextChangedP', 'TextChangedT', 'CmdlineEnter', 'CmdlineChanged',
  \ ],
  \ ui: 'pum',
  \ sources: ['buffer', 'file', 'nvim-lsp', 'vsnip'],
  \ cmdlineSources: {
  \   ':': ['cmdline', 'around'],
  \   '@': ['cmdline', 'around', 'file'],
  \   '>': ['cmdline', 'around', 'file'],
  \   '/': ['around',],
  \   '?': ['around',],
  \   '-': ['around',],
  \   '=': ['input',],
  \ },
  \ sourceOptions: #{
  \   _: #{
  \     ignoreCase: v:true,
  \     matchers: ['matcher_fuzzy'],
  \     sorters : ['sorter_fuzzy'],
  \     converters: ['converter_remove_overlap', 'converter_fuzzy'],
  \     timeout: 1000,
  \   },
  \   around: #{mark: '[A]' },
  \   buffer: #{mark: '[B]'},
  \   cmdline: #{mark: '[cmd]', forceCompletionPattern: "\\S/\\S*|\\.\\w*",},
  \   eskk: #{mark: '[eskk]', matchers: [], sorters: [], minAutoCompleteLength: 1,},
  \   file: #{mark: '[f]', isVolatile: v:true, forceCompletionPattern: '\S/\S*',},
  \   input: #{mark: '[input]'},
  \   necovim: #{mark: '[neco]'},
  \   nvim-lua: #{mark: '[lua]', forceCompletionPattern: '\.\w*'},
  \   nvim-lsp: #{mark: '[lsp]', forceCompletionPattern: '\.\w*|::\w*|->\w*', dup: 'force'},
  \   skkeleton: #{mark: '[skk]', matchers: ['skkeleton'], sorters:[], minAutoCompleteLength: 2, isVolatile: v:true,},
  \   vsnip: #{mark: '[vsnip]'},
  \   shell-native: #{mark: '[zsh]', isVolatile: v:true, forceCompletionPattern: '\S/\S*',},
  \ },
  \ sourceParams: #{
  \   buffer: #{
  \     requireSameFiletype: v:false,
  \     limitBytes: 500000,
  \     fromAltBuf: v:true,
  \     fourceCollect: v:true,
  \   },
  \   nvim-lsp: #{
  \     useIcon: v:true,
  \     snippetEngine: denops#callback#register({
  \           body -> vsnip#anonymous(body)
  \     }),
  \     enableResolveItem: v:true,
  \     enableAdditionalTextEdit: v:true,
  \   },
  \ },
  \ })
call ddc#enable_terminal_completion()
call ddc#enable(#{
  \ context_filetype: has('nvim') ? 'treesitter' : 'context_filetype',
  \ })
" }}}
