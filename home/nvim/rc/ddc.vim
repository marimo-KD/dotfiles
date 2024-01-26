" hook_add {{{
nnoremap : <cmd>call CommandlinePre()<CR>:
function! CommandlinePre() abort
  " Note: This disables default command line completion!
  let b:prev_buffer_config = ddc#custom#get_buffer()
  
  call ddc#custom#patch_buffer('sourceOptions', #{
  \ _: #{
  \   keywordPattern: '[0-9a-zA-Z_:#-]*',
  \ },
  \ })

  autocmd User DDCCmdlineLeave ++once call CommandlinePost()

  " Enable command line completion
  call ddc#enable_cmdline_completion()
endfunction
function! CommandlinePost() abort
  " Restore sources
  if exists('b:prev_buffer_config')
    call ddc#custom#set_buffer(b:prev_buffer_config)
    unlet b:prev_buffer_config
  endif
endfunction

" }}}
" hook_source {{{
inoremap <C-n> <cmd>call pum#map#insert_relative(+1)<CR>
inoremap <C-p> <cmd>call pum#map#insert_relative(-1)<CR>
inoremap <C-y> <cmd>call pum#map#confirm()<CR>
inoremap <expr> <C-e> pum#visible()
  \ ? '<cmd>call pum#map#cancel()<CR>'
  \ : '<End>'

inoremap <expr> <Tab> denippet#jumpable() ? '<Plug>(denippet-jump-next)' : '<Tab>'
inoremap <expr> <S-Tab> denippet#jumpable(-1) ? '<Plug>(denippet-jump-prev)' : '<S-Tab>'
snoremap <expr> <Tab> denippet#jumpable() ? '<Plug>(denippet-jump-next)' : '<Tab>'
snoremap <expr> <S-Tab> denippet#jumpable(-1) ? '<Plug>(denippet-jump-prev)' : '<S-Tab>'

cnoremap <C-n>   <cmd>call pum#map#insert_relative(+1)<CR>
cnoremap <C-p>   <cmd>call pum#map#insert_relative(-1)<CR>
cnoremap <C-y>   <cmd>call pum#map#confirm()<CR>
cnoremap <expr> <C-e> pum#visible()
      \ ? '<cmd>call pum#map#cancel()<CR>'
      \ : '<End>'

call ddc#custom#patch_global(#{
  \ autoCompleteEvents: [
  \   'InsertEnter', 'TextChangedI', 'TextChangedP', 'CmdlineEnter', 'CmdlineChanged',
  \ ],
  \ backspaceCompletion: v:true,
  \ ui: 'pum',
  \ sources: ['lsp', 'denippet', 'around', 'file'],
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
  \     converters: ['converter_fuzzy'],
  \     timeout: 1000,
  \   },
  \   around: #{mark: '[A]',
  \             matchers: ['matcher_head', 'matcher_length'],
  \             converters: ['converter_remove_overlap'],},
  \   buffer: #{mark: '[B]',
  \             matchers: ['matcher_head', 'matcher_length'],
  \             converters: ['converter_remove_overlap'],},
  \   cmdline: #{mark: '[cmd]', forceCompletionPattern: "\\S/\\S*|\\.\\w*",},
  \   cmdline-history: #{mark: '[cmd]',
  \                      matchers: ['matcher_head', 'matcher_length'],
  \                      converters: ['converters_remove_overlap']},
  \   file: #{mark: '[f]', isVolatile: v:true, forceCompletionPattern: '\S/\S*',},
  \   input: #{mark: '[input]'},
  \   necovim: #{mark: '[neco]'},
  \   nvim-lua: #{mark: '[lua]', forceCompletionPattern: '\.\w*'},
  \   lsp: #{mark: '[lsp]', 
  \          keywordPattern: '\k+',
  \          forceCompletionPattern: '\.\w*|::\w*|->\w*',
  \          dup: 'keep',
  \          sorters: ['sorter_fuzzy', 'sorter_lsp-kind'],
  \          converters: ['converter_fuzzy', 'converter_kind_labels'],
  \          minAutoCompleteLength: 1,},
  \   skkeleton: #{mark: '[skk]',
  \                matchers: [],
  \                sorters: [],
  \                converters: [],
  \                minAutoCompleteLength: 2,
  \                isVolatile: v:true,},
  \   vsnip: #{mark: '[vsnip]'},
  \   denippet: #{mark: '[snip]'},
  \   shell-native: #{mark: '[zsh]', isVolatile: v:true, forceCompletionPattern: '\S/\S*',},
  \ },
  \ sourceParams: #{
  \   buffer: #{
  \     requireSameFiletype: v:false,
  \     limitBytes: 500000,
  \     fromAltBuf: v:true,
  \     fourceCollect: v:true,
  \   },
  \   lsp: #{
  \     snippetEngine: denops#callback#register({
  \           body -> denippet#anonymous(body)
  \     }),
  \     enableResolveItem: v:true,
  \     enableAdditionalTextEdit: v:true,
  \   },
  \ },
  \ filterParams: #{
  \   matcher_fuzzy: #{
  \     splitMode: 'word',
  \   },
  \   converter_kind_labels: #{
  \     kindLabels: #{
  \       Text: "",
  \       Method: "",
  \       Function: "",
  \       Constructor: "",
  \       Field: "",
  \       Variable: "",
  \       Class: "",
  \       Interface: "",
  \       Module: "",
  \       Property: "",
  \       Unit: "",
  \       Value: "",
  \       Enum: "",
  \       Keyword: "",
  \       Snippet: "",
  \       Color: "",
  \       File: "",
  \       Reference: "",
  \       Folder: "",
  \       EnumMember: "",
  \       Constant: "",
  \       Struct: "",
  \       Event: "",
  \       Operator: "",
  \       TypeParameter: ""
  \     },
  \     kindHlGroups: #{
  \       Method: "Function",
  \       Function: "Function",
  \       Constructor: "Function",
  \       Field: "Identifier",
  \       Variable: "Identifier",
  \       Class: "Structure",
  \       Interface: "Structure"
  \     }
  \   }
  \ }
  \ })
call ddc#custom#patch_filetype(
  \ ['zsh', 'deol'], 'sources',
  \ ['shell-native', 'file']
  \)
call ddc#custom#patch_filetype(
  \ ['vim'], 'sources',
  \ ['necovim', 'around', 'file']
  \ )
call ddc#enable_terminal_completion()
call ddc#enable(#{
  \ context_filetype: has('nvim') ? 'treesitter' : 'context_filetype',
  \ })
" }}}
" hook_post_update {{{
call ddc#set_static_import_path()
" }}}
