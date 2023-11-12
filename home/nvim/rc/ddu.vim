" hook_add {{{
" launcher
nnoremap <Space>d <cmd>Ddu
      \ source
      \ <CR>

" filer
nnoremap <Space>f <cmd>Ddu
      \ file -name=current-filer
      \ -ui=filer
      \ -source-option-file-path='`expand('%:p:h')`'
      \ <CR>

nnoremap ss <cmd>Ddu
      \ -name=file
      \ buffer file_old file_point
      \ file_ff -source-option-file_ff-volatile
      \ file_ff -source-option-file_ff-new -source-option-file_ff-volatile
      \ -unique -sync -expandInput
      \ -ui-param-ff-displaySourceName=short
      \ <CR>

" buffer
nnoremap <Space>b <cmd>Ddu
      \ buffer 
      \ file_rec -source-option-file_rec-path='`expand('%:p:h')`'
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
call ddu#custom#load_config(g:base_dir .. 'ddu.ts')
" }}}
