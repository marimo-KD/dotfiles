" hook_add {{{
" launcher
nnoremap <Space>d <cmd>Ddu
      \ source
      \ <CR>

" filer
nnoremap <Space>f <cmd>Ddu
      \ file -name=filer
      \ -ui=filer
      \ -resume
      \ -source-option-file-path=`t:->get('ddu_ui_filer_path', getcwd())`
      \ <CR>

nnoremap ss <cmd>Ddu
      \ -name=file
      \ file_old file_point
      \ file_ff -source-option-file-volatile
      \ file_ff -source-option-file-new -source-option-file-volatile
      \ -unique -sync -expandInput
      \ -ui-param-ff-displaySourceName=short
      \ <CR>

" buffer
nnoremap <Space>b <cmd>Ddu
      \ buffer
      \ <CR>

" search
nnoremap / <cmd>Ddu
      \ line -name=search
      \ -ui-param-ff-startFilter=v:true
      \ <CR>

nnoremap * <cmd>Ddu
      \ line -name=search
      \ -input=`expand('<cword>')`
      \ -ui-param-ff-startFilter=v:false
      \ <CR>

" resume
nnoremap n <cmd>Ddu
      \ -resume -name=search
      \ -ui-param-ff-startFilter=v:false
      \ <CR>

" grep
nnoremap <Space>g <cmd>Ddu
      \ rg -name=search
      \ -source-param-rg-input='`'Pattern: '->input('<cword>'->expand())`'
      \ -ui-param-ff-ignoreEmpty
      \ <CR>

" command output
nnoremap <Space>o <cmd>Ddu
      \ output -name=output
      \ -source-param-output-command='`'Command: '->input('', 'command')`'
      \ <CR>

" }}}
" hook_source {{{
call ddu#custom#alias('column', 'icon_filename_ff', 'icon_filename')
call ddu#custom#alias('source', 'file_ff', 'file')
call ddu#custom#patch_global(#{
\ ui: 'ff',
\ uiParams: #{
\   ff: #{
\     displaySourceName: 'long',
\     floatingBorder: 'rounded',
\     floatingTitlePos: 'center',
\     filterFloatingPosition: 'bottom',
\     filterSplitDirection: 'floating',
\     previewFloating: v:true,
\     previewFloatingBorder: 'rounded',
\     previewFloatingTitle: [ ["Preview", "String"] ],
\     previewFloatingTitlePos: 'center',
\     previewSplit: 'horizontal',
\     split: 'floating',
\     prompt: '>',
\     winWidth: 100,
\   },
\   filer: #{
\     floatingBorder: 'rounded',
\     previewFloating: v:true,
\     previewFloatingBorder: 'rounded',
\     split: 'no',
\     splitDirection: 'topleft',
\     toggle: v:true,
\   },
\ },
\ sourceParams: #{
\   rg: #{
\     args: ['--column', '--no-heading', '--color', 'never'],
\   }
\ },
\ sourceOptions: #{
\   _: #{
\     ignoreCase: v:true,
\     smartCase: v:true,
\     matchers: ['matcher_fzf'],
\   },
\   file: #{
\     converters: ['converter_hl_dir'],
\     columns: ['icon_filename'],
\   },
\   file_ff: #{
\     converters: ['converter_hl_dir'],
\     columns: ['icon_filename_ff'],
\   },
\   file_old: #{
\     matchers: ['matcher_relative', 'matcher_fzf'],
\     converters: ['converter_hl_dir'],
\     columns: ['icon_filename_ff'],
\   },
\   file_rec: #{
\     converters: ['converter_hl_dir'],
\     columns: ['icon_filename_ff'],
\   },
\   line: #{
\     matchers: ['matcher_substring'],
\   },
\ },
\ kindOptions: #{
\   action: #{
\     defaultAction: 'do',
\   },
\   file: #{
\     defaultAction: 'open',
\   },
\   help: #{
\     defaultAction: 'vsplit',
\   },
\   lsp: #{
\     defaultAction: 'open',
\   },
\   lsp_codeAction: #{
\     defaultAction: 'apply',
\   },
\   source: #{
\     defaultAction: 'execute',
\   },
\   url: #{
\     defaultAction: 'browse',
\   },
\ },
\ columnParams: #{
\   icon_filename_ff: #{pathDisplayOption : 'relative'}
\ }
\ })
" }}}
