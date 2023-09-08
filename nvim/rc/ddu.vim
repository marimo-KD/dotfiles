" hook_add {{{
" launcher
nnoremap <Leader>d <cmd>call ddu#start(#{
\ name: 'source',
\ sources: [#{name: 'source'}],
\ uiParams : #{ff: #{floatingTitle: 'Source'}},
\ })<CR>

" file
nnoremap <Leader>f <cmd>call ddu#start(#{
\ name: 'file_rec',
\ sources: [#{name: 'file_rec'}],
\ uiParams : #{ff: #{floatingTitle: 'File'}},
\ })<CR>

" buffer
nnoremap <Leader>b <cmd>call ddu#start(#{
\ name: 'buffer',
\ sources: [#{name: 'buffer'}],
\ uiParams : #{ff: #{floatingTitle: 'Buffer'}},
\ })<CR>

" live grep
nnoremap <Leader>g <cmd>call ddu#start(#{
\ name: 'file',
\ volatile: v:true,
\ sources: [#{name: 'rg', options: {'matchers': []}}],
\ uiParams: #{
\   ff: #{
\     ignoreEmpty: v:false,
\     autoResize: v:false,
\     floatingTitle: 'Grep'
\   }
\ },
\ })<CR>

" filer
nnoremap <Leader>e <cmd>call ddu#start(#{
\ name: 'filer',
\ uiParams: #{filer: #{search: expand('%:p')}},
\ })<CR>
" }}}
" hook_source {{{
"ui
call ddu#custom#patch_global(#{
\ ui: 'ff',
\ uiParams: #{
\   ff: #{
\     floatingBorder: 'rounded',
\     floatingTitlePos: 'center',
\     filterFloatingPosition: 'bottom',
\     filterSplitDirection: 'floating',
\     previewFloating: v:true,
\     previewFloatingBorder: 'rounded',
\     previewFloatingTitle: [ ["Preview", "String"] ],
\     previewFloatingTitlePos: 'center',
\     previewSplit: 'horizontal',
\     displaySourceName: 'long',
\     split: 'floating',
\     prompt: '>',
\     winCol: &columns / 6,
\     winHeight: &lines / 2,
\     winRow: &lines / 4,
\     winWidth: &columns / 3 * 2,
\   },
\   filer: #{
\     floatingBorder: 'rounded',
\     previewFloating: v:true,
\     previewFloatingBorder: 'rounded',
\     split: 'floating',
\     splitDirection: 'topleft',
\     winCol: &columns / 6,
\     winHeight: &lines / 2,
\     winRow: &lines / 4,
\     winWidth: &columns / 3 * 2,
\   },
\ },
\ sourceParams: #{
\   rg: #{
\     args: ['--column', '--no-heading', '--color', 'never'],
\   }
\ },
\ sourceOptions: {
\   '_': #{
\     matchers: ['matcher_fzf'],
\     columns: ['icon_filename'],
\   },
\ },
\ kindOptions: #{
\   file: #{
\     defaultAction: 'open',
\   },
\   action: #{
\     defaultAction: 'do',
\   },
\   help: #{
\     defaultAction: 'vsplit',
\   },
\   source: #{
\     defaultAction: 'execute',
\   },
\ },
\ })
call ddu#custom#patch_local('filer', #{
\ ui: 'filer',
\ sources: [
\   #{
\     name: 'file',
\     params: {},
\   },
\ ],
\ })
" }}}
